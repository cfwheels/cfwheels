component extends="wheelsMapping.Test" {
  include "common.cfm";

  function test_isPut_with_head_request() {
    request.cgi.request_method = "put";
    assert("loc.controller.isPut()");
  }
  
  function test_isPut_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isPut()");
  }
}