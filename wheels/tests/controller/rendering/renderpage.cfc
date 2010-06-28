<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="test_rendering_current_action">
		<cfset result = controller.renderPage()>
		<cfset assert("controller.$getResponse() Contains 'view template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_controller_and_action">
		<cfset result = controller.renderPage(controller="main", action="template")>
		<cfset assert("controller.$getResponse() Contains 'main controller template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_action">
		<cfset result = controller.renderPage(action="template")>
		<cfset assert("controller.$getResponse() Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_specific_template">
		<cfset result = controller.renderPage(template="template")>
		<cfset assert("controller.$getResponse() Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_and_returning_as_string">
		<cfset result = controller.renderPage(returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'view template content'")>
	</cffunction>

</cfcomponent>