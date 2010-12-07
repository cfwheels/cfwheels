<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_tablename_and_tablenameprefix">
		<cfset loc.user = model("user2")>
		<cfset assert('loc.user.tableName() eq "tblusers"')>
	</cffunction>

	<cffunction name="test_tablename_and_tablenameprefix_in_finders_fixes_issue_667">
		<cfset loc.users = model("user2").findAll()>
		<cfset assert('loc.users.recordcount eq 0')>
	</cffunction>

</cfcomponent>