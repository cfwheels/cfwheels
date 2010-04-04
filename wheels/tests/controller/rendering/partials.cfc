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

	<cffunction name="test_rendering_partial">
		<cfset result = controller.renderPartial(partial="partialTemplate")>
		<cfset assert("request.wheels.response Contains 'partial template content'")>
	</cffunction>

	<cffunction name="test_rendering_partial_and_returning_as_string">
		<cfset result = controller.renderPartial(partial="partialTemplate", returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'partial template content'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
	</cffunction>

</cfcomponent>