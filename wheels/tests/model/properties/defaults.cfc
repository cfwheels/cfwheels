<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_new_model_with_property_defaults">
		<cfset loc.author = model("Author").new()>
		<cfset assert('StructKeyExists(loc.author, "firstName") and loc.author.firstName eq "Dave"')>
	</cffunction>

	<cffunction name="test_new_model_with_property_defaults_set_to_blank">
		<cfset loc.author = model("Author").new()>
		<cfset assert('StructKeyExists(loc.author, "lastName") and loc.author.lastName eq ""')>
	</cffunction>

	<cffunction name="test_database_defaults_load_after_create">
		<cftransaction action="begin">
			<cfset loc.user = model("UserBlank").create(username="The Dude", password="doodle", firstName="The", lastName="Dude", reload=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('StructKeyExists(loc.user, "birthTime") and TimeFormat(loc.user.birthTime, "HH:mm:ss") eq "18:26:08"')>
	</cffunction>

	<cffunction name="test_database_defaults_load_after_save">
		<cftransaction action="begin">
			<cfset loc.user = model("UserBlank").new(username="The Dude", password="doodle", firstName="The", lastName="Dude")>
			<cfset loc.user.save(reload=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('StructKeyExists(loc.user, "birthTime") and TimeFormat(loc.user.birthTime, "HH:mm:ss") eq "18:26:08"')>
	</cffunction>

</cfcomponent>