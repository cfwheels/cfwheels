component extends="wheels.tests.Test" {

  function setup() {
    include "setup.cfm";
  }

  function teardown() {
    include "teardown.cfm";
  }

  function test_isOptions_with_options_request() {
    request.cgi.request_method = "options";
    assert("loc.controller.isOptions()");
  }

  function test_isOptions_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isOptions()");
  }
}
