<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_simple_group_by">
		<cfset loc.r = model("tag").findAll(select="parentId, COUNT(*) AS groupCount", group="parentId")>
		<cfset assert('loc.r.recordcount eq 4')>
	</cffunction>

	<cffunction name="test_group_by_calculated_property">
		<cfset loc.r = model("user2").findAll(select="firstLetter, groupCount", group="firstLetter", order="groupCount DESC")>
		<cfset assert('loc.r.recordcount eq 2')>
	</cffunction>

	<cffunction name="test_distinct_works_with_group_by">
		<cfset loc.r = model("post").findAll(select="views", distinct=true)>
		<cfset assert('loc.r.recordcount eq 4')>
		<cfset loc.r = model("post").findAll(select="views", group="views")>
		<cfset assert('loc.r.recordcount eq 4')>
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