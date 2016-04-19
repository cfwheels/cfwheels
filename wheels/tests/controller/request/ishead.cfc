component extends="wheelsMapping.Test" {
  include "common.cfm";

  function test_isHead_with_head_request() {
    request.cgi.request_method = "head";
    assert("loc.controller.isHead()");
  }
  
  function test_isHead_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isHead()");
  }
}