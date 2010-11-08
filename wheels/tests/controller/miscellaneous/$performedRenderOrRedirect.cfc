<cfcomponent extends="wheelsMapping.Test">

	<cfset variables.counter = 1>

	<cffunction name="setup">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", params)>
	</cffunction>

	<cffunction name="test_redirect_or_render_has_not_been_performed">
		<cfset loc.e = false>
		<cfset loc.r = loc.controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = loc.controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = loc.controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_only_redirect_was_performed">
		<cfset loc.controller.redirectTo(controller="wheels", action="wheels")>
		<cfset loc.e = true>
		<cfset loc.r = loc.controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = loc.controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.e = false>
		<cfset loc.r = loc.controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_only_render_was_performed">
		<cfset loc.controller.renderNothing()>
		<cfset loc.e = true>
		<cfset loc.r = loc.controller.$performedRender()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = loc.controller.$performedRenderOrRedirect()>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.e = false>
		<cfset loc.r = loc.controller.$performedRedirect()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>