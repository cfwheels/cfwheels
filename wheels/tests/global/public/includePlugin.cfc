<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<!--- inject our mock plugin into the plugin container --->
		<cfset mockPlugin = createobject("component", "MockPlugin").init()>
		<cfset structinsert(application.wheels.plugins, "mockPlugin", mockPlugin, true)>
	</cffunction>

	<cffunction name="teardown">
		<cfset structdelete(application.wheels.plugins, "mockPlugin")>
	</cffunction>

	<cffunction name="test_check_that_mockPlugin_is_installed">
		<cfset assert("structkeyexists(application.wheels.plugins, 'mockPlugin')")>
	</cffunction>

	<cffunction name="test_mockPlugin_should_not_be_loaded">
		<cfset loc = {}>
		<cfset loc.c = createobject("component", "MockControllerNoPlugin").init()>
		<cfset assert("!structkeyexists(loc.c, 'mockFunction')")>
	</cffunction>

	<cffunction name="test_mockPlugin_should_be_loaded">
		<cfset loc = {}>
		<cfset loc.c = createobject("component", "MockControllerWithPlugin").init()>
		<cfset assert("structkeyexists(loc.c, 'mockFunction')")>
	</cffunction>

	<cffunction name="test_overwritten_controller_function_should_be_loaded_into_core">
		<cfset loc = {}>
		<cfset loc.c = createobject("component", "MockControllerWithPlugin").init()>
		<cfset loc.e = loc.c.mockControllerFunction()>
		<cfset loc.r = "OVERRIDE:ORIGINAL">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>