<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="test",action="test"})>

	<cffunction name="setup">
		<cfif StructKeyExists(request.wheels, "response")>
			<cfset structDelete(request.wheels, "response")>
		</cfif>
	</cffunction>

	<cffunction name="test_rendering_nothing">
		<cfset controller.renderNothing()>
		<cfset assert("request.wheels.response IS ''")>
	</cffunction>

	<cffunction name="test_rendering_text">
		<cfset controller.renderText("OMG, look what I rendered!")>
		<cfset assert("request.wheels.response IS 'OMG, look what I rendered!'")>
	</cffunction>

</cfcomponent>