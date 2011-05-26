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
	
	<cffunction name="test_dependant_plugin">
		<cfset loc.config.pluginPath = "/wheelsMapping/tests/_assets/plugins/dependant">
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.iplugins = loc.PluginObj.getDependantPlugins()>
		<cfset assert('loc.iplugins eq "TestPlugin1|TestPlugin2,TestPlugin1|TestPlugin3"')>
	</cffunction>
	
</cfcomponent>