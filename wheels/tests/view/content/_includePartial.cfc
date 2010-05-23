<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_includePartial_valid">
		<cfset loc.env = duplicate(application.wheels)>
		<cfset application.wheels.viewPath = "/wheelsMapping/tests/_assets/views">
		<cfset loc.controller.includePartial(partial="/shared/button")>
		<cfset application.wheels = duplicate(loc.env)>
	</cffunction>

</cfcomponent>