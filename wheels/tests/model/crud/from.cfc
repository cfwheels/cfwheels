<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_from_clause">
		<cfset loc.result = model("author").$fromClause(include="")>
		<cfset assert("loc.result IS 'FROM authors'")>
	</cffunction>

	<cffunction name="test_from_clause_with_mapped_table">
		<cfset model("author").table("tbl_authors")>
		<cfset loc.result = model("author").$fromClause(include="")>
		<cfset model("author").table("authors")>
		<cfset assert("loc.result IS 'FROM tbl_authors'")>
	</cffunction>
<!---
	<cffunction name="test_from_clause_with_include">
		<cfset loc.result = model("author").$fromClause(include="posts")>
		<cfset assert("loc.result IS 'FROM authors LEFT OUTER JOIN posts ON authors.id = posts.authorid'")>
	</cffunction>--->

<!---test:
inner/outer join
composite keys joining
mapped pkeys--->

</cfcomponent>