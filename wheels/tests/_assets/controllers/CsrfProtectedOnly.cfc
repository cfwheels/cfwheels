component extends="Controller" {
  function init() {
    protectsFromForgery(only="create");
  }

  function index() {
    renderText("Index ran.");
  }

  function create() {
    renderText("Create ran.");
  }
}
