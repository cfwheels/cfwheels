<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.text = "this is a test to see if this works or not.">
		<cfset loc.args.length = "20">
		<cfset loc.args.truncateString = "[more]">
	</cffunction>

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