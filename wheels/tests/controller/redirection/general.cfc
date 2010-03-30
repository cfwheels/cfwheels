<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset variables.params.controller = "dummy">
	<cfset variables.params.action = "dummy">
	<cfset variables.controller = $controller(controllerName="dummy", controllerPath="wheels/tests/_assets/controllers").$createControllerObject(variables.params)> 

	<cffunction name="test_delayed_redirect">
		<cfset variables.controller.redirectTo(action="somethingElse", delay=true)>
		<cfset assert("IsDefined('request.wheels.redirect.url')")>
		<cfset StructDelete(request.wheels, "redirect")>
	</cffunction>

	<cffunction name="test_delayed_redirect_to_back">
		<cfset var loc = {}>
		<cfset loc.old_http_referer = request.cgi.http_referer>
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & "/dummy-controller/dummy-action">
		<cfset variables.controller.redirectTo(back=true, delay=true)>
		<cfset assert("request.wheels.redirect.url Contains '/dummy-controller/dummy-action'")>
		<cfset StructDelete(request.wheels, "redirect")>
		<cfset request.cgi.http_referer = loc.old_http_referer>
	</cffunction>

</cfcomponent>