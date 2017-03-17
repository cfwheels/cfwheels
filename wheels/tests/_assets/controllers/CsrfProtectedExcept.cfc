component extends="Controller" {
  function init() {
    protectsFromForgery(except="show");
  }

  function show() {
    renderText("Show ran.");
  }

  function update() {
    renderText("Update ran.");
  }
}
