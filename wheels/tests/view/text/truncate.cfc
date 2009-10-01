<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.text = "this is a test to see if this works or not.">
	<cfset global.args.length = "20">
	<cfset global.args.truncateString = "[more]">

	<cffunction name="test_phrase_should_truncate">
		<cfset loc.e = loc.controller.truncate(argumentcollection=loc.args)>
		<cfset loc.r = "this is a test[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_is_blank">
		<cfset loc.args.text = "">
		<cfset loc.e = loc.controller.truncate(argumentcollection=loc.args)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_truncateString_argument_is_missing">
		<cfset structdelete(loc.args, "truncateString")>
		<cfset loc.e = loc.controller.truncate(argumentcollection=loc.args)>
		<cfset loc.r = "this is a test to...">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>