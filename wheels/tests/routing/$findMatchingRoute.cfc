component extends="wheels.tests.Test" {

	function setup() {
		dispatch = createobject("component", "wheelsMapping.Dispatch");
		SavedRoutes = duplicate(application.wheels.routes);
		application.wheels.routes = [];
	}

	function teardown() {
		application.wheels.routes = SavedRoutes;
	}

	function test_empty_route() {
		addRoute(pattern="", controller="pages", action="index");
		r = dispatch.$findMatchingRoute(path="", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_controller_only() {
		addRoute(pattern="pages", controller="pages", action="index");
		r = dispatch.$findMatchingRoute(path="/pages", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_controller_and_action_required() {
		addRoute(pattern="pages/blah", controller="pages", action="index");
 		r = raised('dispatch.$findMatchingRoute(path="/pages", format="")');
		assert('r eq "Wheels.RouteNotFound"');
		r = dispatch.$findMatchingRoute(path="/pages/blah", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_extra_variables_passed() {
		addRoute(pattern="pages/blah/[firstname]/[lastname]", controller="pages", action="index");
		r = dispatch.$findMatchingRoute(path="/pages/blah/tony/petruzzi", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
		assert('r.variables eq "firstname,lastname"');
	}

	function test_wildcard_route() {
		addRoute(pattern="*", controller="pages", action="index");
		r = dispatch.$findMatchingRoute(path="/thisismyroute/therearemanylikeit/butthisoneismine", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

}
