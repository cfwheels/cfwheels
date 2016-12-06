component extends="wheels.tests.Test" {

	function setup() {
    config = {
      path="wheels"
      ,fileName="Mapper"
      ,method="init"
    };
    _params = {controller="test", action="index"};
    _originalRoutes = application[$appKey()].routes;
		_originalUrlRewriting = application.wheels.URLRewriting;
		_originalObfuscateUrls = application.wheels.obfuscateUrls;
	}

  public struct function $mapper() {
    local.args = duplicate(config);
    structAppend(local.args, arguments, true);
    return $createObjectFromRoot(argumentCollection=local.args);
  }

  public void function teardown() {
    application.wheels.routes = _originalRoutes;
		application.wheels.URLRewriting = _originalUrlRewriting;
		application.wheels.obfuscateUrls = _originalObfuscateUrls;
  }

  public void function $clearRoutes() {
    application[$appKey()].routes = [];
  }

  public void function $dump() {
    teardown();
    super.$dump(argumentCollection=arguments);
  }

	function test_issue_455() {
		mapper = $mapper();
		mapper.draw().match(name="user_2", pattern="user/[user_id]/[controller]/[action]").end();
		$setNamedRoutePositions();
		application.wheels.URLRewriting = "Off";
		application.wheels.obfuscateUrls = true;
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index");
		assert('r contains "b24dae"');
	}

	function test_links_are_properly_hyphenated() {
		mapper = $mapper();
		mapper.draw().match(name="user_2", pattern="user/[user_id]/[controller]/[action]").end();
		$setNamedRoutePositions();
		application.wheels.URLRewriting = "On";
		e = "/user/5559/survey-templates/index";
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index");
		assert('r contains e');
	}

	function test_format_properly_add_with_route() {
		mapper = $mapper();
		mapper.draw().match(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]").end();
		$setNamedRoutePositions();
		application.wheels.URLRewriting = "On";
		e = "/user/5559/survey-templates/index.csv";
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv");
		assert('r contains e');
	}

	function test_using_onlypath_correctly_detects_https() {
		mapper = $mapper();
		mapper.draw().match(name="user_2", pattern="user/[user_id]/[controller]/[action].[format]").end();
		$setNamedRoutePositions();
		request.cgi.server_protocol = "";
		request.cgi.server_port_secure = 1;
		r = urlFor(route="user_2", user_id="5559", controller="SurveyTemplates", action="index", format="csv", onlyPath=false);
		assert('left(r, 5) eq "https"');
	}

}
