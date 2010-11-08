<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>	
	<cfset loc.controller = controller("test", params)>

	<cffunction name="test_rendering_partial">
		<cfset result = loc.controller.renderPartial(partial="partialTemplate")>
		<cfset assert("loc.controller.response() Contains 'partial template content'")>
	</cffunction>

	<cffunction name="test_rendering_partial_and_returning_as_string">
		<cfset result = loc.controller.renderPartial(partial="partialTemplate", returnAs="string")>
		<cfset assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'partial template content'")>
	</cffunction>

</cfcomponent>