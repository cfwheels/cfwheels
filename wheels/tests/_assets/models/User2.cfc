<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset settablenameprefix("tbl")>
		<cfset table("users")>
		<cfset property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)")>
		<cfset property(name="groupCount", sql="COUNT(tblusers.id)")>
	</cffunction>

</cfcomponent>