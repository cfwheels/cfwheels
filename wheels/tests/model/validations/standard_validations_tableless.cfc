<cfcomponent extends="standard_validations">

 	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "UserTableless", false)>
		<cfset loc.user = model("UserTableless").new()>
	</cffunction>

</cfcomponent>