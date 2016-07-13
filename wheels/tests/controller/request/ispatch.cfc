component extends="wheelsMapping.Test" {
  include "common.cfm";

  function test_isPatch_with_head_request() {
    request.cgi.request_method = "patch";
    assert("loc.controller.isPatch()");
  }
  
  function test_isPatch_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isPatch()");
  }
}