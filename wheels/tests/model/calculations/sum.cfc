<cfcomponent extends="wheelsMapping.test">

	<cfset loadModels("post,author")>

	<cffunction name="test_sum_all">
		<cfset loc.result = loc.post.sum(property="views")>
		<cfset assert("loc.result IS 13")>
	</cffunction>

	<cffunction name="test_sum_all_with_where">
		<cfset loc.author = loc.author.findOne(where="lastName='Djurner'")>
		<cfset loc.result = loc.post.sum(property="views", where="authorid=#loc.author.id#")>
		<cfset assert("loc.result IS 10")>
	</cffunction>

	<cffunction name="test_sum_with_distinct">
		<cfset loc.result = loc.post.sum(property="views", distinct=true)>
		<cfset assert("loc.result IS 8")>
	</cffunction>
	
</cfcomponent>