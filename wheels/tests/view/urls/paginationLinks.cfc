<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
		<cfset loc.user = model("users")>
	</cffunction>

	<cffunction name="test_x_paginationLinks_valid">
		<cfset loc.e = loc.user.findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset loc.controller.paginationLinks(year=2009, month="feb", day=10, handle="pagination_test_1")>
	</cffunction>

</cfcomponent>