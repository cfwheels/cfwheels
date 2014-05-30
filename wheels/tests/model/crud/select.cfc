<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_table_name_with_star_translates_to_all_fields">
		<cfset loc.model = model("post") />
		<cfset loc.r = loc.model.$createSQLFieldList(list="posts.*", include="", returnAs="query") />
		<cfset loc.properties = loc.model.$classData().properties />
		<cfset assert('ListLen(loc.r) eq StructCount(loc.properties)') />
	</cffunction>

	<cffunction name="test_wrong_table_alias_in_select_throws_error">
		<cfset loc.model = model("post") />
		<cfset raised('loc.model.$createSQLFieldList(list="comments.*", include="", returnAs="query")') />
	</cffunction>

	<cffunction name="test_association_with_expanded_aliases_enabled">
		<cfset loc.columnList = ListSort(model("Author").$createSQLFieldList(list="", include="Posts", returnAs="query", useExpandedColumnAliases=true), "text")>
		<cfset assert('loc.columnList eq "authors.favouritePostId,authors.firstname,authors.id,authors.lastname,authors.leastFavouritePostId,posts.authorid AS postauthorid,posts.averagerating AS postaveragerating,posts.body AS postbody,posts.createdat AS postcreatedat,posts.deletedat AS postdeletedat,posts.id AS postid,posts.title AS posttitle,posts.updatedat AS postupdatedat,posts.views AS postviews"')>
	</cffunction>

	<cffunction name="test_association_with_expanded_aliases_disabled">
		<cfset loc.columnList = ListSort(model("Author").$createSQLFieldList(list="", include="Posts", returnAs="query", useExpandedColumnAliases=false), "text")>
		<cfset assert('loc.columnList eq "authors.favouritePostId,authors.firstname,authors.id,authors.lastname,authors.leastFavouritePostId,posts.authorid,posts.averagerating,posts.body,posts.createdat,posts.deletedat,posts.id AS postid,posts.title,posts.updatedat,posts.views"')>
	</cffunction>

	<cffunction name="test_passing_start_without_table_name">
		<cfset q = model("author").findAll(select="*", include="posts", order="id")>
		<cfset loc.e = 10>
		<cfset loc.r = q.recordcount>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>


</cfcomponent>