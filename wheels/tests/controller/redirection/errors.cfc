<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
		<cfset StructDelete(request.wheels, "redirect", false)>
	</cffunction>

	<cffunction name="test_throw_error_on_double_redirect">
		<cfset controller.redirectTo(action="dummy")>
		<cfset loc.e = "Wheels.RedirectToAlreadyCalled">
		<cfset loc.r = raised('controller.redirectTo(action="dummy")')>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_throw_error_on_redirect_back_to_blank_referrer">
		<cfset request.cgi.http_referer = "">
		<cfset loc.e = "Wheels.RedirectBackError">
		<cfset loc.r = raised('controller.redirectTo(back=true)')>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_throw_error_on_redirect_back_to_other_domain">
		<cfset request.cgi.http_referer = "http://www.dummy.com/dummy.html">
		<cfset loc.e = "Wheels.RedirectBackError">
		<cfset loc.r = raised('controller.redirectTo(back=true)')>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>