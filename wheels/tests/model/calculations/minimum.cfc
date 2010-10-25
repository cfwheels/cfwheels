<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_minimum">
		<cfset loc.result = model("post").minimum(property="views")>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_minimum_with_non_matching_where">
		<cfset loc.result = model("post").minimum(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_minimum_with_ifNull">
		<cfset loc.result = model("post").minimum(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_minimum_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").deleteAll(where="views=0", transaction="none")>
			<cfset loc.minimum = model("Post").minimum(property="views", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.minimum eq 0')>
	</cffunction>

</cfcomponent>