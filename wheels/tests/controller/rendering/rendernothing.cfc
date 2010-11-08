<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="test_render_nothing">
		<cfset loc.controller.renderNothing()>
		<cfset assert("loc.controller.response() IS ''")>
	</cffunction>

</cfcomponent>