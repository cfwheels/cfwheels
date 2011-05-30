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
	
	<cffunction name="test_raise_incompatible_plugin">
		<cfset loc.config.pluginPath = "/wheelsMapping/tests/_assets/plugins/incompatible">
		<cfset loc.e = "Wheels.IncompatiblePlugin">
		<cfset loc.r = raised('$pluginObj(loc.config)')>
		<cfset assert('loc.r eq loc.e')>
	</cffunction>
	
</cfcomponent>