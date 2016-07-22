component extends="wheels.tests.Test" {

	function setup(){
		copies = Duplicate(application.wheels);
		loc.params = {controller="dummy", action="dummy"};
		loc.controller = controller("dummy", loc.params);
		loc.route = StructNew();
		loc.route.name = "pagination";
		loc.route.pattern = "pag/ina/tion/[special]";
		loc.route.controller = "pagi";
		loc.route.action = "nation";
		loc.route.variables = "special";
		ArrayInsertAt(application.wheels.routes, 2, loc.route);
		application.wheels.namedRoutePositions.pagination = 2;
		application.wheels.URLRewriting = "on";
	}

	function teardown(){
		application.wheels = copies;
	}

	function test_current_page(){

		loc.authors = model("author").findAll(page=2, perPage=3, order="lastName");
		loc.link = loc.controller.linkTo(text="2", params="page=2");
		loc.result = loc.controller.paginationLinks(linkToCurrentPage=true);
		assert("loc.result Contains '#loc.link#'");
		loc.result = loc.controller.paginationLinks(linkToCurrentPage=false);
		assert("loc.result Does Not Contain '#loc.link#' AND loc.result Contains '2'");
	}

 	function test_class_and_classForCurrent(){

		loc.authors = model("author").findAll(page=2, perPage=3, order="lastName");
		loc.defaultLink = loc.controller.linkTo(text="1", params="page=1", class="default");
		loc.currentLink = loc.controller.linkTo(text="2", params="page=2", class="current");
		loc.result = loc.controller.paginationLinks(linkToCurrentPage=true, class="default", classForCurrent="current");
		assert("loc.result Contains '#loc.defaultLink#'");
		assert("loc.result Contains '#loc.currentLink#'");
 	}

 	function test_route(){
		loc.authors = model("author").findAll(page=2, perPage=3, order="lastName");
		loc.link = loc.controller.linkTo(route="pagination", special=99, text="3", params="page=3");
		loc.result = loc.controller.paginationLinks(route="pagination", special=99);
		assert("loc.result Contains '#loc.link#' AND loc.result Contains '?page='");
 	}

 	function test_page_as_route_param_with_route_not_containing_page_parameter_in_variables(){
		loc.authors = model("author").findAll(page=2, perPage=3, order="lastName");
		loc.result = loc.controller.paginationLinks(route="pagination", special=99);
		assert("loc.result Contains '/pag/ina/tion/99?page='");
		loc.result = loc.controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false");
		assert("loc.result Does Not Contain '/pag/ina/tion/99?page=' AND loc.result contains '/pag/ina/tion/99'");
 	}

 	function test_page_as_route_param_with_route_containing_page_parameter_in_variables(){
		loc.authors = model("author").findAll(page=2, perPage=3, order="lastName");
		loc.addToPattern = "/[page]";
		loc.addToVariables = ",page";
		application.wheels.routes[2].pattern = application.wheels.routes[2].pattern & loc.addToPattern;
		application.wheels.routes[2].variables = application.wheels.routes[2].variables & loc.addToVariables;
		loc.result = loc.controller.paginationLinks(route="pagination", special=99);
		assert("loc.result Contains '/pag/ina/tion/99/3'");
		loc.result = loc.controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false");
		assert("loc.result Contains '/pag/ina/tion/99/3'");
 	}

}
