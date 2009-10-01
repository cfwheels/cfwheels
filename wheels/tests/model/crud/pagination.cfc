<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("Users")>

	<cffunction name="test_exist_early_if_no_records_match_where_clause">
		<cfset loc.e = global.user.findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset assert('request.wheels.pagination_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_1.TOTALPAGES eq 0')>
		<cfset assert('request.wheels.pagination_test_1.TOTALRECORDS eq 0')>
		<cfset assert("loc.e.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_1st_page">
		<cfset loc.e = global.user.findAll(perpage="2", page="1", handle="pagination_test_2", order="id")>
		<cfset assert('request.wheels.pagination_test_2.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_2.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_2.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('valuelist(loc.e.id) eq "1,2"')>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_2nd_page">
		<cfset loc.e = global.user.findAll(perpage="2", page="2", handle="pagination_test_3", order="id")>
		<cfset assert('request.wheels.pagination_test_3.CURRENTPAGE eq 2')>
		<cfset assert('request.wheels.pagination_test_3.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_3.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('valuelist(loc.e.id) eq "3,4"')>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_3rd_page">
		<cfset loc.e = global.user.findAll(perpage="2", page="3", handle="pagination_test_4", order="id")>
		<cfset assert('request.wheels.pagination_test_4.CURRENTPAGE eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 1")>
		<cfset assert('valuelist(loc.e.id) eq "5"')>
	</cffunction>

</cfcomponent>