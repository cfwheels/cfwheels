<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset settablenameprefix("tbl")>
		<cfset table("users")>
 		<cfif application.wheels.dataAdapter eq "Oracle">
			<cfset property(name="firstLetter", sql="SUBSTR(tblusers.username, 1, 1)")>
		<cfelse>
			<cfset property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)")>
		</cfif>
		<cfset property(name="groupCount", sql="COUNT(tblusers.id)")>
	</cffunction>

</cfcomponent>
