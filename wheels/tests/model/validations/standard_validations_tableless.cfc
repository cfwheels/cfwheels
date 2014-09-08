<cfcomponent extends="standard_validations">

 	<cffunction name="setup">
		<cfset oldDataSourceName = application.wheels.dataSourceName>
		<cfset application.wheels.dataSourceName = "">
		<cfset StructDelete(application.wheels.models, "UserTableless", false)>
		<cfset loc.user = model("UserTableless").new()>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.dataSourceName = oldDataSourceName>
	</cffunction>

</cfcomponent>