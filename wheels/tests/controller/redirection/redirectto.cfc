<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="test", action="testRedirect"}>

	<cffunction name="setup">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset copies.request.cgi = request.cgi>
		<cfset copies.application.wheels.viewPath = application.wheels.viewPath>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset request.cgi = copies.request.cgi>
		<cfset application.wheels.viewPath = copies.application.wheels.viewPath>
	</cffunction>

	<cffunction name="test_throw_error_on_double_redirect">
		<cfset controller.redirectTo(action="test")>
		<cfset loc.e = "Wheels.RedirectToAlreadyCalled">
		<cfset loc.r = raised('controller.redirectTo(action="test")')>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_remaining_action_code_should_run">
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset controller.$callAction(action="testRedirect")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("IsDefined('loc.r.url') AND IsDefined('request.setInActionAfterRedirect')")>
	</cffunction>

	<cffunction name="test_redirect_to_action">
		<cfset controller.redirectTo(action="test")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("controller.$performedRedirect() IS true AND IsDefined('loc.r.url')")>
	</cffunction>

	<cffunction name="test_passing_through_to_urlfor">
		<cfset loc.args = {action="test", onlyPath=false, protocol="https", params="test1=1&test2=2"}>
		<cfset controller.redirectTo(argumentCollection=loc.args)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url Contains loc.args.protocol AND loc.r.url Contains loc.args.params")>
	</cffunction>

	<cffunction name="test_setting_cflocation_attributes">
		<cfset controller.redirectTo(action="test", addToken=true, statusCode="301")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.addToken IS true AND loc.r.statusCode IS 301")>
	</cffunction>

	<cffunction name="test_redirect_to_referrer">
		<cfset loc.path = "/test-controller/test-action">
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & loc.path>
		<cfset controller.redirectTo(back=true)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url Contains loc.path")>
	</cffunction>

	<cffunction name="test_appending_params_to_referrer">
		<cfset loc.path = "/test-controller/test-action">
		<cfset request.cgi.http_referer = "http://" & request.cgi.server_name & loc.path>
		<cfset controller.redirectTo(back=true, params="x=1&y=2")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url Contains loc.path AND loc.r.url Contains '?x=1&y=2'")>
	</cffunction>

	<cffunction name="test_redirect_to_action_on_blank_referrer">
		<cfset request.cgi.http_referer = "">
		<cfset controller.redirectTo(back=true, action="blankRef")>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url IS '#URLFor(action='blankRef')#'")>
	</cffunction>

	<cffunction name="test_redirect_to_root_on_blank_referrer">
		<cfset request.cgi.http_referer = "">
		<cfset controller.redirectTo(back=true)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url IS application.wheels.webPath")>
	</cffunction>

	<cffunction name="test_redirect_to_root_on_foreign_referrer">
		<cfset request.cgi.http_referer = "http://www.google.com">
		<cfset controller.redirectTo(back=true)>
		<cfset loc.r = controller.$getRedirect()>
		<cfset assert("loc.r.url IS application.wheels.webPath")>
	</cffunction>

</cfcomponent>