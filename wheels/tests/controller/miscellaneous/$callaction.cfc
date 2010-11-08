<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("test", params)>

	<cffunction name="setup">
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

	<cffunction name="test_setting_variable_for_view">
		<cfset loc.controller.$callAction(action="test")>
		<cfset assert("loc.controller.response() Contains 'variableForViewContent'")>
	</cffunction>

	<cffunction name="test_implicitly_calling_render_page">
		<cfset loc.controller.$callAction(action="test")>
		<cfset assert("loc.controller.response() Contains 'view template content'")>
	</cffunction>


</cfcomponent>