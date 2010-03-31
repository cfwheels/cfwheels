<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

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

	<!---<cffunction name="test_render_and_return_as_string">
		<cfset assert("1 IS 0")>
	</cffunction>--->

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

</cfcomponent>