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
		drawRoutes()
			.root(to="pages##index")
		.end();
		r = dispatch.$findMatchingRoute(path="", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_controller_only() {
		drawRoutes()
			.match(pattern="pages", to="pages##index")
		.end();
		r = dispatch.$findMatchingRoute(path="pages", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_controller_and_action_required() {
		drawRoutes()
			.match(pattern="pages/blah", to="pages##index")
		.end();
 		r = raised('dispatch.$findMatchingRoute(path="/pages", format="")');
		assert('r eq "Wheels.RouteNotFound"');
		r = dispatch.$findMatchingRoute(path="pages/blah", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

	function test_extra_variables_passed() {
		drawRoutes()
			.match(pattern="pages/blah/[firstname]/[lastname]", to="pages##index")
		.end();
		r = dispatch.$findMatchingRoute(path="pages/blah/tony/petruzzi", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
		assert('r.variables eq "firstname,lastname"');
	}

	function test_wildcard_route() {
		drawRoutes()
			.match(pattern="*", to="pages##index")
		.end();
		r = dispatch.$findMatchingRoute(path="thisismyroute/therearemanylikeit/butthisoneismine", format="");
		assert('r.controller eq "pages"');
		assert('r.action eq "index"');
	}

}
