<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset settablenameprefix("tbl")>
		<cfset table("users")>
		<!--- uncomment for testing "test_group_by_calculated_property" --->
		<!--- <cfset property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)")>
		<cfset property(name="groupCount", sql="COUNT(tblusers.id)")> --->
	</cffunction>

</cfcomponent>