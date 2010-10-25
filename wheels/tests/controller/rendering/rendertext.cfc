<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="test_render_text">
		<cfset loc.controller.renderText("OMG, look what I rendered!")>
		<cfset assert("loc.controller.response() IS 'OMG, look what I rendered!'")>
	</cffunction>

</cfcomponent>