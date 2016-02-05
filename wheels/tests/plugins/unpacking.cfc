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
		<cfdirectory action="list" directory="#ExpandPath(loc.config.pluginPath)#" type="dir" name="loc.q">
		<cfset loc.dirs = ValueList(loc.q.name)>
		<cfset assert('ListFind(loc.dirs, "testdefaultassignmixins")')>
		<cfset assert('ListFind(loc.dirs, "testglobalmixins")')>
	</cffunction>

</cfcomponent>