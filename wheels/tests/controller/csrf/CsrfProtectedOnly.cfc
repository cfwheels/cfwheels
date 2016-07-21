component extends="wheelsMapping.Test" {
  include "csrf_setup.cfm";

  function test_csrf_protection_with_valid_authenticityToken_on_post_request() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="create", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    loc.controller.$processAction("create", loc.params);
    assert('loc.controller.response() eq "Create ran."');
  }

  function test_csrf_protection_with_no_authenticityToken_on_post_request() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="create" };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    try {
      loc.controller.$processAction("create", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_invalid_authenticityToken_on_post_request() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="create", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    try {
      loc.controller.$processAction("create", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_skipped_csrf_protection_on_post_request_with_valid_authenticityToken() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="index", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    loc.controller.$processAction("create", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }

  function test_skipped_csrf_protection_on_post_request_with_no_authenticityToken() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="index" };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    loc.controller.$processAction("create", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }

  function test_skipped_csrf_protection_on_post_request_with_invalid_authenticityToken() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedOnly", action="index", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedOnly", loc.params);

    loc.controller.$processAction("create", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }
}
