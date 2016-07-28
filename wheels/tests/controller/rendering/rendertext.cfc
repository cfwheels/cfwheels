<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", params)>
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_render_text">
		<cfset loc.controller.renderText("OMG, look what I rendered!")>
		<cfset assert("loc.controller.response() IS 'OMG, look what I rendered!'")>
	</cffunction>

</cfcomponent>
