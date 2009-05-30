<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.name = "textarea">
		<cfset args.attributes = {}>
		<cfset args.attributes.rows = 10>
		<cfset args.attributes.cols = 40>
		<cfset args.attributes.name = "textareatest">
		<cfset args.content = "this is a test to see if textarea renders">
	</cffunction>

	<cffunction name="test_with_all_options">
		<cfset loc = {}>
		<cfset loc.args = duplicate(args)>

		<cfset loc.e = controller.$element(argumentcollection=loc.args)>
		<cfset loc.r = '<textarea cols="40" rows="10" name="textareatest">this is a test to see if textarea renders</textarea>'>

		<cfset assert("loc.e eq loc.r")>

	</cffunction>

</cfcomponent>