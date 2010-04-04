<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="setup">
		<cfif StructKeyExists(request.wheels, "response")>
			<cfset structDelete(request.wheels, "response")>
		</cfif>
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cffunction name="test_rendering_current_action">
		<cfset result = controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'view template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_controller_and_action">
		<cfset result = controller.renderPage(controller="main", action="template")>
		<cfset assert("request.wheels.response Contains 'main controller template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_action">
		<cfset result = controller.renderPage(action="template")>
		<cfset assert("request.wheels.response Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_specific_template">
		<cfset result = controller.renderPage(template="template")>
		<cfset assert("request.wheels.response Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_and_returning_as_string">
		<cfset result = controller.renderPage(returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'view template content'")>
	</cffunction>

	<cffunction name="test_setting_variable_for_view">
		<cfset controller.$callAction(action="test")>
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'variableForViewContent'")>
	</cffunction>

	<cffunction name="test_implicitly_calling_render_page">
		<cfset controller.$callAction(action="test")>
		<cfset assert("request.wheels.response Contains 'view template content'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

</cfcomponent>