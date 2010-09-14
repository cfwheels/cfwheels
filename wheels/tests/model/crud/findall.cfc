<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.source = model("user").findAll(select="id,lastName", maxRows=3, order="id")>
	</cffunction>

	<cffunction name="test_in_operator_with_quoted_strings">
		<cfset loc.values = QuotedValueList(loc.source.lastName)>
		<cfset loc.q = model("user").findAll(where="lastName IN (#loc.values#)", order="id")>
		<cfset assert('loc.q.recordCount IS 3')>
	</cffunction>

	<cffunction name="test_in_operator_with_numbers">
		<cfset loc.values = ValueList(loc.source.id)>
		<cfset loc.q = model("user").findAll(where="id IN (#loc.values#)", order="id")>
		<cfset assert('loc.q.recordCount IS 3')>
	</cffunction>

</cfcomponent>