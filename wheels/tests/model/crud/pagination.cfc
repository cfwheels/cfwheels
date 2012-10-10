<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.user = model("user")>
		<cfset loc.photo = model("photo")>
		<cfset loc.gallery = model("gallery")>
	</cffunction>

	<cffunction name="test_exist_early_if_no_records_match_where_clause">
		<cfset loc.e = loc.user.findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id")>
		<cfset assert('request.wheels.pagination_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_1.TOTALPAGES eq 0')>
		<cfset assert('request.wheels.pagination_test_1.TOTALRECORDS eq 0')>
		<cfset assert('request.wheels.pagination_test_1.ENDROW eq 1')>
		<cfset assert("loc.e.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_5_records_2_perpage_3_pages">
		<cfset loc.r = loc.user.findAll(select="id", order="id")>

		<!--- 1st page --->
		<cfset loc.e = loc.user.findAll(select="id", perpage="2", page="1", handle="pagination_test_2", order="id")>
		<cfset assert('request.wheels.pagination_test_2.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_test_2.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_2.TOTALRECORDS eq 5')>
		<cfset assert('request.wheels.pagination_test_2.ENDROW eq 2')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('loc.e.id[1] eq loc.r.id[1]')>
		<cfset assert('loc.e.id[2] eq loc.r.id[2]')>

		<!--- 2nd page --->
		<cfset loc.e = loc.user.findAll(perpage="2", page="2", handle="pagination_test_3", order="id")>
		<cfset assert('request.wheels.pagination_test_3.CURRENTPAGE eq 2')>
		<cfset assert('request.wheels.pagination_test_3.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_3.TOTALRECORDS eq 5')>
		<cfset assert('request.wheels.pagination_test_3.ENDROW eq 4')>
		<cfset assert("loc.e.recordcount eq 2")>
		<cfset assert('loc.e.id[1] eq loc.r.id[3]')>
		<cfset assert('loc.e.id[2] eq loc.r.id[4]')>

		<!--- 3rd page --->
		<cfset loc.e = loc.user.findAll(perpage="2", page="3", handle="pagination_test_4", order="id")>
		<cfset assert('request.wheels.pagination_test_4.CURRENTPAGE eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALPAGES eq 3')>
		<cfset assert('request.wheels.pagination_test_4.TOTALRECORDS eq 5')>
		<cfset assert('request.wheels.pagination_test_4.ENDROW eq 5')>
		<cfset assert("loc.e.recordcount eq 1")>
		<cfset assert('loc.e.id[1] eq loc.r.id[5]')>
	</cffunction>

	<cffunction name="test_specify_where_on_joined_table">
		<cfset loc.q = loc.gallery.findOne(
			include="user"
			,where="users.lastname = 'Petruzzi'"
			,orderby="id"
		)>

		<!--- 10 records, 2 perpage, 5 pages --->
		<cfset loc.args = {
				perpage="2"
				,page="1"
				,handle="pagination_test"
				,order="id"
				,include="gallery"
				,where="galleryid = #loc.q.id#"
		}>

		<cfset loc.args2 = duplicate(loc.args)>
		<cfset structdelete(loc.args2, "perpage", false)>
		<cfset structdelete(loc.args2, "page", false)>
		<cfset structdelete(loc.args2, "handle", false)>
		<cfset loc.r = loc.photo.findAll(argumentCollection=loc.args2)>

		<!--- page 1 --->
		<cfset loc.e = loc.photo.findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.galleryid[1] eq loc.r.galleryid[1]')>
		<cfset assert('loc.e.galleryid[2] eq loc.r.galleryid[2]')>

		<!--- page 3 --->
		<cfset loc.args.page = "3">
		<cfset loc.e = loc.photo.findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.galleryid[1] eq loc.r.galleryid[5]')>
		<cfset assert('loc.e.galleryid[2] eq loc.r.galleryid[6]')>

		<!--- page 5 --->
		<cfset loc.args.page = "5">
		<cfset loc.e = loc.photo.findAll(argumentCollection=loc.args)>
		<cfset assert('loc.e.galleryid[1] eq loc.r.galleryid[9]')>
		<cfset assert('loc.e.galleryid[2] eq loc.r.galleryid[10]')>
	</cffunction>

	<cffunction name="test_make_sure_that_remapped_columns_containing_desc_and_asc_work">
		<cfset loc.result = model("photo").findAll(page=1, perPage=20, order='DESCription1 DESC', handle="pagination_order_test_1")>
		<cfset assert('request.wheels.pagination_order_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALPAGES eq 13')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALRECORDS eq 250')>
		<cfset assert('request.wheels.pagination_order_test_1.ENDROW eq 20')>
	</cffunction>

	<cffunction name="test_with_renamed_primary_key">
		<cfset loc.photo = model("photo2").findAll(
				page=1
				,perpage=3
				,where="DESCRIPTION1 LIKE '%test%'"
		)>
		<cfset assert('loc.photo.recordcount eq 3')>
	</cffunction>
	
	<cffunction name="test_with_parameterize_set_to_false_with_string">
		<cfset loc.result = model("photo").findAll(page=1, perPage=20, handle="pagination_order_test_1", parameterize="false", where="description1 LIKE '%photo%'")>
		<cfset assert('request.wheels.pagination_order_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALPAGES eq 13')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALRECORDS eq 250')>
		<cfset assert('request.wheels.pagination_order_test_1.ENDROW eq 20')>
	</cffunction>
	
	<cffunction name="test_with_parameterize_set_to_false_with_numeric">
		<cfset loc.result = model("photo").findAll(page=1, perPage=20, handle="pagination_order_test_1", parameterize="false", where="id = 1")>
		<cfset assert('request.wheels.pagination_order_test_1.CURRENTPAGE eq 1')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALPAGES eq 1')>
		<cfset assert('request.wheels.pagination_order_test_1.TOTALRECORDS eq 1')>
		<cfset assert('request.wheels.pagination_order_test_1.ENDROW eq 1')>
	</cffunction>

	<cffunction name="test_compound_keys">
		<cfset loc.result = model("combikey").findAll(page=2, perPage=4, order="id2")>
		<cfset assert('loc.result.recordCount eq 4')>
	</cffunction>
	
	<cffunction name="test_incorrect_number_of_record_returned_when_where_clause_satisfies_records_beyond_the_first_identifier_value">
		<cfset loc.q = model("author").findAll(
			include="posts"
			,where="posts.views > 2"
			,page=1
			,perpage=5
		)>
		<cfset assert('loc.q.recordcount eq 3')>
	</cffunction>
	
	<cffunction name="test_pagination_with_blank_where_specified_does_not_cause_crash">
		<cfset loc.q = model("Post").findAll(where="", page=1)>
		<cfset assert('IsQuery(loc.q)')>		
	</cffunction>

</cfcomponent>