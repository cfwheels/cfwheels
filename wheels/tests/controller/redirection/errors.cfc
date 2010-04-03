<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_throw_error_on_double_redirect">
		<cfset controller.redirectTo(action="dummy", delay=true)>
		<cfset errorWasThrown = false>
		<cftry>
			<cfset controller.redirectTo(action="dummy", delay=true)>
			<cfcatch type="Wheels.RedirectToAlreadyCalled">
				<cfset errorWasThrown = true>
			</cfcatch>
		</cftry>
		<cfset assert("errorWasThrown IS true")>
	</cffunction>

	<cffunction name="test_throw_error_on_redirect_back_to_blank_referrer">
		<cfset request.cgi.http_referer = "">
		<cfset errorWasThrown = false>
		<cftry>
			<cfset controller.redirectTo(back=true, delay=true)>
			<cfcatch type="Wheels.RedirectBackError">
				<cfset errorWasThrown = true>
			</cfcatch>
		</cftry>
		<cfset assert("errorWasThrown IS true")>
	</cffunction>

	<cffunction name="test_throw_error_on_redirect_back_to_other_domain">
		<cfset request.cgi.http_referer = "http://www.dummy.com/dummy.html">
		<cfset errorWasThrown = false>
		<cftry>
			<cfset controller.redirectTo(back=true, delay=true)>
			<cfcatch type="Wheels.RedirectBackError">
				<cfset errorWasThrown = true>
			</cfcatch>
		</cftry>
		<cfset assert("errorWasThrown IS true")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
		<cfset StructDelete(request.wheels, "redirect")>
	</cffunction>

</cfcomponent>