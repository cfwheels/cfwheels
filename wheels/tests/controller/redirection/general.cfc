<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_delayed_redirect">
		<cfset controller.redirectTo(action="somethingElse", delay=true)>
		<cfset assert("IsDefined('request.wheels.redirect.url')")>
	</cffunction>

	<cffunction name="test_delayed_redirect_to_back">
		<cfset var loc = {}>
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & "/dummy-controller/dummy-action">
		<cfset controller.redirectTo(back=true, delay=true)>
		<cfset assert("request.wheels.redirect.url Contains '/dummy-controller/dummy-action'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
		<cfset StructDelete(request.wheels, "redirect")>
	</cffunction>

</cfcomponent>