<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_maximum">
		<cfset loc.result = model("post").maximum(property="views")>
		<cfset assert("loc.result IS 5")>
	</cffunction>

	<cffunction name="test_maximum_with_where">
		<cfset loc.result = model("post").maximum(property="views", where="title LIKE 'Title%'")>
		<cfset assert("loc.result IS 5")>
	</cffunction>

	<cffunction name="test_maximum_with_non_matching_where">
		<cfset loc.result = model("post").maximum(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>
	
	<cffunction name="test_maximum_with_ifNull">
		<cfset loc.result = model("post").maximum(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_maximum_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").deleteAll(where="views=5", transaction="none")>
			<cfset loc.maximum = model("Post").maximum(property="views", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.maximum eq 5')>
	</cffunction>	

</cfcomponent>