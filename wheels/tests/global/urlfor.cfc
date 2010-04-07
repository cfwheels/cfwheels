<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="setup">
		<cfset loc.original_routes = application.wheels.Router.$getRoutes()>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.Router.$setRoutes(loc.original_routes)>
	</cffunction>

	<cffunction name="test_links_are_properly_hyphenated">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]")>
		<cfset loc.e = "/user/5559/survey-templates/index">
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index")>
		<cfset assert('loc.r contains loc.e')>
	</cffunction>

</cfcomponent>