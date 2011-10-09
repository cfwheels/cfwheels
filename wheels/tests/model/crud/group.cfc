<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_distinct_works_with_group_by">
		<cfset loc.r = model("post").findAll(select="views", distinct=true)>
		<cfset assert('loc.r.recordcount eq 4')>
		<cfset loc.r = model("post").findAll(select="views", group="views")>
		<cfset assert('loc.r.recordcount eq 4')>
	</cffunction>

	<cffunction name="test_wrong_table_alias_in_group_by_throws_error">
		<cfset loc.model = model("post") />
		<cfset raised('loc.model.$createSQLFieldList(list="posts.*", include="", renameFields=false, addCalculatedProperties=false)') />
	</cffunction>
	
	<cffunction name="test_max_works_with_group_functionality">
		<cfset loc.r = model("post").findAll(select="id, authorid, title, MAX(posts.views) AS maxView", group="id, authorid, title")>
		<cfset assert('loc.r.recordcount eq 5')>
	</cffunction>
	
	<cffunction name="test_group_functionality_works_with_pagination">
		<cfset loc.r = model("post").findAll(select="id, authorid, title, MAX(posts.views) AS maxView", group="id, authorid, title", page=1, perPage=2)>
		<cfset assert('loc.r.recordcount eq 2')>
	</cffunction>

</cfcomponent>