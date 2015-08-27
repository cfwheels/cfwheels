<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_findOneOrCreateBy">
		<cftransaction>
			<cfset loc.author = model("author").findOrCreateByFirstName(firstName="Per", lastName="Djurner")>
			<cfset assert('IsObject(loc.author)')>
			<cfset assert('loc.author.lastname eq "Djurner"')>
			<cfset assert('loc.author.firstname eq "Per"')>
			<cftransaction action="rollback">
		</cftransaction>
	</cffunction>

</cfcomponent>