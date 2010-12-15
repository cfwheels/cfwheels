<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.text = "Wheels is a framework for ColdFusion">
	</cffunction>

	<cffunction name="test_default_values">
		<cfset loc.e = loc.controller.wordTruncate(argumentcollection=loc.args)>
		<cfset loc.r = "Wheels is a framework for...">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_text_is_blank">
		<cfset loc.args.text = "">
		<cfset loc.e = loc.controller.wordTruncate(argumentcollection=loc.args)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_specify_options">
		<cfset loc.args.length = 4>
		<cfset loc.args.truncateString = " [more]">
		<cfset loc.e = loc.controller.wordTruncate(argumentcollection=loc.args)>
		<cfset loc.r = "Wheels is a framework [more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>