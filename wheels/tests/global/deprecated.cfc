<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
	</cffunction>

	<cffunction name="test_deprecated_method">
		<cfset loc.a = controller.should_deprecate()>
		<cfset loc.e = loc.a.message>
		<cfset loc.r = "_deprecated_">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>