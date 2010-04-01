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

	<cffunction name="test_render_without_layout">
		<cfset controller.renderPage(layout=false)>
		<cfset assert("request.wheels.response IS 'this is a view template'")>
	</cffunction>

	<cffunction name="test_render_with_layout">
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains '<html>' AND request.wheels.response Contains 'this is a view template'")>
	</cffunction>

	<cffunction name="test_render_and_return_as_string">
		<cfset result = controller.renderPage(returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'this is a view template'")>
	</cffunction>

	<cffunction name="test_setting_variable_for_view">
		<cfset controller.$callAction(action="test")>
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'hello world!'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

</cfcomponent>