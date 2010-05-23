<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_contentForLayout_valid">
		<cfset request.wheels.contentForLayout = "testing this out">
		<cfset loc.controller.contentForLayout()>
	</cffunction>

</cfcomponent>