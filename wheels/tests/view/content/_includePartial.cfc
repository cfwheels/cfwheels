<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_includePartial_valid">
		<cfset loc.env = duplicate(application.wheels)>
		<cfset application.wheels.viewPath = "/wheelsMapping/tests/_assets/views">
		<cfset loc.controller.includePartial(partial="/shared/button")>
		<cfset application.wheels = duplicate(loc.env)>
	</cffunction>

</cfcomponent>