<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_table_name_with_star_translates_to_all_fields">
		<cfset loc.model = model("post") />
		<cfset loc.r = loc.model.$createSQLFieldList(clause="select", list="posts.*", include="", returnAs="query") />
		<cfset loc.properties = loc.model.$classData().properties />
		<cfset assert('ListLen(loc.r) eq StructCount(loc.properties)') />
	</cffunction>

	<cffunction name="test_wrong_table_alias_in_select_throws_error">
		<cfset loc.model = model("post") />
		<cfset raised('loc.model.$createSQLFieldList(list="comments.*", include="", returnAs="query")') />
	</cffunction>

	<cffunction name="test_association_with_expanded_aliases_enabled">
		<cfset loc.columnList = ListSort(model("Author").$createSQLFieldList(clause="select", list="", include="Posts", returnAs="query", useExpandedColumnAliases=true), "text")>
		<cfset assert('loc.columnList eq "authors.firstname,authors.id,authors.lastname,posts.authorid AS postauthorid,posts.averagerating AS postaveragerating,posts.body AS postbody,posts.createdat AS postcreatedat,posts.deletedat AS postdeletedat,posts.id AS postid,posts.title AS posttitle,posts.updatedat AS postupdatedat,posts.views AS postviews"')>
	</cffunction>

	<cffunction name="test_association_with_expanded_aliases_disabled">
		<cfset loc.columnList = ListSort(model("Author").$createSQLFieldList(clause="select", list="", include="Posts", returnAs="query", useExpandedColumnAliases=false), "text")>
		<cfset assert('loc.columnList eq "authors.firstname,authors.id,authors.lastname,posts.authorid,posts.averagerating,posts.body,posts.createdat,posts.deletedat,posts.id AS postid,posts.title,posts.updatedat,posts.views"')>
	</cffunction>

	<cffunction name="test_select_common_columns_using_aliased_model">
		<cfset loc.columnList = ListSort(model("User").$createSQLFieldList(clause="select", list="id, firstname, lastname, friendid, friendfirstname, friendlastname", include="Associates(Friend)", returnAs="query", useExpandedColumnAliases=true), "text")>
		<cfset assert('loc.columnList eq "users.firstname,users.id,users.lastname,users.firstname AS friendfirstname,users.id AS friendid,users.lastname AS friendlastname"')>
	</cffunction>

</cfcomponent>
