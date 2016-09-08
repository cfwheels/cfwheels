component extends="wheels.tests.Test" {

	function test_issue_455() {
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]");
		$setNamedRoutePositions();
		oldUrlRewriting = application.wheels.URLRewriting;
		oldObfuscateUrls = application.wheels.obfuscateUrls;
		application.wheels.URLRewriting = "Off";
		application.wheels.obfuscateUrls = true;
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index");
		assert('r contains "b24dae"');
		application.wheels.URLRewriting = oldUrlRewriting;
		application.wheels.obfuscateUrls = oldObfuscateUrls;
	}

	function test_links_are_properly_hyphenated() {
		oldUrlRewriting = application.wheels.URLRewriting;
		application.wheels.URLRewriting = "On";
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action]");
		$setNamedRoutePositions();
		e = "/user/5559/survey-templates/index";
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index");
		assert('r contains e');
		application.wheels.URLRewriting = oldUrlRewriting;
	}

	function test_format_properly_add_with_route() {
		oldUrlRewriting = application.wheels.URLRewriting;
		application.wheels.URLRewriting = "On";
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]");
		$setNamedRoutePositions();
		e = "/user/5559/survey-templates/index.csv";
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv");
		assert('r contains e');
		application.wheels.URLRewriting = oldUrlRewriting;
	}

	function test_using_onlypath_correctly_detects_https() {
		request.cgi.server_protocol = "";
		request.cgi.server_port_secure = 1;
		addRoute(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]");
		$setNamedRoutePositions();
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv", onlyPath=false);
		assert('left(r, 5) eq "https"');
	}

}
