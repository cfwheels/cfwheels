<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("test", params)>

	<cffunction name="test_rendering_current_action">
		<cfset result = loc.controller.renderPage()>
		<cfset assert("loc.controller.response() Contains 'view template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_controller_and_action">
		<cfset result = loc.controller.renderPage(controller="main", action="template")>
		<cfset assert("loc.controller.response() Contains 'main controller template content'")>
	</cffunction>

	<cffunction name="test_rendering_view_for_another_action">
		<cfset result = loc.controller.renderPage(action="template")>
		<cfset assert("loc.controller.response() Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_specific_template">
		<cfset result = loc.controller.renderPage(template="template")>
		<cfset assert("loc.controller.response() Contains 'specific template content'")>
	</cffunction>

	<cffunction name="test_rendering_and_returning_as_string">
		<cfset result = loc.controller.renderPage(returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'view template content'")>
	</cffunction>
	
	<cffunction name="test_rendering_with_cfthread_in_view">
		<cfset result = loc.controller.renderPage(action="withthread")>
		<cfset assert("loc.controller.response() Contains '1|Per|Djurner'")>
	</cffunction>

</cfcomponent>