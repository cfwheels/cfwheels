component extends="wheelsMapping.Test" {
  include "csrf_setup.cfm";

  function test_csrf_protection_skipped_on_get_request() {
    loc.params = { controller="csrfProtectedWithException", action="index" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("index", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }

  function test_csrf_protection_skipped_on_options_request() {
    request.cgi.request_method = "OPTIONS";
    loc.params = { controller="csrfProtectedWithException", action="index" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("index", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }

  function test_csrf_protection_skipped_on_head_request() {
    request.cgi.request_method = "HEAD";
    loc.params = { controller="csrfProtectedWithException", action="index" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("index", loc.params);
    assert('loc.controller.response() eq "Index ran."');
  }

  function test_csrf_protection_with_valid_authenticityToken_on_post_request() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedWithException", action="create", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("create", loc.params);
    assert('loc.controller.response() eq "Create ran."');
  }

  function test_csrf_protection_with_no_authenticityToken_on_post_request() {
    request.cgi.request_method = "POST";
    loc.params = { controller="csrfProtectedWithException", action="create" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

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
    loc.params = { controller="csrfProtectedWithException", action="create", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    try {
      loc.controller.$processAction("create", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_valid_authenticityToken_on_patch_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedWithException", action="update", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("update", loc.params);
    assert('loc.controller.response() eq "Update ran."');
  }

  function test_csrf_protection_with_no_authenticityToken_on_patch_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedWithException", action="update" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_invalid_authenticityToken_on_patch_request() {
    request.cgi.request_method = "PATCH";
    loc.params = { controller="csrfProtectedWithException", action="update", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    try {
      loc.controller.$processAction("update", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_valid_authenticityToken_on_delete_request() {
    request.cgi.request_method = "DELETE";
    loc.params = { controller="csrfProtectedWithException", action="delete", authenticityToken=CSRFGenerateToken() };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    loc.controller.$processAction("delete", loc.params);
    assert('loc.controller.response() eq "Delete ran."');
  }

  function test_csrf_protection_with_no_authenticityToken_on_delete_request() {
    request.cgi.request_method = "DELETE";
    loc.params = { controller="csrfProtectedWithException", action="delete" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    try {
      loc.controller.$processAction("delete", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }

  function test_csrf_protection_with_invalid_authenticityToken_on_delete_request() {
    request.cgi.request_method = "DELETE";
    loc.params = { controller="csrfProtectedWithException", action="delete", authenticityToken="#CSRFGenerateToken()#1" };
    loc.controller = controller("csrfProtectedWithException", loc.params);

    try {
      loc.controller.$processAction("delete", loc.params);
      fail("Wheels.InvalidAuthenticityToken error did not occur.");
    }
    catch (any e) {
      loc.type = e.Type;
      assert("loc.type is 'Wheels.InvalidAuthenticityToken'");
    }
  }
}
