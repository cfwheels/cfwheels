<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>	
	<cfset controller = $controller(name="test").new(params)>

	<cffunction name="test_rendering_partial">
		<cfset result = controller.renderPartial(partial="partialTemplate")>
		<cfset assert("controller.response() Contains 'partial template content'")>
	</cffunction>

	<cffunction name="test_rendering_partial_and_returning_as_string">
		<cfset result = controller.renderPartial(partial="partialTemplate", returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'partial template content'")>
	</cffunction>

</cfcomponent>