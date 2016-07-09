<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", params)>
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_render_nothing">
		<cfset loc.controller.renderNothing()>
		<cfset assert(loc.controller.response() IS '')>
	</cffunction>

</cfcomponent>
