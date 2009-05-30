<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.text = "this is a test to see if this works or not.">
		<cfset args.length = "20">
		<cfset args.truncateString = "[more]">
	</cffunction>

	<cffunction name="test_phrase_should_truncate">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.e = variables.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_is_blank">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.text = "">
		<cfset loc.e = variables.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_truncateString_argument_is_missing">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "truncateString")>
		<cfset loc.e = variables.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test to...">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>