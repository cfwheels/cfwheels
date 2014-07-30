<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_table_name_with_star_translates_to_all_fields">
		<cfset loc.model = model("post") />
		<cfset loc.r = loc.model.$createSQLFieldList(list="posts.*", include="", returnAs="query") />
		<cfset loc.properties = loc.model.$getModelClassData().properties />
		<cfset $assert('ListLen(loc.r) eq StructCount(loc.properties)') />
	</cffunction>

	<cffunction name="test_wrong_table_alias_in_select_throws_error">
		<cfset loc.model = model("post") />
		<cfset raised('loc.model.$createSQLFieldList(list="comments.*", include="", returnAs="query")') />
	</cffunction>

	<cffunction name="test_with_association">
		<cfset loc.columnList = ListSort(model("Author").$createSQLFieldList(list="", include="Posts", returnAs="query"), "text")>
		<cfset $assert('loc.columnList eq "authors.firstname,authors.id,authors.lastname,posts.authorid,posts.averagerating,posts.body,posts.createdat,posts.deletedat,posts.id AS postid,posts.title,posts.updatedat,posts.views"')>
	</cffunction>

</cfcomponent>