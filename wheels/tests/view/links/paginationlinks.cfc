<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>

	<cffunction name="setup">
		<cfset var loc = StructNew()>
		<cfset copies = {}>
		<cfset StructAppend(copies, Duplicate(application.wheels))>
		<cfset test.controller = controller("dummy", params)>
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
		<cfset StructAppend(application.wheels, duplicate(copies), true)>
	</cffunction>
	
	<cffunction name="test_current_page">
		<cfset var loc = StructNew()>
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.link = test.controller.linkTo(text="2", params="page=2")>
		<cfset result = test.controller.paginationLinks(linkToCurrentPage=true)>
		<cfset assert("result Contains '#loc.link#'")>
		<cfset result = test.controller.paginationLinks(linkToCurrentPage=false)>
		<cfset assert("result Does Not Contain '#loc.link#' AND result Contains '2'")>
	</cffunction>

	<cffunction name="test_route">
		<cfset var loc = StructNew()>
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.link = test.controller.linkTo(route="pagination", special=99, text="3", params="page=3")>
		<cfset result = test.controller.paginationLinks(route="pagination", special=99)>
		<cfset assert("result Contains '#loc.link#' AND result Contains '?page='")>
	</cffunction>

	<cffunction name="test_page_as_route_param">
		<cfset var loc = StructNew()>
		<cfset loc.authors = model("author").findAll(page=2, perPage=3, order="lastName")>
		<cfset loc.addToPattern = "/[page]">
		<cfset loc.addToVariables = ",page">
		<cfset application.wheels.routes[2].pattern = application.wheels.routes[2].pattern & loc.addToPattern>
		<cfset application.wheels.routes[2].variables = application.wheels.routes[2].variables & loc.addToVariables>
		<cfset loc.link = test.controller.linkTo(route="pagination", special=99, text="3", page=3)>
		<cfset result = test.controller.paginationLinks(route="pagination", special=99, pageNumberAsParam=false)>
		<cfset assert("result Contains '#loc.link#' AND result Does Not Contain '?page='")>
	</cffunction>
	
</cfcomponent>