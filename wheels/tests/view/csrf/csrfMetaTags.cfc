component extends="wheelsMapping.Test" {
  function setup() {
    loc.controller = controller(name="dummy");
  }

  function test_contains_csrfparam_meta_tag() {
    loc.tags = loc.controller.csrfMetaTags();
    loc.csrfParamTag = '<meta content="authenticityToken" name="csrf-param" />';
    assert("loc.tags contains '#loc.csrfParamTag#'");
  }

  function test_contains_csrftoken_meta_tag() {
    loc.token = CSRFGenerateToken();
    loc.tags = loc.controller.csrfMetaTags();
    loc.csrfTokenTag = '<meta content="#loc.token#" name="csrf-token" />';
    assert("loc.tags contains '#loc.csrfTokenTag#'");
  }
}
