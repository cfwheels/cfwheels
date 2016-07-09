<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset oldUrlRewriting = application.wheels.URLRewriting>
		<cfset oldObfuscateUrls =application.wheels.obfuscateUrls>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.URLRewriting = oldUrlRewriting>
		<cfset application.wheels.obfuscateUrls = oldObfuscateUrls>
	</cffunction>

	<!---
		NOTE: this test fails when not run first..
		loc.r will return as /user/777/survey-templates/index (no .csv)
		Could possibly be something with caching.
	 --->
	<cffunction name="test_format_properly_add_with_route">
		<cfscript>
		application.wheels.URLRewriting = "On";
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]");
		$setNamedRoutePositions();
		loc.e = "/user/777/survey-templates/index.csv";
		loc.r = urlFor(route="user_2", user_id="777", controller="SurveyTemplates", action="index", format="csv");
		assert(loc.r contains loc.e);
		</cfscript>
	</cffunction>

	<cffunction name="test_issue_455">
		<cfscript>
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]");
		$setNamedRoutePositions();
		application.wheels.URLRewriting = "Off";
		application.wheels.obfuscateUrls = true;
		loc.r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index");
		assert(loc.r contains "b24dae");
		</cfscript>
	</cffunction>

	<cffunction name="test_links_are_properly_hyphenated">
	<cfscript>
		application.wheels.URLRewriting = "On";
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]");
		$setNamedRoutePositions();
		loc.e = "/user/666/survey-templates/index";
		loc.r = urlFor(route="user_2", user_id="666", controller="SurveyTemplates", action="index");
		assert(loc.r contains loc.e);
		</cfscript>
	</cffunction>

	<cffunction name="test_using_onlypath_correctly_detects_https">
	<cfscript>
		request.cgi.server_protocol = "";
		request.cgi.server_port_secure = 1;
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]");
		$setNamedRoutePositions();
		loc.r = urlFor(route="user_2", user_id="888", controller="SurveyTemplates", action="index", format="csv", onlyPath=false);
		assert(left(loc.r, 5) eq "https");
		</cfscript>
	</cffunction>

</cfcomponent>
