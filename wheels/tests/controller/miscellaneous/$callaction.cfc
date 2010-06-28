<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

	<cffunction name="test_setting_variable_for_view">
		<cfset controller.$callAction(action="test")>
		<cfset assert("controller.$getResponse() Contains 'variableForViewContent'")>
	</cffunction>

	<cffunction name="test_implicitly_calling_render_page">
		<cfset controller.$callAction(action="test")>
		<cfset assert("controller.$getResponse() Contains 'view template content'")>
	</cffunction>


</cfcomponent>