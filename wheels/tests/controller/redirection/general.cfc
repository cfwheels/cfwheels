<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="common.cfm">
	
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	
	<cffunction name="test_redirect_was_performed">
		<cfset controller.redirectTo(back=true)>
		<cfset loc.e = true>
		<cfset loc.r = controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_redirect_to_action">
		<cfset controller.redirectTo(action="dummy")>
		<cfset assert("IsDefined('request.wheels.redirect.url')")>
	</cffunction>

	<cffunction name="test_redirect_to_back">
		<cfset loc.path = "/dummy-controller/dummy-action">
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & loc.path>
		<cfset controller.redirectTo(back=true)>
		<cfset assert("request.wheels.redirect.url Contains loc.path")>
	</cffunction>

	<cffunction name="test_passing_through_to_urlfor">
		<cfset loc.args = {action="dummy", onlyPath=false, protocol="https", params="dummy1=1&dummy2=2"}>
		<cfset controller.redirectTo(argumentCollection=loc.args)>
		<cfset assert("request.wheels.redirect.url Contains loc.args.protocol AND request.wheels.redirect.url Contains loc.args.params")>
	</cffunction>

	<cffunction name="test_setting_cflocation_attributes">
		<cfset controller.redirectTo(action="dummy", addToken=true, statusCode="301")>
		<cfset assert("request.wheels.redirect.addToken IS true AND request.wheels.redirect.statusCode IS 301")>
	</cffunction>

</cfcomponent>