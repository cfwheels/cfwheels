component extends="wheels.tests.Test" {

  include "helpers.cfm";

  function setup() {
    config = {
      path="wheels"
      ,fileName="Mapper"
      ,method="init"
    };
    _params = {controller="test", action="index"};
  }

  function test_mapper_init_defaults() {
    mapper = $mapper(argumentCollection=config);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq true AND mapperVarScope.methods eq true');
  }

  function test_mapper_init_restful_false() {
    mapper = $mapper(argumentCollection=config, restful=false);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq false');
  }

  function test_mapper_init_restful_false_methods_true() {
    mapper = $mapper(argumentCollection=config, restful=false, methods=true);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq true');
  }
}
