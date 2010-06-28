<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_render_nothing">
		<cfset controller.renderNothing()>
		<cfset assert("controller.$getResponse() IS ''")>
	</cffunction>

</cfcomponent>