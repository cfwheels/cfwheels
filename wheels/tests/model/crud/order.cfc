<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_order_clause_no_sort">
		<cfset loc.result = model("author").findOne(order="lastName")>
		<cfset assert("loc.result.lastName IS 'Amiri'")>
	</cffunction>

	<cffunction name="test_order_clause_asc_sort">
		<cfset loc.result = model("author").findOne(order="lastName ASC")>
		<cfset assert("loc.result.lastName IS 'Amiri'")>
	</cffunction>

	<cffunction name="test_order_clause_desc_sort">
		<cfset loc.result = model("author").findOne(order="lastName DESC")>
		<cfset assert("loc.result.lastName IS 'Riera'")>
	</cffunction>

	<cffunction name="test_order_clause_with_include">
		<cfset loc.result = model("post").findAll(include="comments", order="createdAt DESC,id DESC,name")>
		<cfset assert("loc.result['title'][1] IS 'Title for fourth test post'")>
	</cffunction>

	<cffunction name="test_order_clause_with_include_and_identical_columns">
		<cfset loc.result = model("post").findAll(include="comments", order="createdAt,createdAt")>
		<cfset assert("loc.result['title'][1] IS 'Title for first test post'")>
	</cffunction>

	<cffunction name="test_order_clause_with_paginated_include_and_identical_columns">
		<cfset loc.result = model("post").findAll(page=1, perPage=3, include="comments", order="createdAt,createdAt")>
		<cfset assert("loc.result['title'][1] IS 'Title for first test post'")>
	</cffunction>

	<cffunction name="test_order_clause_with_paginated_include_and_identical_columns_desc_sort_with_specified_table_names">
		<cfset loc.result = model("post").findAll(page=1, perPage=3, include="comments", order="posts.createdAt DESC,posts.id DESC,comments.createdAt")>
		<cfset assert("loc.result['title'][1] IS 'Title for fourth test post'")>
	</cffunction>

</cfcomponent>