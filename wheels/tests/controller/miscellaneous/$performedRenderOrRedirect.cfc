<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset $$oldCGIScope = request.cgi>
		<cfset $$oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset StructDelete(request.wheels, "redirect", false)>
		<cfset structDelete(request.wheels, "response", false)>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = $$oldCGIScope>
		<cfset application.wheels.viewPath = $$oldViewPath>
	</cffunction>

	<cffunction name="test_redirect_or_render_has_not_been_performed">
		<cfset loc.e = false>
		<cfset loc.r = controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_only_redirect_was_performed">
		<cfset controller.redirectTo(controller="wheels", action="wheels")>
		<cfset loc.e = true>
		<cfset loc.r = controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.e = false>
		<cfset loc.r = controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_only_render_was_performed">
		<cfset controller.renderNothing()>
		<cfset loc.e = true>
		<cfset loc.r = controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.e = false>
		<cfset loc.r = controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>