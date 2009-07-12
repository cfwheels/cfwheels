<cfcomponent output="false" mixin="none">
	<cfinclude template="plugins/injection.cfm">

	<cfset variables.$instance.repos = {}>
	<cfset variables.$instance.repo = "_wheels">
	<cfset variables.$instance.pluginsPath = ExpandPath("plugins/")>

	<!--- add default wheels repo --->
	<cfset $registerRepo(
			repo="_wheels"
			,name="Official Wheels Plugin Repository"
			,location="http://code.google.com/p/cfwheels/downloads/list?can=2&q=label:plugin&sort=-filename&colspec=Filename%20Summary"
			,parser="$GoogleCode"
			,autoParse="false"
		)>
		
	<!--- make sure that plugin directory exists --->
	<cfset $createPluginDir()>

	<cffunction name="$init" mixin="none">
		<cfargument name="autoParse" type="boolean" required="false" default="false">
		<cfif arguments.autoParse>
			<cfset $parseRepo($getRepo())>
		</cfif>
		<cfreturn this>
	</cffunction>

	<!---
		dependency
	 --->

	<!---
		make sure that these plugins are installed before we install out plugin
		call from within your plugin's init().
	 --->
	<cffunction name="$dependency" mixin="none" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc = {}>
		<cfif not $isInstalledPlugin(argumentcollection=arguments)>
			<cfset $installPlugin(argumentcollection=arguments)>
		</cfif>
	</cffunction>


	<!---
		Plugins
	 --->

	<!--- used to register a plugin to the list of available plugins for a repo --->
	<cffunction name="$registerPlugin" mixin="none" returntype="void">
		<cfargument name="repo" type="string" required="true">
		<cfargument name="fullname" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="link" type="string" required="true">
		<cfargument name="compatible" type="string" required="true">
		<cfif !structkeyexists(variables.$instance.repos[arguments.repo]["plugins"], arguments.name)>
			<cfset variables.$instance.repos[arguments.repo]["plugins"][arguments.name] = []>
		</cfif>
		<cfset arrayappend(variables.$instance.repos[arguments.repo]["plugins"][arguments.name], arguments)>
	</cffunction>
	
	<!--- downloads the plugin from a repo --->
	<cffunction name="$downloadPlugin" mixin="none" returntype="void">
		<cfargument name="fileName" type="string" required="true">
		<cfargument name="link" type="string" required="true">
		<cfset var loc = StructNew()>
		
		<cfset loc.installPluginFullPath = "#variables.$instance.pluginsPath##arguments.fileName#">
		<!--- no need to install the plugin again if they already have it. --->
		<cfif not FileExists(loc.installPluginFullPath)>

			<!--- download and install --->
			<cfhttp url="#arguments.link#" result="loc.fileData" method="GET" getAsBinary="yes">
			<cfset loc.data = loc.fileData.FileContent>
			<cffile action="write" file="#loc.installPluginFullPath#" output="#loc.data#" mode="777">

		</cfif>
	</cffunction>

	<!--- installs the plugin from the repository --->
	<cffunction name="$installPlugin" mixin="none" returntype="struct">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc = StructNew()>

		<cfset loc.version = $selectPlugin(argumentcollection=arguments)>

		<cfif not structisempty(loc.version)>

			<cfset $downloadPlugin(
					fileName="#loc.version.fullname#"
					,link="#loc.version.link#"
				)>
			
			<cfset $unpackPlugin(
					zipFile="#loc.version.fullname#"
					,name="#loc.version.name#"
				)>

		</cfif>

		<cfreturn loc.version>
	</cffunction>
	
	<!--- unpacks a plugin --->
	<cffunction name="$unpackPlugin" mixin="none" returntype="void">
		<cfargument name="zipFile" type="string" required="true">
		<cfargument name="name" type="string" required="false" default="">
		<cfset var loc = {}>
				
		<!---
		if the name attribute wasn't passed then assume the first part of the 
		zipFile is the name.
		
		zipfile: ModelValidators-0.3.zip
		name: ModelValidators
		 ---> 
		<cfif not len(arguments.name)>
			<cfset arguments.name = listfirst(arguments.zipFile, "-")>
		</cfif>
		
		<cfset loc.installPluginFullPath = "#variables.$instance.pluginsPath##arguments.zipFile#">
		<cfset loc.installedPluginDir = "#variables.$instance.pluginsPath##arguments.name#">
		<!--- unpack the plugin --->
		<cfif not DirectoryExists(loc.installedPluginDir)>
			<cfdirectory action="create" directory="#loc.installedPluginDir#" mode="777">
		</cfif>
		<cfzip action="unzip" destination="#loc.installedPluginDir#" file="#loc.installPluginFullPath#" overwrite="#application.wheels.overwritePlugins#">		
	</cffunction>
	
	<!--- unpacks all plugins --->
	<cffunction name="$unpackAllPlugins" mixin="none" returntype="void">
		<cfset var loc = {}>
		<cfdirectory action="list" directory="#variables.$instance.pluginsPath#" name="loc.dir" type="file" filter="*.zip">
		<cfloop query="loc.dir">
			<cfset $unpackPlugin(name)>
		</cfloop>
	</cffunction>	
	
	<!--- uninstall the plugin --->
	<cffunction name="$uninstallPlugin" mixin="none" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="false" default="">
		<cfset var loc = {}>
		<cfset loc.removeZips = []>
		<cfset loc.installPluginFullPath = "#variables.$instance.pluginsPath##arguments.name#-#arguments.version#.zip">

		<!--- if the version was not passed then remove all versions of the plugins --->
		<cfset loc.args = {}>
		<cfset loc.args.action = "list">
		<cfset loc.args.directory = "#variables.$instance.pluginsPath#">
		<cfset loc.args.name = "loc.dir">
		<cfset loc.args.type = "file">
		<cfset loc.args.filter = "#arguments.name#-#arguments.version#.zip">
		<cfif not len(arguments.version)>
			<cfset loc.args.filter = "#arguments.name#*.zip">
		</cfif>

		<cfdirectory attributecollection="#loc.args#">

		<cfloop query="loc.dir">
			<cfif listfirst(loc.dir.name, "-") eq arguments.name>
				<cfset arrayappend(loc.removeZips, loc.dir.name)>
			</cfif>
		</cfloop>

		<!--- remove the zip file for the plugin --->
		<cfloop array="#loc.removeZips#" index="loc.i">
			<cffile action="delete" file="#variables.$instance.pluginsPath##loc.i#">
		</cfloop>

		<!--- remove the directory --->
		<cfset loc.installedPluginDir = "#variables.$instance.pluginsPath##arguments.name#">
		<cfif DirectoryExists(loc.installedPluginDir)>
			<cfdirectory action="delete" directory="#loc.installedPluginDir#" recurse="true">
		</cfif>

		<cfset $unloadPlugin(arguments.name)>
	</cffunction>

	<!--- load plugin into memory --->
	<cffunction name="$loadPlugin" mixin="none" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfset var loc = {}>
		<cfif left(arguments.name, 1) eq ".">
			<cfreturn>
		</cfif>
		<cfset loc.pluginComponentPath = [application.wheels.rootcomponentPath, "plugins", arguments.name, arguments.name]>
		<cfset loc.pluginComponentPath = listchangedelims(arraytolist(loc.pluginComponentPath, "."), ".", ".")>
		<cfset loc.plugin = createobject("component", loc.pluginComponentPath).init()>
		<cfset $canLoad(loc.plugin)>
		<cfif
			not StructKeyExists(loc.plugin, "version")
			or loc.plugin.version eq SpanExcluding(application.wheels.version, " ")
			or application.wheels.loadIncompatiblePlugins
			>
			<cfset application.wheels.plugins[arguments.name] = loc.plugin>
			<cfif
				StructKeyExists(loc.plugin, "version")
				and loc.plugin.version neq SpanExcluding(application.wheels.version, " ")
				>
				<cfset application.wheels.incompatiblePlugins = ListAppend(application.wheels.incompatiblePlugins, arguments.name)>
			</cfif>
		</cfif>
	</cffunction>

	<!--- load all plugins into memory --->
	<cffunction name="$loadAllPlugins" mixin="none" returntype="void">
		<cfset var loc = {}>
		<cfdirectory action="list" directory="#variables.$instance.pluginsPath#" name="loc.dir" type="dir">
		<cfloop query="loc.dir">
			<cfset $loadPlugin(name)>
		</cfloop>
	</cffunction>
	
	<!--- unload a plugin from memory --->
	<cffunction name="$unloadPlugin" mixin="none" returntype="void">
		<cfargument name="name" type="string" required="true">
		<!--- removes the plugin from memory and run cleanup method before --->
		<cfif structkeyexists(application.wheels.plugins, arguments.name)>

			<!--- run clean up method before removing from memory --->
			<cfif structkeyexists(application.wheels.plugins[arguments.name], "cleanup")>
				<cfset application.wheels.plugins[arguments.name].cleanup()>
			</cfif>

			<!--- remove from memory --->
			<cfset structdelete(application.wheels.plugins, arguments.name)>

		</cfif>
	</cffunction>
	
	<!--- unload all plugins from memory --->
	<cffunction name="$unloadAllPlugins" mixin="none" returntype="void">
		<cfset var loc = {}>
		<cfloop collection="#application.wheels.plugins#" item="loc.plugin">
			<cfset $unloadPlugin(loc.plugin)>
		</cfloop>
	</cffunction>

	<!--- check to see if the plugin is loaded in memory --->
	<cffunction name="$isloadedPlugin" mixin="none" returntype="boolean">
		<cfargument name="name" type="string" required="true">
		<cfreturn structkeyexists(application.wheels.plugins, arguments.name)>
	</cffunction>


	<!--- is a plugin installed --->
	<cffunction name="$isInstalledPlugin" mixin="none" returntype="boolean">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="false" default="">
		<cfset var loc = {}>

		<cfset loc.installedPluginDir = "#variables.$instance.pluginsPath##arguments.name#">

		<!--- if they are looking for a specific version, then look for the zip --->
		<cfif len(arguments.version)>

			<cfset loc.installPluginFullPath = "#variables.$instance.pluginsPath##arguments.name#-#arguments.version#.zip">

			<cfif FileExists(loc.installPluginFullPath) and DirectoryExists(loc.installedPluginDir)>
				<cfreturn true>
			</cfif>

		</cfif>

		<cfreturn DirectoryExists(loc.installedPluginDir)>
	</cffunction>

	<!--- returns the version of a plugin from a repository. by default return the current version --->
	<cffunction name="$selectPlugin" mixin="none" returntype="struct">
		<cfargument name="name" type="string" required="true">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc ={}>
		<!--- get all the versions of the plugin --->
		<cfset loc.plugin = $inspectPlugin(argumentcollection=arguments)>
		<!--- if a particular version is desired, get that one, otherwise get the current one --->
		<cfset loc.version = loc.plugin[1]>
		<cfif arraylen(loc.plugin) gt 1 && len(arguments.version)>
			<cfloop array="#loc.plugin#" index="loc.i">
				<cfif loc.i.version eq arguments.version>
					<cfset loc.version = loc.i>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn loc.version>
	</cffunction>

	<!--- returns all the versions of a plugin from a repository --->
	<cffunction name="$inspectPlugin" mixin="none" returntype="array">
		<cfargument name="name" type="string" required="true">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc = {}>
		<cfset loc.p = $inspectPlugins(arguments.repo)>
		<cfset loc.p = loc.p[arguments.name]>
		<cfreturn loc.p>
	</cffunction>

	<!--- returns all the plugins available from a repository --->
	<cffunction name="$inspectPlugins" mixin="none" returntype="struct">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfreturn $inspectrepo(arguments.repo).plugins>
	</cffunction>


	<!--- returns a list of the avaiable plugin names sorted from a repository --->
	<cffunction name="$listPlugins" mixin="none" returntype="string">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfreturn ListSort(structkeylist($inspectRepo(arguments.repo).plugins), "textnocase", "asc")>
	</cffunction>

	<!---
		Repositories
	 --->

	<!--- set the current repo to use --->
	<cffunction name="$setRepo" mixin="none" returntype="any">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset variables.$instance.repo = arguments.repo>
	</cffunction>

	<cffunction name="$getRepo" mixin="none" returntype="any">
		<cfreturn variables.$instance.repo>
	</cffunction>

	<!--- returns information about the current repo in use --->
	<cffunction name="$inspectRepo" mixin="none" returntype="struct">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfreturn variables.$instance.repos[arguments.repo]>
	</cffunction>

	<!--- returns information from all registered repos --->
	<cffunction name="$inspectRepos" mixin="none" returntype="struct">
		<cfreturn variables.$instance.repos>
	</cffunction>

	<!--- you can register a repository to download and install plugins --->
	<cffunction name="$registerRepo" mixin="none" returntype="void">
		<cfargument name="repo" type="string" required="true" hint="the id for the repository">
		<cfargument name="name" type="string" required="true" hint="the name of the repository">
		<cfargument name="location" type="string" required="true" hint="the url where the repository is located">
		<cfargument name="parser" type="string" required="false" default="" hint="the name of the parser to use to parse repo location">
		<cfargument name="autoParse" type="boolean" default="true" hint="should we populate the repo after registering it.">
		<cfset var loc = {}>
		<cfset loc.plugins = {}>
		<cfset variables.$instance.repos[arguments.repo] = {settings=arguments, plugins=loc.plugins}>
		<cfif arguments.autoParse>
			<cfset $parseRepo(arguments.repo)>
		</cfif>
	</cffunction>

	<!--- returns the setting structure for the repo --->
	<cffunction name="$selectRepo" mixin="none" returntype="struct">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfreturn variables.$instance.repos[arguments.repo].settings>
	</cffunction>

	<!--- returns whether a repo is registered or not --->
	<cffunction name="$existsRepo" mixin="none" returntype="boolean">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfreturn structkeyexists(variables.$instance.repos, arguments.repo)>
	</cffunction>

	<!--- returns a list of the avaiable repos --->
	<cffunction name="$listRepos" mixin="none" returntype="string">
		<cfreturn ListSort(structkeylist(variables.$instance.repos), "textnocase", "asc")>
	</cffunction>

	<!--- parses the repo for a list of available plugins  --->
	<cffunction name="$parseRepo" mixin="none" returntype="void">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc = {}>
		<cfset loc.repo = $inspectRepo(arguments.repo).settings>
		<cfif len(loc.repo.parser)>
			<cfinvoke method="#loc.repo.parser#" repo="#arguments.repo#"/>
		</cfif>
	</cffunction>

	<!---
		Parsers
	 --->

	<cffunction name="$GoogleCode" mixin="none" returntype="void">
		<cfargument name="repo" type="string" required="false" default="#$getRepo()#">
		<cfset var loc = StructNew()>
		<cfset loc.regex = {}>
		<cfset loc.regex.trimmer = "\r|\n|\t|[[:space:]]{2}">
		<cfset loc.regex.plugin = "\<td class=""vt id col_0""\>(.*?)\<\/td\>[[:space:]]*\<td class=""vt col_1""([^\>]*)\>(.*?)\<\/td\>">
		<cfset loc.regex.removeHTML = "([[:space:]]|&nbsp;)*<[^>]*>([[:space:]]|&nbsp;)*">
		<cfset loc.repo = $inspectRepo(arguments.repo).settings>

		<!--- get html that lists all files with label "plugin" on google code --->
		<cfhttp url="#loc.repo.location#" result="loc.file"></cfhttp>
		<cfset loc.content = loc.file.FileContent>

		<!--- remove some chars for easier parsing --->
		<cfset loc.content = ReReplaceNoCase(loc.content, loc.regex.trimmer, "", "all")>
		<!--- get all the plugins that are available for download --->
		<cfset loc.matches = REMatchNoCase(loc.regex.plugin, loc.content)>
		<!--- remove html tags and get information about each plugin --->
		<cfloop array="#loc.matches#" index="loc.i">
			<cfset loc.a = ListToArray(ReReplaceNoCase(ReReplaceNoCase(loc.i, loc.regex.removeHTML, "|", "all"), loc.regex.trimmer, "", "all"), "|")>
			<cfif arraylen(loc.a) gte 4>
				<cfset $registerPlugin(
					repo = loc.repo.repo
					,link = "http://cfwheels.googlecode.com/files/#loc.a[1]#"
					,fullname = loc.a[1]
					,name = "#ListFirst(loc.a[1], '-')#"
					,version = "#Reverse(ListRest(Reverse(ListRest(loc.a[1], '-')), '.'))#"
					,description = loc.a[2]
					,compatible = loc.a[4]
				)>
			</cfif>
		</cfloop>
	</cffunction>


	<!---
		Private functions
	 --->

	<!---
		checks to see if we can load this plugin. plugins that overwrite other plugins
		are not allowed
	 --->
	<cffunction name="$canLoad" mixin="none" returntype="void">
		<cfargument name="obj" type="any" required="true">
		<cfset var loc = {}>
		<cfset loc.mixins = []>
		<cfloop collection="#application.wheels.plugins#" item="loc.key">
			<cfloop collection="#application.wheels.plugins[loc.key]#" item="loc.keyTwo">
				<cfif not ListFindNoCase("init,version", loc.keyTwo)>
					<cfset arrayappend(loc.mixins, loc.keyTwo)>
				</cfif>
			</cfloop>
		</cfloop>
		<cfset loc.mixins = arraytolist(loc.mixins)>
		<cfloop collection="#arguments.obj#" item="loc.key">
			<cfif not ListFindNoCase("init,version", loc.key)>
				<cfif ListFindNoCase(loc.mixins, loc.key)>
					<cfthrow
						type="Wheels.IncompatiblePlugin"
						message="#loc.key# is incompatible with a previously installed plugin."
						extendedInfo="make sure none of the plugins you have installed overrides the same Wheels functions."
						>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="$createPluginDir" mixin="none" returntype="void">
		<!--- if the plugin directory doens't exists, create it --->
		<cfif not directoryExists(variables.$instance.pluginsPath)>
			<cfdirectory action="create" directory="#variables.$instance.pluginsPath#" mode="777">
		</cfif>
	</cffunction>

</cfcomponent>