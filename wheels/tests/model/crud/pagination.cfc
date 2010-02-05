<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_exist_early_if_no_records_match_where_clause">
		<cfset loc.e = model("user").findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset assert('request.wheels.pagination_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_1.TOTALPAGES eq 0')>
		<cfset assert('request.wheels.pagination_test_1.TOTALRECORDS eq 0')>
		<cfset assert("loc.e.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_5_records_2_perpage_3_pages">
		<cfset loc.r = model("user").findAll(select="id", order="id")>

		<!--- 1st page --->
		<cfset loc.e = model("user").findAll(select="id", perpage="2", page="1", handle="pagination_test_2", order="id")>
		<cfset assert('request.wheels.pagination_test_2.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_2.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_2.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('loc.e.id[1] eq loc.r.id[1]')>
		<cfset assert('loc.e.id[2] eq loc.r.id[2]')>

		<!--- 2nd page --->
		<cfset loc.e = model("user").findAll(perpage="2", page="2", handle="pagination_test_3", order="id")>
		<cfset assert('request.wheels.pagination_test_3.CURRENTPAGE eq 2')>
		<cfset assert('request.wheels.pagination_test_3.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_3.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('loc.e.id[1] eq loc.r.id[3]')>
		<cfset assert('loc.e.id[2] eq loc.r.id[4]')>

		<!--- 3rd page --->
		<cfset loc.e = model("user").findAll(perpage="2", page="3", handle="pagination_test_4", order="id")>
		<cfset assert('request.wheels.pagination_test_4.CURRENTPAGE eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALRECORDS eq 5')>
		<cfset assert("loc.e.recordcount eq 1")>
		<cfset assert('loc.e.id[1] eq loc.r.id[5]')>
	</cffunction>

	<cffunction name="test_specify_where_on_joined_table">
		<cfset loc.q = model("photogallery").findOne(
		        include="users"
		        ,where="users.lastname = 'petruzzi'"
		        ,orderby="photogalleryid"
		)>

		<!--- 10 records, 2 perpage, 5 pages --->
		<cfset loc.args = {
		                perpage="2"
		                ,page="1"
		                ,handle="pagination_test"
		                ,order="photogalleryphotoid"
		                ,include="photogallery"
		                ,where="photogalleryid = #loc.q.photogalleryid#"
		}>

		<cfset loc.args2 = duplicate(loc.args)>
		<cfset structdelete(loc.args2, "perpage", false)>
		<cfset structdelete(loc.args2, "page", false)>
		<cfset structdelete(loc.args2, "handle", false)>
		<cfset loc.r = model("photogalleryphoto").findAll(argumentCollection=loc.args2)>

		<!--- page 1 --->
		<cfset loc.e = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.photogalleryid[1] eq loc.r.photogalleryid[1]')>
		<cfset assert('loc.e.photogalleryid[2] eq loc.r.photogalleryid[2]')>

		<!--- page 3 --->
		<cfset loc.args.page = "3">
		<cfset loc.e = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.photogalleryid[1] eq loc.r.photogalleryid[5]')>
		<cfset assert('loc.e.photogalleryid[2] eq loc.r.photogalleryid[6]')>

		<!--- page 5 --->
		<cfset loc.args.page = "5">
		<cfset loc.e = model("photogalleryphoto").findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.photogalleryid[1] eq loc.r.photogalleryid[9]')>
		<cfset assert('loc.e.photogalleryid[2] eq loc.r.photogalleryid[10]')>
	</cffunction>

</cfcomponent>