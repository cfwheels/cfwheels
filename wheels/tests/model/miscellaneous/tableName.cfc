<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_tablename_and_tablenameprefix">
		<cfset loc.user = createobject("component", "wheelsMapping.model")>
		<cfset loc.user.setTableNamePrefix("tbl")>
		<cfset loc.user.table("user")>
		<cfset assert('loc.user.tableName() eq "tbluser"')>
	</cffunction>

</cfcomponent>