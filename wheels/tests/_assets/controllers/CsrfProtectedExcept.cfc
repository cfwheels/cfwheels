component extends="wheelsMapping.Controller" {
  function init() {
    protectFromForgery(except="show");
  }

  function show() {
    renderText("Show ran.");
  }

  function update() {
    renderText("Update ran.");
  }
}
