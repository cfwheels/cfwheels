component extends="wheels.Test" {
  function setup() {
    _controller = controller(name="dummy");
  }

  function test_authenticityTokenField() {
    local.token = CSRFGenerateToken();
    tag = _controller.authenticityTokenField();
    authenticityTokenField = '<input id="authenticityToken" name="authenticityToken" type="hidden" value="#local.token#">';
    assert("tag is '#authenticityTokenField#'");
  }
}
