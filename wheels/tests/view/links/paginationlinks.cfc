<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset copies = Duplicate(application.wheels)>
		<cfset loc.params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", loc.params)>
		<cfset loc.route = StructNew()>
		<cfset loc.route.name = "pagination">
		<cfset loc.route.pattern = "pag/ina/tion/[special]">
		<cfset loc.route.controller = "pagi">
		<cfset loc.route.action = "nation">
		<cfset loc.route.variables = "special">
		<cfset ArrayInsertAt(application.wheels.routes, 2, loc.route)>
		<cfset application.wheels.namedRoutePositions.pagination = [2]>
		<cfset application.wheels.URLRewriting = "on">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels = copies>
	</cffunction>
	
	<cffunction name="test_current_page">
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.link = loc.controller.linkTo(text="2", params="page=2")>
		<cfset loc.result = loc.controller.paginationLinks(linkToCurrentPage=true)>
		<cfset assert("loc.result Contains '#loc.link#'")>
		<cfset loc.result = loc.controller.paginationLinks(linkToCurrentPage=false)>
		<cfset assert("loc.result Does Not Contain '#loc.link#' AND loc.result Contains '2'")>
	</cffunction>

	<cffunction name="test_class_and_classForCurrent">
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.defaultLink = loc.controller.linkTo(text="1", params="page=1", class="default")>
		<cfset loc.currentLink = loc.controller.linkTo(text="2", params="page=2", class="current")>
		<cfset loc.result = loc.controller.paginationLinks(linkToCurrentPage=true, class="default", classForCurrent="current")>
		<cfset assert("loc.result Contains '#loc.defaultLink#'")>
		<cfset assert("loc.result Contains '#loc.currentLink#'")>
	</cffunction>

	<cffunction name="test_route">
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.link = loc.controller.linkTo(route="pagination", special=99, text="3", params="page=3")>
		<cfset loc.result = loc.controller.paginationLinks(route="pagination", special=99)>
		<cfset assert("loc.result Contains '#loc.link#' AND loc.result Contains '?page='")>
	</cffunction>

	<cffunction name="test_page_as_route_param_with_route_not_containing_page_parameter_in_variables">
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		
		<cfset loc.result = loc.controller.paginationLinks(route="pagination", special=99)>
		<cfset assert("loc.result Contains '/pag/ina/tion/99?page='")>
		
		<cfset loc.result = loc.controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false")>
		<cfset assert("loc.result Does Not Contain '/pag/ina/tion/99?page=' AND loc.result contains '/pag/ina/tion/99'")>		
	</cffunction>
	
	<cffunction name="test_page_as_route_param_with_route_containing_page_parameter_in_variables">
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		
		<cfset loc.addToPattern = "/[page]">
		<cfset loc.addToVariables = ",page">
		<cfset application.wheels.routes[2].pattern = application.wheels.routes[2].pattern & loc.addToPattern>
		<cfset application.wheels.routes[2].variables = application.wheels.routes[2].variables & loc.addToVariables>
		
		<cfset loc.result = loc.controller.paginationLinks(route="pagination", special=99)>
		<cfset assert("loc.result Contains '/pag/ina/tion/99/3'")>
		
		<cfset loc.result = loc.controller.paginationLinks(route="pagination", special=99, pageNumberAsParam="false")>
		<cfset assert("loc.result Contains '/pag/ina/tion/99/3'")>
	</cffunction>
	
</cfcomponent>