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

  function test_mapper_init_defaults() {
    mapper = $mapper();
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq true AND mapperVarScope.methods eq true');
  }

  function test_mapper_init_restful_false() {
    mapper = $mapper(restful=false);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq false');
  }

  function test_mapper_init_restful_false_methods_true() {
    mapper = $mapper(restful=false, methods=true);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq true');
  }
}
