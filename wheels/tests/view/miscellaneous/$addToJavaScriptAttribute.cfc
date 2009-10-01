<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.name = "WheelsTesting">
	<cfset global.args.content = "this is a test for the wheel's function $addToJavaScriptAttribute">
	<cfset global.args.attributes = {}>
	<cfset global.args.attributes.WheelsTesting = "testing">
	<cfset global.args.attributes.name = "javascripttag">

	<cffunction name="test_has_attribute_called_name">
		<cfset loc.e = loc.controller.$addToJavaScriptAttribute(argumentcollection=loc.args)>
		<cfset loc.r = "testing;#loc.args.content#">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_does_not_have_attribute_called_name">
		<cfset structdelete(loc.args.attributes, "WheelsTesting")>
		<cfset loc.e = loc.controller.$addToJavaScriptAttribute(argumentcollection=loc.args)>
		<cfset loc.r = loc.args.content>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>