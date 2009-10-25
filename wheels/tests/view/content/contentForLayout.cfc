<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_contentForLayout_valid">
		<cfset request.wheels.contentForLayout = "testing this out">
		<cfset loc.controller.contentForLayout()>
	</cffunction>

</cfcomponent>