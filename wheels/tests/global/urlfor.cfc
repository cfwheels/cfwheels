<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset oldUrlRewriting = application.wheels.URLRewriting>
		<cfset oldObfuscateUrls = application.wheels.obfuscateUrls>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.URLRewriting = oldUrlRewriting>
		<cfset application.wheels.obfuscateUrls = oldObfuscateUrls>
	</cffunction>

	<cffunction name="test_issue_455">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]")>
		<cfset $setNamedRoutePositions()>
		<cfset application.wheels.URLRewriting = "Off">
		<cfset application.wheels.obfuscateUrls = true>
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index")>
		<cfset assert(loc.r contains "b24dae")>
	</cffunction>

	<cffunction name="test_links_are_properly_hyphenated">
		<cfset application.wheels.URLRewriting = "On">
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.e = "/user/5559/survey-templates/index">
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index")>
		<cfset assert(loc.r contains loc.e)>
	</cffunction>

	<cffunction name="test_format_properly_add_with_route">
		<cfscript>
		application.wheels.URLRewriting = "On";
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]");
		$setNamedRoutePositions();
		loc.e = "/user/5559/survey-templates/index.csv";
		loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv");
		assert(loc.r contains loc.e);
		</cfscript>
	</cffunction>

	<cffunction name="test_using_onlypath_correctly_detects_https">
		<cfset request.cgi.server_protocol = "">
		<cfset request.cgi.server_port_secure = 1>
		<cfset addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv", onlyPath=false)>
		<cfset assert(left(loc.r, 5) eq "https")>
	</cffunction>

</cfcomponent>
