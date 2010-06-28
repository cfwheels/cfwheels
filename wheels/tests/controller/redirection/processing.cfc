<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="common.cfm">

	<cfset params = {controller="test", action="testRedirect"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>

	<cffunction name="test_remaining_action_code_should_run">
		<cfset controller.$callAction(action="testRedirect")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("IsDefined('loc.r.url') AND IsDefined('request.setInActionAfterRedirect')")>
	</cffunction>

</cfcomponent>