<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset _applicationScope = duplicate(application)>
		<cfset _requestScope = duplicate(request)>
		<cfset application.wheels.URLRewriting = "On">
		<cfset request.cgi.script_name = "/rewrite.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfset structAppend(application, _applicationScope, true)>
		<cfset structAppend(request, _requestScope, true)>
	</cffunction>

	<cffunction name="test_controller_action_only">
		<cfset loc.path = loc.controller.urlFor(controller="account", action="logout")>
		<cfset loc.e = '<a href="#loc.path#">Log Out</a>'>
		<cfset loc.r = loc.controller.linkTo(text="Log Out", controller="account", action="logout")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_confirm_is_escaped">
		<cfset loc.path = loc.controller.urlFor()>
		<cfset loc.e = '<a data-confirm="Mark as: \''Completed\''?" href="#loc.path#">#loc.path#</a>'>
		<cfset loc.r = loc.controller.linkTo(confirm="Mark as: 'Completed'?")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_external_links">
		<cfset loc.e = '<a href="http://www.cfwheels.com">CFWheels</a>'>
		<cfset loc.r = loc.controller.linkTo(href="http://www.cfwheels.com", text="CFWheels")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_remote_links">
		<cfset loc.path = loc.controller.urlFor(controller="account", action="logout")>
		<cfset loc.e = '<a data-remote="true" href="#loc.path#">Log Out</a>'>
		<cfset loc.r = loc.controller.linkTo(text="Log Out", controller="account", action="logout", remote="true")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>