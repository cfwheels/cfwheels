<cfcomponent extends="standard_validations">

	<!--- validatesuniquenessof is not supported --->	
	<cfset StructDelete(this, "test_validatesUniquenessOf_valid")>
	<cfset StructDelete(this, "test_validatesUniquenessOf_valids_when_updating_existing_record")>
	<cfset StructDelete(this, "test_validatesUniquenessOf_takes_softdeletes_into_account")>

 	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "UserTableless", false)>
		<cfset loc.user = model("UserTableless").new()>
	</cffunction>
	
	<!--- validate --->
	<cffunction name="test_validate_registering_methods">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validate(method="fakemethod")>
		<cfset loc.v = loc.user.$classData().validations>
		<cfset loc.onsave = loc.v["onsave"]>
		<cfset assert('arraylen(loc.onsave) eq 1')>
		<cfset assert('loc.onsave[1].method eq "fakemethod"')>
	</cffunction>

</cfcomponent>