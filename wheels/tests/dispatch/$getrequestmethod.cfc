component extends="wheels.tests.Test" {

  function setup() {
    _originalForm = duplicate(form);
    _originalUrl = duplicate(url);
    _originalCgiMethod = request.cgi.request_method;
    structClear(form);
    structClear(url);
    d = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");
  }

  function teardown() {
    structClear(form);
    structClear(url);
    structAppend(form, _originalForm, false);
    structAppend(url, _originalUrl, false);
    request.cgi["request_method"] = _originalCgiMethod;
  }

  function test_get() {
    request.cgi["request_method"] = "GET";
    method = d.$getRequestMethod();
    assert('method eq "get"');
  }

  function test_get_override() {
    request.cgi["request_method"] = "GET";
    url._method = "delete";
    method = d.$getRequestMethod();
    assert('method eq "delete"');
  }

  function test_get_form_should_not_override() {
    request.cgi["request_method"] = "GET";
    form._method = "delete";
    method = d.$getRequestMethod();
    assert('method eq "GET"');
  }

  function test_post() {
    request.cgi["request_method"] = "POST";
    method = d.$getRequestMethod();
    assert('method eq "post"');
  }

  function test_post_override() {
    request.cgi["request_method"] = "POST";
    form._method = "PUT";
    method = d.$getRequestMethod();
    assert('method eq "PUT"');
  }

  function test_post_url_should_not_override() {
    request.cgi["request_method"] = "POST";
    url._method = "PUT";
    method = d.$getRequestMethod();
    assert('method eq "POST"');
  }

}
