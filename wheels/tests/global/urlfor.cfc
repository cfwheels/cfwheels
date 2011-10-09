<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.orgEnv = duplicate(application)>
		<cfset application.wheels.URLRewriting = "On">
	</cffunction>

	<cffunction name="teardown">
		<cfset application = loc.orgEnv>
	</cffunction>

	<cffunction name="test_links_are_properly_hyphenated">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.e = "/user/5559/survey-templates/index">
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index")>
		<cfset assert('loc.r contains loc.e')>
	</cffunction>

	<cffunction name="test_format_properly_add_with_route">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.e = "/user/5559/survey-templates/index.csv">
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv")>
		<cfset assert('loc.r contains loc.e')>
	</cffunction>

	<cffunction name="test_using_onlypath_correctly_detects_https">
		<cfset request.cgi.server_protocol = "">
		<cfset request.cgi.server_port_secure = 1>
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv", onlyPath=false)>
		<cfset assert('left(loc.r, 5) eq "https"')>
	</cffunction>

</cfcomponent>