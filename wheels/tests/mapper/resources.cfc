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

  // resource

  function test_resource_produces_routes() {
    $clearROutes();
    mapper = $mapper();
    mapper.draw().resource(name="pigeon").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 12");
  }

  function test_resource_produces_routes_with_list() {
    $clearROutes();
    mapper = $mapper();
    mapper.draw().resource(name="pigeon,pudding").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 24");
  }

  function test_resource_raises_error_with_list_and_nesting() {
    $clearROutes();
    mapper = $mapper().draw();
    e = raised('mapper.resource(name="pigeon,pudding", nested=true).end()');
    assert('e eq "Wheels.InvalidResource"');
  }

  // resources

  function test_resources_produces_routes() {
    $clearROutes();
    mapper = $mapper();
    mapper.draw().resources(name="pigeons").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 14");
  }

  function test_resources_produces_routes_with_list() {
    $clearROutes();
    mapper = $mapper();
    mapper.draw().resources(name="pigeons,birds").end();
    routesLen = arrayLen(application.wheels.routes);
    assert("routesLen eq 28");
  }

  function test_resources_raises_error_with_list_and_nesting() {
    $clearROutes();
    mapper = $mapper().draw();
    e = raised('mapper.resources(name="pigeon,birds", nested=true).end()');
    assert('e eq "Wheels.InvalidResource"');
  }
}
