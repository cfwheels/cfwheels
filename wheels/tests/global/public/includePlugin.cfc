<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<!--- inject our mock plugin into the plugin container --->
		<cfset mockPlugin = createobject("component", "MockPlugin").init()>
		<cfset structinsert(application.wheels.plugins, "mockPlugin", mockPlugin, true)>
	</cffunction>

	<cffunction name="test_check_that_mockPlugin_is_installed">
		<cfset assert("structkeyexists(application.wheels.plugins, 'mockPlugin')")>
	</cffunction>

	<cffunction name="test_mockPlugin_should_not_be_loaded">
		<cfset loc = {}>
		<cfset loc.c = createobject("component", "MockControllerNoPlugin")>
		<cfset assert("!structkeyexists(loc.c, 'mockFunction')")>
	</cffunction>

	<cffunction name="test_mockPlugin_should_be_loaded">
		<cfset loc = {}>
		<cfset loc.c = createobject("component", "MockControllerWithPlugin")>
		<cfset assert("structkeyexists(loc.c, 'mockFunction')")>
	</cffunction>

</cfcomponent>