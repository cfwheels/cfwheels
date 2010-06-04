<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_new_model_has_defaults">
		<cfset loc.author = model("author").new(defaults=true)>
		<cfset assert('StructKeyExists(loc.author, "firstName") and loc.author.firstName eq "Dave"')>
	</cffunction>

	<cffunction name="test_new_model_does_not_have_defaults">
		<cfset loc.author = model("author").new(defaults=false)>
		<cfset assert('!StructKeyExists(loc.author, "firstName")')>
	</cffunction>

	<cffunction name="test_created_model_has_database_defaults">
		<cftransaction action="begin">
			<cfset loc.user = model("UserBlank").create(username="The Dude", password="doodle", firstName="The", lastName="Dude", defaults=false)>
			<cftransaction action="rollback">
		</cftransaction>
		<cfset assert('StructKeyExists(loc.user, "birthTime") and TimeFormat(loc.user.birthTime, "HH:mm ss") eq "18:26 08"')>
	</cffunction>

</cfcomponent>