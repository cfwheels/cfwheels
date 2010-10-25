<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.user = model("users")>
	</cffunction>

	<cffunction name="test_x_pagination_valid">
		<cfset loc.e = loc.user.findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset loc.controller.pagination("pagination_test_1")>
	</cffunction>

</cfcomponent>