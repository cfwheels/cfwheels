component extends="wheelsMapping.Test" {
  include "common.cfm";

  function test_isDelete_with_head_request() {
    request.cgi.request_method = "delete";
    assert("loc.controller.isDelete()");
  }
  
  function test_isDelete_with_get_request() {
    request.cgi.request_method = "get";
    assert("not loc.controller.isDelete()");
  }
}