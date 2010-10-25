<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.name = "WheelsTesting">
		<cfset loc.args.content = "this is a test for the wheel's function $addToJavaScriptAttribute">
		<cfset loc.args.attributes = {}>
		<cfset loc.args.attributes.WheelsTesting = "testing">
		<cfset loc.args.attributes.name = "javascripttag">
	</cffunction>

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