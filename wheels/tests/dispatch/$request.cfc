component extends="wheels.tests.Test" {

  public void function setup() {
    _params = {controller="test", action="index"};
    _originalRoutes = application[$appKey()].routes;
		application.wheels.routes = [];
		dispatch = createobject("component", "wheelsMapping.Dispatch");
  }

  public void function teardown() {
    application[$appKey()].routes = _originalRoutes;
  }

  public void function $dump() {
    teardown();
    super.$dump(argumentCollection=arguments);
  }

 	function test_route_with_format() {
		drawRoutes()
			.match(pattern="users/[username].[format]", controller="test", action="test")
		.end();
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
		drawRoutes()
			.match(pattern="contact/export.[format]", controller="test", action="test")
		.end();
		args = {};
		args.pathinfo = "/contact/export.csv";
		args.urlScope = {};
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.controller eq "Test"');
		assert('_params.action eq "test"');
		assert('_params.format eq "csv"');
	}

 	function test_route_without_format_should_ignore_fullstops() {
		drawRoutes()
			.match(pattern="users/[username]", controller="test", action="test", constraints={ "username" = "[^/]+"})
		.end();
		args = {};
		args.pathinfo = "/users/foo.bar";
		args.urlScope["username"] = "foo.bar";
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.username eq "foo.bar"');
	}

 	function test_route_with_format_and_format_not_specified() {
		drawRoutes()
			.match(pattern="users/[username](.[format])", controller="test", action="test")
		.end();
		args = {};
		args.pathinfo = "/users/foo";
		args.urlScope["username"] = "foo";
		_params = dispatch.$paramParser(argumentCollection=args);
		assert('_params.controller eq "Test"');
		assert('_params.action eq "test"');
		assert('_params.username eq "foo"');
		assert('!structKeyExists(_params, "format")');
	}

}
