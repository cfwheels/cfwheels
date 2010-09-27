<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller(name="dummy").new(params)>

	<cffunction name="test_render_text">
		<cfset loc.controller.renderText("OMG, look what I rendered!")>
		<cfset assert("loc.controller.response() IS 'OMG, look what I rendered!'")>
	</cffunction>

</cfcomponent>