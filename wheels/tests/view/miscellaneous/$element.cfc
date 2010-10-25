<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.name = "textarea">
		<cfset loc.args.attributes = {}>
		<cfset loc.args.attributes.rows = 10>
		<cfset loc.args.attributes.cols = 40>
		<cfset loc.args.attributes.name = "textareatest">
		<cfset loc.args.content = "this is a test to see if textarea renders">
	</cffunction>

	<cffunction name="test_with_all_options">
		<cfset loc.e = loc.controller.$element(argumentcollection=loc.args)>
		<cfset loc.r = '<textarea cols="40" name="textareatest" rows="10">this is a test to see if textarea renders</textarea>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>