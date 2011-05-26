<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/removing"
			,deletePluginDirectories=true
			,overwritePlugins=false
			,loadIncompatiblePlugins=true
		}>
		<cfset loc.dir = expandPath(loc.config.pluginPath)>
		<cfset loc.dir = ListChangeDelims(loc.dir, "/", "\")>
		
		<cfset loc.badDir = ListAppend(loc.dir, "testing", "/")>
		<cfset loc.goodDir = ListAppend(loc.dir, "TestGlobalMixins", "/")>
		
		<cfset $deleteDirs()>
		<cfset $createDir()>
	</cffunction>
	
 	<cffunction name="teardown">
		<cfset $deleteDirs()>
	</cffunction>
	
	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="$createDir">
		<cfdirectory action="create" directory="#loc.badDir#">
	</cffunction>
	
	<cffunction name="$deleteDirs">
		<cfif DirectoryExists(loc.badDir)>
			<cfdirectory action="delete" recurse="true" directory="#loc.badDir#">
		</cfif>
		<cfif DirectoryExists(loc.goodDir)>
			<cfdirectory action="delete" recurse="true" directory="#loc.goodDir#">
		</cfif>
	</cffunction>

 	<cffunction name="test_remove_unused_plugin_directories">
		<cfset assert('DirectoryExists(loc.badDir)')>
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset assert('DirectoryExists(loc.goodDir)')>
		<cfset assert('!DirectoryExists(loc.badDir)')>
	</cffunction>
	
</cfcomponent>