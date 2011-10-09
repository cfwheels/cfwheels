<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_sum">
		<cfset loc.result = model("post").sum(property="views")>
		<cfset assert("loc.result IS 15")>
	</cffunction>

	<cffunction name="test_sum_with_where">
		<cfset loc.author = model("author").findOne(where="lastName='Djurner'")>
		<cfset loc.result = model("post").sum(property="views", where="authorid=#loc.author.id#")>
		<cfset assert("loc.result IS 10")>
	</cffunction>

	<cffunction name="test_sum_with_non_matching_where">
		<cfset loc.result = model("post").sum(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_sum_with_distinct">
		<cfset loc.result = model("post").sum(property="views", distinct=true)>
		<cfset assert("loc.result IS 10")>
	</cffunction>

	<cffunction name="test_sum_with_ifNull">
		<cfset loc.result = model("post").sum(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_sum_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").deleteAll(transaction="none")>
			<cfset loc.sum = model("Post").sum(property="views", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.sum eq 15')>
	</cffunction>

</cfcomponent>