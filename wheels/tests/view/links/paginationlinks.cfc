component extends="wheels.tests.Test" {

	function setup(){
		_params = {controller="dummy", action="dummy"};
		_controller = controller("dummy", _params);
    _originalRoutes = application[$appKey()].routes;
    _originalRewrite = application.wheels.URLRewriting;
    $clearRoutes();
    drawRoutes()
    	.match(name="pagination", pattern="pag/ina/tion/[special]", to="pagi##nation")
    .end();
    $setNamedRoutePositions();
		application.wheels.URLRewriting = "On";
	}

  public void function teardown() {
    application[$appKey()].routes = _originalRoutes;
    application.wheels.URLRewriting = _originalRewrite;
  }

  public void function $clearRoutes() {
    application[$appKey()].routes = [];
    application.wheels.namedRoutePositions = {};
  }


  public void function $dump() {
    teardown();
    super.$dump(argumentCollection=arguments);
  }


	function test_current_page(){

		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		link = _controller.linkTo(text="2", params="page=2");
		result = _controller.paginationLinks(linkToCurrentPage=true);
		assert("result Contains '#link#'");
		result = _controller.paginationLinks(linkToCurrentPage=false);
		assert("result Does Not Contain '#link#' AND result Contains '2'");
	}

 	function test_class_and_classForCurrent(){

		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		defaultLink = _controller.linkTo(text="1", params="page=1", class="default");
		currentLink = _controller.linkTo(text="2", params="page=2", class="current");
		result = _controller.paginationLinks(linkToCurrentPage=true, class="default", classForCurrent="current");
		assert("result Contains '#defaultLink#'");
		assert("result Contains '#currentLink#'");
 	}

 	function test_route(){
		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		link = _controller.linkTo(route="pagination", special=99, text="3", params="page=3");
		result = _controller.paginationLinks(route="pagination", special=99);
		assert("result Contains '#link#' AND result Contains '?page='");
 	}

 	function test_page_as_route_param_with_route_not_containing_page_parameter_in_variables(){
		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		result = _controller.paginationLinks(route="pagination", special=99);
		assert("result Contains '/pag/ina/tion/99?page='");
		result = _controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false");
		assert("result Does Not Contain '/pag/ina/tion/99?page=' AND result contains '/pag/ina/tion/99'");
 	}

 	function test_page_as_route_param_with_route_containing_page_parameter_in_variables(){
    $clearRoutes();
    drawRoutes()
    	.match(name="pagination", pattern="pag/ina/tion/[special]/[page]", to="pagi##nation")
    .end();
    $setNamedRoutePositions();
		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		result = _controller.paginationLinks(route="pagination", special=99);
		assert("result Contains '/pag/ina/tion/99/3'");
		result = _controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false");
		assert("result Contains '/pag/ina/tion/99/3'");
 	}

}
