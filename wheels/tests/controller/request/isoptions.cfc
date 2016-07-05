component extends="wheelsMapping.Test" {
  include "common.cfm";

  function test_isOptions_with_options_request() {
    request.cgi.request_method = "options";
    assert("loc.controller.isOptions()");
  }
  
  function test_isOptions_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isOptions()");
  }
}