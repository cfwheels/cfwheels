<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_return_calculated_properties_with_specified">
		<!--- with table name appended --->
		<cfset loc.users = model("user").findAll(select="fullname,users.firstname,users.lastname")>
		<cfset assert('loc.users.RecordCount eq 5')>
		<!--- with only columns --->
		<cfset loc.users = model("user").findAll(select="fullname,firstname,lastname")>
		<cfset assert('loc.users.RecordCount eq 5')>
		<!--- with include and as --->
		<cfset loc.users = model("user").findAll(select="fullname,users.firstname,users.lastname,authors.firstname AS afirstname", include="author")>
		<cfset assert('loc.users.RecordCount eq 5')>
	</cffunction>

</cfcomponent>