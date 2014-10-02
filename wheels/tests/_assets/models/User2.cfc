<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset settablenameprefix("tbl")>
		<cfset table("users")>
		<cfdbinfo name="loc.dbinfo" datasource="#application.wheels.dataSourceName#" type="version">
		<cfset loc.db = LCase(Replace(loc.dbinfo.database_productname, " ", "", "all"))>
		<cfif loc.db IS "oracle">
			<cfset property(name="firstLetter", sql="SUBSTR(tblusers.username, 1, 1)")>
		<cfelse>
			<cfset property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)")>
		</cfif>
		<cfset property(name="groupCount", sql="COUNT(tblusers.id)")>
	</cffunction>

</cfcomponent>