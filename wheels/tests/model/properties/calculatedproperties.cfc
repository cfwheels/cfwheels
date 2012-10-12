<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_return_calculated_properties_with_specified">
		<!--- with table name appended --->
		<cfset loc.users = model("user").findAll(select="fullname,users.firstname,users.lastname")>
		<cfset loc.a = ListSort(loc.users.ColumnList, "textnocase")>
		<cfset loc.r = loc.users.RecordCount>
		<cfset assert('loc.r eq 5 AND loc.a eq "firstname,fullname,lastname"')>
		<!--- with only columns --->
		<cfset loc.users = model("user").findAll(select="fullname,firstname,lastname")>
		<cfset loc.a = ListSort(loc.users.ColumnList, "textnocase")>
		<cfset loc.r = loc.users.RecordCount>
		<cfset assert('loc.r eq 5 AND loc.a eq "firstname,fullname,lastname"')>
		<!--- with include and as --->
		<cfset loc.users = model("user").findAll(select="fullname,users.firstname,users.lastname,authors.firstname AS afirstname", include="author")>
		<cfset loc.a = ListSort(loc.users.ColumnList, "textnocase")>
		<cfset loc.r = loc.users.RecordCount>
		<cfset assert('loc.r eq 5 AND loc.a eq "afirstname,firstname,fullname,lastname"')>
	</cffunction>

</cfcomponent>