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

  // draw

  function test_draw_defaults() {
    mapper = $mapper().draw();
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq true AND mapperVarScope.methods eq true');
  }

  function test_draw_restful_false() {
    mapper = $mapper(restful=false).draw(restful=false);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq false');
  }

  function test_draw_restful_false_methods_true() {
    mapper = $mapper(restful=false, methods=true).draw(restful=false, methods=true);
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    assert('mapperVarScope.restful eq false AND mapperVarScope.methods eq true');
  }

  function test_draw_resets_the_stack() {
    mapper = $mapper().draw();
    mapper.inspect = $inspect;
    mapperVarScope = mapper.inspect();
    stackLen = arrayLen(mapperVarScope.scopeStack);
    assert('stackLen eq 1');
  }

  function test_end_removes_top_of_stack() {
    mapper = $mapper().draw();
    mapper.inspect = $inspect;
    drawVarScope = mapper.inspect();
    drawLen = arrayLen(drawVarScope.scopeStack);
    mapper.end();
    endVarScope = mapper.inspect();
    endLen = arrayLen(endVarScope.scopeStack);
    assert('drawLen eq 1 and endLen eq 0');
  }
}
