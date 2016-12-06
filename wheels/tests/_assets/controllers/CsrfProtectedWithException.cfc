component extends="wheelsMapping.Controller" {
  function init() {
    protectFromForgery();
  }

  function index() {
    renderText("Index ran.");
  }

  function create() {
    renderText("Create ran.");
  }

  function update() {
    renderText("Update ran.");
  }

  function delete() {
    renderText("Delete ran.");
  }
}
