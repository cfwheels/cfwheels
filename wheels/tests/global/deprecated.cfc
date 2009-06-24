<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
	</cffunction>

	<cffunction name="test_deprecated_message">
		<!--- correct message --->
		<cfset loc.a = controller.should_deprecate()>
		<cfset loc.e = loc.a.message>
		<cfset loc.r = "_deprecated_">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_deprecated_method_called">
		<!--- correct method name. regex might fail on different engines --->
		<cfset loc.a = controller.should_deprecate()>
		<cfset loc.e = loc.a.method>
		<cfset loc.r = "test_deprecated_method_called">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>