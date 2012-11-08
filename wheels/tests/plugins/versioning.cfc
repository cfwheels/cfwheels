<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/versioning"
			,deletePluginDirectories=false
			,overwritePlugins=false
			,loadIncompatiblePlugins=false
		}>
	</cffunction>
	
	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="test_approixmate_valid">
		<cfset loc.config.wheelsVersion = "1.1.3">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('StructKeyExists(loc.plugins, "TestAdvancedVersioningAppoximate")')>
	</cffunction>
	
	<cffunction name="test_approixmate_invalid">
		<cfset loc.config.wheelsVersion = "1.0">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('!StructKeyExists(loc.plugins, "TestAdvancedVersioningAppoximate")')>
	</cffunction>
	
	<cffunction name="test_greater_than_valid">
		<cfset loc.config.wheelsVersion = "1.1.4">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('StructKeyExists(loc.plugins, "TestAdvancedVersioningGreaterThan")')>
	</cffunction>
	
	<cffunction name="test_greater_than_invalid">
		<cfset loc.config.wheelsVersion = "1.1.3">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('!StructKeyExists(loc.plugins, "TestAdvancedVersioningGreaterThan")')>
	</cffunction>
	
	<cffunction name="test_less_than_valid_advanced_versioning">
		<cfset loc.config.wheelsVersion = "1.1.5">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('StructKeyExists(loc.plugins, "TestAdvancedVersioningLessThan")')>
	</cffunction>
	
	<cffunction name="test_less_than_invalid_advanced_versioning">
		<cfset loc.config.wheelsVersion = "1.2">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('!StructKeyExists(loc.plugins, "TestAdvancedVersioningLessThan")')>
	</cffunction>
	
	<cffunction name="test_less_than_valid">
		<cfset loc.config.wheelsVersion = "1.1.3">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('StructKeyExists(loc.plugins, "TestListVersions")')>
	</cffunction>
	
	<cffunction name="test_less_than_invalid">
		<cfset loc.config.wheelsVersion = "1.1.8">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('!StructKeyExists(loc.plugins, "TestAdvancedVersioningLessThan")')>
	</cffunction>
	
	<cffunction name="test_list_valid">
		<cfset loc.config.wheelsVersion = "1.1.3">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('StructKeyExists(loc.plugins, "TestAdvancedVersioningLessThan")')>
	</cffunction>
	
	<cffunction name="test_list_invalid">
		<cfset loc.config.wheelsVersion = "1.1.5">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.plugins = loc.PluginObj.getPlugins()>
		<cfset assert('!StructKeyExists(loc.plugins, "TestListVersions")')>
	</cffunction>
	
</cfcomponent>