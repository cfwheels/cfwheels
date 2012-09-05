<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/unpacking"
			,deletePluginDirectories=false
			,overwritePlugins=false
			,loadIncompatiblePlugins=true
		}>
		<cfset $deleteTestFolders()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset application.wheels.mixins = {}>
		<cfset $deleteTestFolders()>
	</cffunction>

	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="$deleteTestFolders">
		<cfset var loc = {}>
		<cfset var q = "">
		<cfdirectory action="list" directory="#expandPath('/wheelsMapping/tests/_assets/plugins/unpacking')#" type="dir" name="q">
		<cfloop query="q">
			<cfset loc.dir = ListChangeDelims(ListAppend(directory, name, "/"), "/", "\")>
			<cfif DirectoryExists(loc.dir)>
				<cfdirectory action="delete" recurse="true" directory="#loc.dir#">
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="test_unpacking_plugin">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfdirectory action="list" directory="#expandPath(loc.config.pluginPath)#" type="dir" name="loc.q">
		<cfset loc.dirs = "">
		<cfloop query="loc.q">
			<cfset loc.dirs = ListAppend(loc.dirs, name)>
		</cfloop>
		<cfset assert('ListLen(loc.dirs) eq 3')>
		<cfset assert('ListFindNoCase(loc.dirs, "TestDefaultAssignMixins")')>
		<cfset assert('ListFindNoCase(loc.dirs, "TestGlobalMixins")')>
		<cfset assert('ListFindNoCase(loc.dirs, "TestUpdatedVersion")')>
	</cffunction>
	
	<cffunction name="test_newest_version_should_unpack">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset application.wheels.mixins = loc.PluginObj.getMixins()>
		<cfset loc.m = model("authors").new()>
		<cfset assert('StructKeyExists(loc.m, "$UpdatedVersionTest")')>
		<cfset assert('loc.m.$UpdatedVersionTest() eq 2')>
	</cffunction>
	
</cfcomponent>