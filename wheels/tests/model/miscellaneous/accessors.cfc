<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_getdatasource">
		<cfset loc.user = model("user").new()>
		<cfset loc.e = loc.user.getDataSource()>
		<cfset assert('IsStruct(loc.e)')>
		<cfset assert('loc.e.datasource eq application.wheels.dataSourceName')>
	</cffunction>

</cfcomponent>