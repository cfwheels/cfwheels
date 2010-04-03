<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_redirect_to_action">
		<cfset controller.redirectTo(action="dummy", delay=true)>
		<cfset assert("IsDefined('request.wheels.redirect.url')")>
	</cffunction>

	<cffunction name="test_redirect_to_back">
		<cfset var loc = {}>
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & "/dummy-controller/dummy-action">
		<cfset controller.redirectTo(back=true, delay=true)>
		<cfset assert("request.wheels.redirect.url Contains '/dummy-controller/dummy-action'")>
	</cffunction>

	<cffunction name="test_passing_through_to_urlfor">
		<cfset controller.redirectTo(action="dummy", delay=true, onlyPath=false, protocol="https", params="dummy1=1&dummy2=2")>
		<cfset assert("request.wheels.redirect.url Contains 'https' AND request.wheels.redirect.url Contains 'dummy1=1&dummy2=2'")>
	</cffunction>

	<cffunction name="test_setting_cflocation_attributes">
		<cfset controller.redirectTo(action="dummy", delay=true, addToken=true, statusCode="301")>
		<cfset assert("request.wheels.redirect.addToken IS true AND request.wheels.redirect.statusCode IS 301")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
		<cfset StructDelete(request.wheels, "redirect")>
	</cffunction>

</cfcomponent>