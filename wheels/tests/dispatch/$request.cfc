component extends="wheels.tests.Test" {

	function setup() {
		SavedRoutes = duplicate(application.wheels.routes);
		application.wheels.routes = [];
		dispatch = createobject("component", "wheelsMapping.Dispatch");
	}

	function teardown() {
		application.wheels.routes = SavedRoutes;
	}

 	function test_route_with_format() {
		addRoute(name="test", pattern="users/[username].[format]", controller="test", action="test");
		args = {};
		args.pathinfo = "/users/foo.bar";
		args.urlScope["username"] = "foo.bar";
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.controller eq "Test"');
		assert('_params.action eq "test"');
		assert('_params.username eq "foo"');
		assert('_params.format eq "bar"');
	}

 	function test_route_with_format_only() {
		addRoute(name="test", pattern="contact/export.[format]", controller="test", action="test");
		args = {};
		args.pathinfo = "/contact/export.csv";
		args.urlScope = {};
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.controller eq "Test"');
		assert('_params.action eq "test"');
		assert('_params.format eq "csv"');
	}

 	function test_route_without_format_should_ignore_fullstops() {
		addRoute(name="test", pattern="users/[username]", controller="test", action="test");
		args = {};
		args.pathinfo = "/users/foo.bar";
		args.urlScope["username"] = "foo.bar";
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.username eq "foo.bar"');
	}

 	function test_route_with_format_and_format_not_specified() {
		addRoute(name="test", pattern="users/[username].[format]", controller="test", action="test");
		args = {};
		args.pathinfo = "/users/foo";
		args.urlScope["username"] = "foo";
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.controller eq "Test"');
		assert('_params.action eq "test"');
		assert('_params.username eq "foo"');
		assert('_params.format eq ""');
	}

}
