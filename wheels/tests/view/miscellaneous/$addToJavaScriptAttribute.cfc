<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.name = "WheelsTesting">
		<cfset args.content = "this is a test for the wheel's function $addToJavaScriptAttribute">
		<cfset args.attributes = {}>
		<cfset args.attributes.WheelsTesting = "testing">
		<cfset args.attributes.name = "javascripttag">
	</cffunction>

	<cffunction name="test_has_attribute_called_name">
		<cfset loc = {}>
		<cfset loc.args = duplicate(args)>

		<cfset loc.e = controller.$addToJavaScriptAttribute(argumentcollection=loc.args)>
		<cfset loc.r = "testing;#loc.args.content#">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_does_not_have_attribute_called_name">
		<cfset loc = {}>
		<cfset loc.args = duplicate(args)>
		<cfset structdelete(loc.args.attributes, "WheelsTesting")>

		<cfset loc.e = controller.$addToJavaScriptAttribute(argumentcollection=loc.args)>
		<cfset loc.r = loc.args.content>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>