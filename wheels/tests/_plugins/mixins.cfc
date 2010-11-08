<cfcomponent>

	<cfinclude template="testhelper.cfm">
	
	<cffunction name="_setup">
		<cfset global.plugins.$unloadAllPlugins()>
		<cfset global.plugins.$uninstallPlugin("TestAssignMixins")>
		<cfset global.plugins.$uninstallPlugin("TestDefaultAssignMixins")>
		<cfset global.plugins.$uninstallPlugin("TestGlobalMixins")>
		<cfset global.plugins.$installPlugin("TestAssignMixins")>
		<cfset global.plugins.$installPlugin("TestDefaultAssignMixins")>
		<cfset global.plugins.$installPlugin("TestGlobalMixins")>
		<cfset global.plugins.$loadAllPlugins()>
		<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
		<cfset global.model = createobject("component", "wheelsMapping.Model")>
		<cfset global.dispatch = createobject("component", "wheelsMapping.Dispatch")>
		<cfset global.test = createobject("component", "wheelsMapping.Test")>
		<cfset loc.wheelscontroller = [application.wheels.rootcomponentPath, "controllers", "wheels"]>
		<cfset global.wheelscontroller = createobject("component", listchangedelims(arraytolist(loc.wheelscontroller, "."), ".", "."))>
		<cfset global.wheelscontroller.$pluginInjection()>
	</cffunction>
	
	<cffunction name="_teardown">
		<cfset global.plugins.$uninstallPlugin("TestAssignMixins")>
		<cfset global.plugins.$uninstallPlugin("TestDefaultAssignMixins")>
		<cfset global.plugins.$uninstallPlugin("TestGlobalMixins")>
	</cffunction>

	<cffunction name="test_controller_object_mixins">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.controller, '$GobalTestMixin')")>
		<cfset assert("structkeyexists(global.controller, '$DefaultMixin1')")>
		<cfset assert("structkeyexists(global.controller, '$DefaultMixin2')")>
		<cfset assert("structkeyexists(global.controller, '$MixinForControllers')")>
		<cfset assert("structkeyexists(global.controller, '$MixinForModelsAndContollers')")>
		<cfset assert("not structkeyexists(global.controller, '$MixinForModels')")>
		<cfset assert("not structkeyexists(global.controller, '$MixinForDispatch')")>
		<cfset assert("not structkeyexists(global.controller, '$MixinForTest')")>
	</cffunction>

	<cffunction name="test_model_object_mixins">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.model, '$GobalTestMixin')")>
		<cfset assert("structkeyexists(global.model, '$DefaultMixin1')")>
		<cfset assert("structkeyexists(global.model, '$DefaultMixin2')")>
		<cfset assert("not structkeyexists(global.model, '$MixinForControllers')")>
		<cfset assert("structkeyexists(global.model, '$MixinForModelsAndContollers')")>
		<cfset assert("structkeyexists(global.model, '$MixinForModels')")>
		<cfset assert("not structkeyexists(global.model, '$MixinForDispatch')")>
		<cfset assert("not structkeyexists(global.model, '$MixinForTest')")>
	</cffunction>

	<cffunction name="test_dispatch_object_mixins">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.dispatch, '$GobalTestMixin')")>
		<cfset assert("not structkeyexists(global.dispatch, '$DefaultMixin1')")>
		<cfset assert("not structkeyexists(global.dispatch, '$DefaultMixin2')")>
		<cfset assert("not structkeyexists(global.dispatch, '$MixinForControllers')")>
		<cfset assert("not structkeyexists(global.dispatch, '$MixinForModelsAndContollers')")>
		<cfset assert("not structkeyexists(global.dispatch, '$MixinForModels')")>
		<cfset assert("structkeyexists(global.dispatch, '$MixinForDispatch')")>
		<cfset assert("not structkeyexists(global.dispatch, '$MixinForTest')")>
	</cffunction>

	<cffunction name="test_test_object_mixins">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.test, '$GobalTestMixin')")>
		<cfset assert("not structkeyexists(global.test, '$DefaultMixin1')")>
		<cfset assert("not structkeyexists(global.test, '$DefaultMixin2')")>
		<cfset assert("not structkeyexists(global.test, '$MixinForControllers')")>
		<cfset assert("not structkeyexists(global.test, '$MixinForModelsAndContollers')")>
		<cfset assert("not structkeyexists(global.test, '$MixinForModels')")>
		<cfset assert("not structkeyexists(global.test, '$MixinForDispatch')")>
		<cfset assert("structkeyexists(global.test, '$MixinForTest')")>
	</cffunction>

	<cffunction name="test_wheels_controller_should_have_controller_mixins">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.wheelscontroller, '$GobalTestMixin')")>
		<cfset assert("structkeyexists(global.wheelscontroller, '$DefaultMixin1')")>
		<cfset assert("structkeyexists(global.wheelscontroller, '$DefaultMixin2')")>
		<cfset assert("structkeyexists(global.wheelscontroller, '$MixinForControllers')")>
		<cfset assert("structkeyexists(global.wheelscontroller, '$MixinForModelsAndContollers')")>
		<cfset assert("not structkeyexists(global.wheelscontroller, '$MixinForModels')")>
		<cfset assert("not structkeyexists(global.wheelscontroller, '$MixinForDispatch')")>
		<cfset assert("not structkeyexists(global.wheelscontroller, '$MixinForTest')")>
	</cffunction>
	
	<cffunction name="test_mixins_marked_as_app_should_be_mixed_into_wheels_controller_only">
		<cfset loc = {}>
		<cfset assert("structkeyexists(global.wheelscontroller, '$MixinForWheelsControllerOnly')")>
		<cfset assert("not structkeyexists(global.test, '$MixinForWheelsControllerOnly')")>
		<cfset assert("not structkeyexists(global.dispatch, '$MixinForWheelsControllerOnly')")>
		<cfset assert("not structkeyexists(global.model, '$MixinForWheelsControllerOnly')")>
	</cffunction>
	
	<cffunction name="test_overwritten_methods_move_to_core">
		<cfset assert("global.wheelscontroller.congratulations() eq true")>
	</cffunction>

</cfcomponent>