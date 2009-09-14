<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.name = "textarea">
	<cfset global.args.attributes = {}>
	<cfset global.args.attributes.rows = 10>
	<cfset global.args.attributes.cols = 40>
	<cfset global.args.attributes.name = "textareatest">
	<cfset global.args.content = "this is a test to see if textarea renders">

	<cffunction name="test_with_all_options">
		<cfset loc.e = loc.controller.$element(argumentcollection=loc.args)>
		<cfset loc.r = '<textarea cols="40" rows="10" name="textareatest">this is a test to see if textarea renders</textarea>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>