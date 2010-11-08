<cfcomponent extends="wheelsMapping.Test">
 
 	<cffunction name="test_updateProperty">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne(where="firstName='Andy'")>
			<cfset loc.saved = loc.author.updateProperty("firstName", "Frog")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.saved eq true and loc.author.firstName eq "Frog"')>
	</cffunction>
 
 	<cffunction name="test_updateProperty_dynamic_method">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne(where="firstName='Andy'")>
			<cfset loc.saved = loc.author.updateFirstName(value="Frog")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.saved eq true and loc.author.firstName eq "Frog"')>
	</cffunction>
 
 	<cffunction name="test_updateProperties">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne(where="firstName='Andy'")>
			<cfset loc.saved = loc.author.updateProperties(firstName="Kirmit", lastName="Frog")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.saved eq true and loc.author.lastName eq "Frog" and loc.author.firstName eq "Kirmit"')>
	</cffunction>

</cfcomponent>