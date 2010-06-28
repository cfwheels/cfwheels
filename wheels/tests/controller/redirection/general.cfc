<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	</cffunction>
	
	<cffunction name="test_redirect_was_performed">
		<cfset controller.redirectTo(back=true)>
		<cfset loc.e = true>
		<cfset loc.r = controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_redirect_to_action">
		<cfset controller.redirectTo(action="dummy")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("IsDefined('loc.r.url')")>
	</cffunction>

	<cffunction name="test_redirect_to_back">
		<cfset loc.path = "/dummy-controller/dummy-action">
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & loc.path>
		<cfset controller.redirectTo(back=true)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url Contains loc.path")>
	</cffunction>

	<cffunction name="test_passing_through_to_urlfor">
		<cfset loc.args = {action="dummy", onlyPath=false, protocol="https", params="dummy1=1&dummy2=2"}>
		<cfset controller.redirectTo(argumentCollection=loc.args)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url Contains loc.args.protocol AND loc.r.url Contains loc.args.params")>
	</cffunction>

	<cffunction name="test_setting_cflocation_attributes">
		<cfset controller.redirectTo(action="dummy", addToken=true, statusCode="301")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.addToken IS true AND loc.r.statusCode IS 301")>
	</cffunction>

</cfcomponent>