component extends="wheelsMapping.Test" {
  include "csrf_setup.cfm";

  function test_csrf_protection_with_valid_authenticityToken_on_PATCH_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="update", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Update ran."');
  }

  function test_csrf_protection_with_no_authenticityToken_on_PATCH_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="update" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_invalid_authenticityToken_on_PATCH_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="update", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_valid_x_csrf_token_header_on_ajax_PATCH_request() {
    request.headers["X-CSRF-TOKEN"] = CSRFGenerateToken();
    request.cgi.request_method = "PATCH";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="update" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Update ran."');
  }

  function test_csrf_protection_with_no_x_csrf_token_header_on_ajax_PATCH_request() {
    request.cgi.request_method = "PATCH";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="update" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_invalid_x_csrf_token_header_on_ajax_PATCH_request() {
    request.headers["X-CSRF-TOKEN"] = "#CSRFGenerateToken()#1";
    request.cgi.request_method = "POST";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="update" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_skipped_csrf_protection_on_PATCH_request_with_valid_authenticityToken() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="show", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }

  function test_skipped_csrf_protection_on_PATCH_request_with_no_authenticityToken() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="show" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }

  function test_skipped_csrf_protection_on_PATCH_request_with_invalid_authenticityToken() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedExcept", action="show", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }

  function test_skipped_csrf_protection_on_ajax_PATCH_request_with_valid_x_csrf_token_header() {
    request.headers["X-CSRF-TOKEN"] = CSRFGenerateToken();
    request.cgi.request_method = "PATCH";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="show" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }

  function test_skipped_csrf_protection_on_ajax_PATCH_request_with_no_x_csrf_token_header() {
    request.cgi.request_method = "PATCH";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="show" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }

  function test_skipped_csrf_protection_on_ajax_PATCH_request_with_invalid_x_csrf_token_header() {
    request.headers["X-CSRF-TOKEN"] = "#CSRFGenerateToken()#1";
    request.cgi.request_method = "PATCH";
    request.cgi.http_x_requested_with = "XMLHTTPRequest";
    loc.params = { controller="csrfProtectedExcept", action="show" };
    loc.controller = controller("csrfProtectedExcept", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Show ran."');
  }
}
