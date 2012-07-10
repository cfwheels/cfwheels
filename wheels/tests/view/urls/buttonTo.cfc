<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.applicationScope = duplicate(application)>
		<cfset loc.requestScope = duplicate(request)>
		<cfset application.wheels.URLRewriting = "On">
		<cfset request.cgi.script_name = "/rewrite.cfm">
		<cfset loc.path = loc.controller.urlFor()>
	</cffunction>

	<cffunction name="teardown">
		<cfset structAppend(application, loc.applicationScope, true)>
		<cfset structAppend(request, loc.requestScope, true)>
	</cffunction>

	<cffunction name="test_confirm_is_escaped">
		<cfset loc.e = '<form action="#loc.path#" method="post"><input data-confirm="Mark as: \''Completed\''?" type="submit" value="" /></form>'>
		<cfset loc.r = loc.controller.buttonTo(confirm="Mark as: 'Completed'?")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_disabled_is_escaped">
		<cfset loc.e = '<form action="#loc.path#" method="post"><input data-disable-with="Mark as: \''Completed\''?" type="submit" value="" /></form>'>
		<cfset loc.r = loc.controller.buttonTo(disable="Mark as: 'Completed'?")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>