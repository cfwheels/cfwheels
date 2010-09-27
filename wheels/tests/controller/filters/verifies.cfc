<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset $savedenv = duplicate(request.cgi)>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = $savedenv>
	</cffunction>

	<cffunction name="test_valid">
		<cfset params = {controller="verifies", action="actionGet"}>
		<cfset loc.controller = controller(name="verifies").new(params)>
		<cfset loc.controller.$processAction("actionGet", params)>
		<cfset assert('loc.controller.response() eq "actionGet"')>
	</cffunction>
	
	<cffunction name="test_invalid_aborted">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionGet"}>
		<cfset loc.controller = controller(name="verifies").new(params)>
		<cfset loc.controller.$processAction("actionGet", params)>
		<cfset assert('loc.controller.$abortIssued() eq "true"')>
		<cfset assert('loc.controller.$performedRenderOrRedirect() eq "false"')>
	</cffunction>
	
	<cffunction name="test_invalid_redirect">
		<cfset request.cgi.request_method = "get">
		<cfset params = {controller="verifies", action="actionPostWithRedirect"}>
		<cfset loc.controller = controller(name="verifies").new(params)>
		<cfset loc.controller.$processAction("actionPostWithRedirect", params)>
		<cfset assert('loc.controller.$abortIssued() eq "false"')>
		<cfset assert('loc.controller.$performedRenderOrRedirect() eq "true"')>
		<cfset assert('loc.controller.$getRedirect().$args.action  eq "index"')>
		<cfset assert('loc.controller.$getRedirect().$args.controller  eq "somewhere"')>
		<cfset assert('loc.controller.$getRedirect().$args.error  eq "invalid"')>
	</cffunction>
	
	<cffunction name="test_valid_types">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionPostWithTypesValid", userid="0", authorid="00000000-0000-0000-0000-000000000000"}>
		<cfset loc.controller = controller(name="verifies").new(params)>
		<cfset loc.controller.$processAction("actionPostWithTypesValid", params)>
		<cfset assert('loc.controller.response() eq "actionPostWithTypesValid"')>
	</cffunction>
	
	<cffunction name="test_invalid_types">
		<cfset request.cgi.request_method = "post">
		<cfset params = {controller="verifies", action="actionPostWithTypesInValid", userid="0", authorid="invalidguid"}>
		<cfset loc.controller = controller(name="verifies").new(params)>
		<cfset loc.controller.$processAction("actionPostWithTypesInValid", params)>
		<cfset assert('loc.controller.$abortIssued() eq "true"')>
	</cffunction>

</cfcomponent>