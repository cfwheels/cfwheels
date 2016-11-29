component extends="wheels.tests.Test" {

  include "helpers.cfm";

  public void function setup() {
    config = {
      path="wheels"
      ,fileName="Mapper"
      ,method="init"
    };
    _params = {controller="test", action="index"};
    _originalRoutes = application[$appKey()].routes;
  }

  // match

  function test_match_with_basic_arguments() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().match(name="signIn", method="get", controller="sessions", action="new").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    assert('route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_with_to_argument() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().match(name="signIn", method="get", to="sessions##new").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    assert('route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_without_name() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().match(pattern="/sign-in", method="get", to="sessions##new").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    nameExists = structKeyExists(route, "name");
    assert('not nameExists and route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_raises_error_without_name_or_pattern() {
    $clearRoutes();
    mapper = $mapper().draw();
    e = raised('mapper.match(method="get", controller="sessions", action="new")');
    assert('e eq "Wheels.MapperArgumentMissing"');
  }

  function test_match_with_basic_arguments_and_controller_scoped() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().controller("sessions").match(name="signIn", method="get", action="new").end().end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    assert('route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_with_basic_arguments_and_module_scoped() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().namespace("admin").match(name="signIn", method="get", action="new", controller="sessions").end().end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    assert('route.controller eq "admin.Sessions" and route.action eq "new"');
  }

  function test_match_with_module_scope_and_controller_scope() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().namespace("admin").controller("sessions").match(name="signIn", method="get", action="new").end().end().end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    assert('route.controller eq "admin.Sessions" and route.action eq "new"');
  }

  function test_match_after_disabling_methods() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw(restful=false, methods=false).match(pattern="/sign-in", method="get", to="sessions##new").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 1");
    route = application.wheels.routes[1];
    methodExists = structKeyExists(route, "method");
    assert('methodExists eq false and route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_with_single_optional_pattern_segment() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().match(pattern="/sign-in(.[format])", method="get", to="sessions##new").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 2");
    route = application.wheels.routes[1];
    methodExists = structKeyExists(route, "method");
    assert('methodExists eq false and route.controller eq "sessions" and route.action eq "new"');
  }

  function test_match_with_multiple_optional_pattern_segment() {
    $clearRoutes();
    mapper = $mapper();
    mapper.draw().match(pattern="/[controller](/[action](/[key](.[format])))", action="index", method="get").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 4");
    route = application.wheels.routes[1];
    assert('route.variables eq "controller,action,key,format"');
  }


}
