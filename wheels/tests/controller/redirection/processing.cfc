<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="common.cfm">

	<cfset params = {controller="test", action="testRedirect"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="test_remaining_action_code_should_run">
		<cfset controller.$callAction(action="testRedirect")>
		<cfset assert("IsDefined('request.wheels.redirect.url') AND IsDefined('request.setInActionAfterRedirect')")>
	</cffunction>

</cfcomponent>