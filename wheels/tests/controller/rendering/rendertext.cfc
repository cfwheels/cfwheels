<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">
	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_render_text">
		<cfset controller.renderText("OMG, look what I rendered!")>
		<cfset assert("request.wheels.response IS 'OMG, look what I rendered!'")>
	</cffunction>

</cfcomponent>