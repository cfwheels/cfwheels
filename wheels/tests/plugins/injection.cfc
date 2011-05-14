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
		<cfset $pluginObj(loc.config)>
		<cfset application.wheels.mixins = loc.PluginObj.getMixins()>
		<cfset loc.m = model("authors").new()>
		<cfset loc.params = {controller="test", action="index"}>	
		<cfset loc.c = controller("test", loc.params)>
		<cfset loc.d = $createObjectFromRoot(path="wheels", fileName="dispatch", method="$init")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset application.wheels.mixins = {}>
	</cffunction>
	
	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn loc.PluginObj = $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="test_global_method">
		<cfset assert('StructKeyExists(loc.m, "$GlobalTestMixin")')>
		<cfset assert('StructKeyExists(loc.c, "$GlobalTestMixin")')>
		<cfset assert('StructKeyExists(loc.d, "$GlobalTestMixin")')>
	</cffunction>
	
	<cffunction name="test_component_specific">
		<cfset assert('StructKeyExists(loc.m, "$MixinForModels")')>
		<cfset assert('StructKeyExists(loc.m, "$MixinForModelsAndContollers")')>
		<cfset assert('StructKeyExists(loc.c, "$MixinForControllers")')>
		<cfset assert('StructKeyExists(loc.c, "$MixinForModelsAndContollers")')>		
		<cfset assert('StructKeyExists(loc.d, "$MixinForDispatch")')>
	</cffunction>

</cfcomponent>