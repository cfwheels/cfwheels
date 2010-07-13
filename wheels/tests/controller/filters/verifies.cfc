<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset $savedenv = duplicate(request.cgi)>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = $savedenv>
	</cffunction>

	<cffunction name="test_valid">
		<cfset params = {controller="verifies", action="actionGet"}>
		<cfset controller = $controller(name="verifies").$createControllerObject(params)>
		<cfset controller.$processAction("actionGet", params)>
		<cfset assert('controller.response() eq "actionGet"')>
	</cffunction>
	
	<cffunction name="test_invalid_aborted">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionGet"}>
		<cfset controller = $controller(name="verifies").$createControllerObject(params)>
		<cfset controller.$processAction("actionGet", params)>
		<cfset assert('controller.$abortIssued() eq "true"')>
		<cfset assert('controller.$performedRenderOrRedirect() eq "false"')>
	</cffunction>
	
	<cffunction name="test_invalid_redirect">
		<cfset request.cgi.request_method = "get">
		<cfset params = {controller="verifies", action="actionPostWithRedirect"}>
		<cfset controller = $controller(name="verifies").$createControllerObject(params)>
		<cfset controller.$processAction("actionPostWithRedirect", params)>
		<cfset assert('controller.$abortIssued() eq "false"')>
		<cfset assert('controller.$performedRenderOrRedirect() eq "true"')>
		<cfset assert('controller.$getRedirect().$args.action  eq "index"')>
		<cfset assert('controller.$getRedirect().$args.controller  eq "somewhere"')>
		<cfset assert('controller.$getRedirect().$args.error  eq "invalid"')>
	</cffunction>
	
	<cffunction name="test_valid_types">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionPostWithTypesValid", userid="0", authorid="00000000-0000-0000-0000-000000000000"}>
		<cfset controller = $controller(name="verifies").$createControllerObject(params)>
		<cfset controller.$processAction("actionPostWithTypesValid", params)>
		<cfset assert('controller.response() eq "actionPostWithTypesValid"')>
	</cffunction>
	
	<cffunction name="test_invalid_types">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionPostWithTypesInValid", userid="0", authorid="invalidguid"}>
		<cfset controller = $controller(name="verifies").$createControllerObject(params)>
		<cfset controller.$processAction("actionPostWithTypesInValid", params)>
		<cfset assert('controller.$abortIssued() eq "true"')>
	</cffunction>

</cfcomponent>