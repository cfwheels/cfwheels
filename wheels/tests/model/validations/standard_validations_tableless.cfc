<cfcomponent extends="standard_validations">

 	<cffunction name="setup">
 		<!--- pre-load models that will be called during test --->
 		<cfset model('users')>
 		<cfset model('post')>
		<cfset oldDataSourceName = application.wheels.dataSourceName>
		<cfset application.wheels.dataSourceName = "">
		<cfset StructDelete(application.wheels.models, "UserTableless", false)>
		<cfset loc.user = model("UserTableless").new()>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.dataSourceName = oldDataSourceName>
	</cffunction>

</cfcomponent>