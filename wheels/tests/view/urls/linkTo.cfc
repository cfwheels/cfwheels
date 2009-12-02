<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_linkTo_valid">
		<cfset loc.controller.linkTo(text="Log Out", controller="account", action="logout")>
		<cfset loc.controller.linkTo(text="Log Out", action="logout")>
		<cfset loc.controller.linkTo(text="View Post", controller="blog", action="post", key=99)>
		<cfset loc.controller.linkTo(text="View Settings", action="settings", params="show=all&sort=asc")>
	</cffunction>

</cfcomponent>