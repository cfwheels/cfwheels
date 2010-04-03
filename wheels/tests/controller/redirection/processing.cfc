<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="test", action="testRedirect"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cffunction name="test_remaining_action_code_should_run">
		<cfset controller.$callAction(action="testRedirect")>
		<cfset assert("IsDefined('request.wheels.redirect.url') AND IsDefined('request.setInActionAfterRedirect')")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
		<cfset application.wheels.viewPath = oldViewPath>
		<cfset StructDelete(request.wheels, "redirect")>
	</cffunction>

</cfcomponent>