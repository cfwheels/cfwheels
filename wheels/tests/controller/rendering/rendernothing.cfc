<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfif StructKeyExists(request.wheels, "response")>
			<cfset StructDelete(request.wheels, "response")>
		</cfif>
	</cffunction>

	<cffunction name="test_render_nothing">
		<cfset controller.renderNothing()>
		<cfset assert("request.wheels.response IS ''")>
	</cffunction>

</cfcomponent>