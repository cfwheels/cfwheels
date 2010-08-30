<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_new_model_with_property_defaults">
		<cfset loc.author = model("Author").new()>
		<cfset assert('StructKeyExists(loc.author, "firstName") and loc.author.firstName eq "Dave"')>
	</cffunction>

	<cffunction name="test_new_model_with_property_defaults_set_to_blank">
		<cfset loc.author = model("Author").new()>
		<cfset assert('StructKeyExists(loc.author, "lastName") and loc.author.lastName eq ""')>
	</cffunction>

</cfcomponent>