<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_controller_action_only">
		<cfset loc.e = loc.controller.linkTo(text="Log Out", controller="account", action="logout")>
		<cfset loc.r = '<a href="#application.wheels.rootpath#/index.cfm/account/logout">Log Out</a>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_confirm_is_escaped">
		<cfset loc.e = loc.controller.linkTo(confirm="Mark as: 'Completed'?")>
		<cfset loc.r = '<a href="#application.wheels.rootpath#/index.cfm/" onclick="return confirm(''Mark as: \''Completed\''?'');">/a/b/index.cfm/</a>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>	

</cfcomponent>