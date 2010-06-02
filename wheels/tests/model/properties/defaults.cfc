<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_new_model_has_defaults">
		<cfset loc.author = model("author").new(defaults=true)>
		<cfset assert('StructKeyExists(loc.author, "firstName") and loc.author.firstName eq "Dave"')>
	</cffunction>

	<cffunction name="test_new_model_does_not_have_defaults">
		<cfset loc.author = model("author").new(defaults=false)>
		<cfset assert('!StructKeyExists(loc.author, "firstName")')>
	</cffunction>

</cfcomponent>