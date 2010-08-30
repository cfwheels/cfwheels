<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.original_routes = duplicate(application.wheels.routes)>
		<cfset loc.original_rewrite = application.wheels.URLRewriting>
		<cfset application.wheels.URLRewriting = "On">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.routes = loc.original_routes>
		<cfset application.wheels.URLRewriting = loc.original_rewrite>
	</cffunction>

	<cffunction name="test_links_are_properly_hyphenated">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]")>
		<cfset application.wheels.namedRoutePositions["user_2"] = "">
		<cfset application.wheels.namedRoutePositions["user_2"] = ListAppend(application.wheels.namedRoutePositions["user_2"], arrayLen(application.wheels.routes))>
		<cfset loc.e = "/user/5559/survey-templates/index">
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index")>
		<cfset assert('loc.r contains loc.e')>
	</cffunction>

</cfcomponent>