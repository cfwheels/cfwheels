<cfcomponent extends="wheelsMapping.Test" output="false">
	<cffunction name="setup" output="false">
		<cfset config = {
			path="wheels",
			fileName="Plugins",
			method="init",
			pluginPath="/wheelsMapping/tests/_assets/plugins/naming",
			deletePluginDirectories=true,
			overwritePlugins=true,
			loadIncompatiblePlugins=true
		}>
	</cffunction>

	<cffunction name="teardown" output="false">
		<cfdirectory action="delete" directory="#ExpandPath(config.pluginPath)#/testglobalmixins" recurse="true">
	</cffunction>

	<cffunction name="test_expanded_directory_name" output="false">
		<cfset $createObjectFromRoot(argumentCollection=config)>
		<cfdirectory name="loc.pluginDirectory" action="list" type="dir" directory="#ExpandPath(config.pluginPath)#">
		<cfset assert("Compare('testglobalmixins', loc.pluginDirectory.name) eq 0")>
	</cffunction>

	<cffunction name="test_expanded_CFC_name" output="false">
		<cfset loc.plugin = $createObjectFromRoot(argumentCollection=config)>

		<cfdirectory
			name="loc.expandedPluginDirectory"
			action="list"
			type="file"
			directory="#ExpandPath(config.pluginPath)#/testglobalmixins"
			filter="*.cfc"
		>

		<!--- Use Compare to make sure it's a case-sensitive comparison. --->
		<cfset assert("Compare('TestGlobalMixins.cfc', loc.expandedPluginDirectory.name) eq 0")>
	</cffunction>

	<cffunction name="test_plugin_object_name" output="false">
		<cfset loc.plugin = $createObjectFromRoot(argumentCollection=config)>
		<cfset loc.pluginMeta = GetMetaData(loc.plugin.getPlugins().TestGlobalMixins)>
		<cfset loc.dottedPath = Replace(config.pluginPath, "/", "", "one")>
		<cfset loc.dottedPath = Replace(loc.dottedPath, "/", ".", "all")>
		<!--- Use Compare to make sure it's a case-sensitive comparison. --->
		<cfset assert("Compare(loc.pluginMeta.FullName, '#loc.dottedPath#.testglobalmixins.TestGlobalMixins') eq 0")>
	</cffunction>
</cfcomponent>