<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.text = "this is a test to see if this works or not.">
		<cfset global.args.length = "20">
		<cfset global.args.truncateString = "[more]">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_phrase_should_truncate">
		<cfset loc.e = global.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_is_blank">
		<cfset loc.a.text = "">
		<cfset loc.e = global.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_truncateString_argument_is_missing">
		<cfset structdelete(loc.a, "truncateString")>
		<cfset loc.e = global.controller.truncate(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test to...">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>