component extends="wheelsMapping.Test" {
  function setup() {
    loc.controller = controller(name="dummy");
  }

  function test_authenticityTokenField() {
    loc.token = CSRFGenerateToken();
    loc.tag = loc.controller.authenticityTokenField();
    loc.authenticityTokenField = '<input id="authenticityToken" name="authenticityToken" type="hidden" value="#loc.token#" />';
    assert("loc.tag is '#loc.authenticityTokenField#'");
  }
}
