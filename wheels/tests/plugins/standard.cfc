<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/standard"
			,deletePluginDirectories=false
			,overwritePlugins=false
			,loadIncompatiblePlugins=true
		}>
	</cffunction>
	
	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="test_load_all_plugins">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('not StructIsEmpty(loc.plugins)')>
		<cfset assert('StructKeyExists(loc.plugins, "TestAssignMixins")')>
	</cffunction>
	
	<cffunction name="test_notify_incompatable_version">
		<cfset loc.config.wheelsVersion = "99.9.9">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.iplugins = loc.PluginObj.getIncompatiblePlugins()>
		<cfset assert('loc.iplugins eq "TestIncompatableVersion"')>
	</cffunction>
	
	<cffunction name="test_no_loading_of_incompatable_plugins">
		<cfset loc.config.loadIncompatiblePlugins = false>
		<cfset loc.config.wheelsVersion = "99.9.9">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('not StructIsEmpty(loc.plugins)')>
		<cfset assert('StructKeyExists(loc.plugins, "TestAssignMixins")')>
		<cfset assert('not StructKeyExists(loc.plugins, "TestIncompatablePlugin")')>
	</cffunction>
	
</cfcomponent>