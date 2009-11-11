<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_count">
		<cfset loc.result = model("author").count()>
		<cfset assert("loc.result IS 6")>
	</cffunction>

	<cffunction name="test_count_with_include">
		<cfset loc.result = model("author").count(include="posts")>
		<cfset assert("loc.result IS 6")>
	</cffunction>

	<cffunction name="test_count_with_where">
		<cfset loc.result = model("author").count(where="lastName = 'Djurner'")>
		<cfset assert("loc.result IS 1")>
	</cffunction>

	<cffunction name="test_count_with_non_matching_where">
		<cfset loc.result = model("author").count(where="id=0")>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_count_with_non_matching_where_and_include">
		<cfset loc.result = model("author").count(where="id = 0", include="posts")>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_count_with_where_and_include">
		<cfset loc.result = model("author").count(where="lastName = 'Djurner' OR lastName = 'Peters'", include="posts")>
		<cfset assert("loc.result IS 2")>
	</cffunction>

	<cffunction name="test_count_with_where_on_included_association">
		<cfset loc.result = model("author").count(where="title LIKE '%first%' OR title LIKE '%second%' OR title LIKE '%fourth%'", include="posts")>
		<cfset assert("loc.result IS 2")>
	</cffunction>
	
	<cffunction name="test_dynamic_count">
		<cfset loc.author = model("author").findOne(where="lastName='Djurner'")>
		<cfset loc.result = loc.author.postCount()>
		<cfset assert("loc.result IS 3")>
	</cffunction>

	<cffunction name="test_dynamic_count_with_where">
		<cfset loc.author = model("author").findOne(where="lastName='Djurner'")>
		<cfset loc.result = loc.author.postCount(where="title LIKE '%first%' OR title LIKE '%second%'")>
		<cfset assert("loc.result IS 2")>
	</cffunction>
	
</cfcomponent>