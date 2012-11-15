<cfcomponent extends="standard_validations">

	<!--- validatesuniquenessof is not supported --->	
	<cfset StructDelete(this, "test_validatesUniquenessOf_valid")>
	<cfset StructDelete(this, "test_validatesUniquenessOf_valids_when_updating_existing_record")>
	<cfset StructDelete(this, "test_validatesUniquenessOf_takes_softdeletes_into_account")>
	
	<cfset StructDelete(variables, "test_validatesUniquenessOf_valid")>
	<cfset StructDelete(variables, "test_validatesUniquenessOf_valids_when_updating_existing_record")>
	<cfset StructDelete(variables, "test_validatesUniquenessOf_takes_softdeletes_into_account")>

 	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "UserTableless", false)>
		<cfset loc.user = model("UserTableless").new()>
	</cffunction>

</cfcomponent>