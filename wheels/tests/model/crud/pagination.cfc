<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_exist_early_if_no_records_match_where_clause">
		<cfset loc.e = model("user").findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset assert('request.wheels.pagination_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_1.TOTALPAGES eq 0')>
		<cfset assert('request.wheels.pagination_test_1.TOTALRECORDS eq 0')>
		<cfset assert("loc.e.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_1st_page">
		<cfset loc.e = model("user").findAll(perpage="2", page="1", handle="pagination_test_2", order="id")>
		<cfset assert('request.wheels.pagination_test_2.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_2.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_2.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('valuelist(loc.e.id) eq "1,2"')>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_2nd_page">
		<cfset loc.e = model("user").findAll(perpage="2", page="2", handle="pagination_test_3", order="id")>
		<cfset assert('request.wheels.pagination_test_3.CURRENTPAGE eq 2')>
		<cfset assert('request.wheels.pagination_test_3.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_3.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('valuelist(loc.e.id) eq "3,4"')>
	</cffunction>

	<cffunction name="test_5_records_2_returned_3_pages_3rd_page">
		<cfset loc.e = model("user").findAll(perpage="2", page="3", handle="pagination_test_4", order="id")>
		<cfset assert('request.wheels.pagination_test_4.CURRENTPAGE eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 1")>
		<cfset assert('valuelist(loc.e.id) eq "5"')>
	</cffunction>

	<cffunction name="test_specify_where_on_joined_table">
		<!--- 10 records, 2 perpage, 5 pages --->
		<cfset loc.args = {
				perpage="2"
				,page="1"
				,handle="pagination_test"
				,order="photogalleryphotoid"
				,include="photogalleries"
				,where="photogalleryid = 2"
		}>

		<!--- page 1 --->
		<cfset loc.q = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset loc.r = valuelist(loc.q.photogalleryphotoid)>
		<cfset loc.e = "11,12">
		<cfset assert('loc.e eq loc.r')>

		<!--- page 3 --->
		<cfset loc.args.page = "3">
		<cfset loc.q = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset loc.r = valuelist(loc.q.photogalleryphotoid)>
		<cfset loc.e = "15,16">
		<cfset assert('loc.e eq loc.r')>

		<!--- page 5 --->
		<cfset loc.args.page = "5">
		<cfset loc.q = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset loc.r = valuelist(loc.q.photogalleryphotoid)>
		<cfset loc.e = "19,20">
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>