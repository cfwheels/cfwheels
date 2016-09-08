component extends="wheels.tests.Test" {

	function setup(){
		copies = Duplicate(application.wheels);
		_params = {controller="dummy", action="dummy"};
		_controller = controller("dummy", _params);
		route = StructNew();
		route.name = "pagination";
		route.pattern = "pag/ina/tion/[special]";
		route.controller = "pagi";
		route.action = "nation";
		route.variables = "special";
		ArrayInsertAt(application.wheels.routes, 2, route);
		application.wheels.namedRoutePositions.pagination = 2;
		application.wheels.URLRewriting = "On";
	}

	function teardown(){
		application.wheels = copies;
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
		authors = model("author").findAll(page=2, perPage=3, order="lastName");
		addToPattern = "/[page]";
		addToVariables = ",page";
		application.wheels.routes[2].pattern = application.wheels.routes[2].pattern & addToPattern;
		application.wheels.routes[2].variables = application.wheels.routes[2].variables & addToVariables;
		result = _controller.paginationLinks(route="pagination", special=99);
		assert("result Contains '/pag/ina/tion/99/3'");
		result = _controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false");
		assert("result Contains '/pag/ina/tion/99/3'");
 	}

}
