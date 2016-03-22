<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.source = model("user").findAll(select="id,lastName", maxRows=3)>
	</cffunction>

	<cffunction name="test_maxrows_change_should_break_cache">
		<cfset $cacheQueries = application.wheels.cacheQueries>
		<cfset application.wheels.cacheQueries = true>
		<cfset loc.q = model("user").findAll(maxrows=1, cache=10)>
		<cfset assert('loc.q.recordCount IS 1')>
		<cfset loc.q = model("user").findAll(maxrows=2, cache=10)>
		<cfset assert('loc.q.recordCount IS 2')>
		<cfset application.wheels.cacheQueries = $cacheQueries>
	</cffunction>

	<cffunction name="test_in_operator_with_quoted_strings">
		<cfset loc.values = QuotedValueList(loc.source.lastName)>
		<cfset loc.q = model("user").findAll(where="lastName IN (#loc.values#)")>
		<cfset assert('loc.q.recordCount IS 3')>
	</cffunction>

	<cffunction name="test_in_operator_with_numbers">
		<cfset loc.values = ValueList(loc.source.id)>
		<cfset loc.q = model("user").findAll(where="id IN (#loc.values#)")>
		<cfset assert('loc.q.recordCount IS 3')>
	</cffunction>

	<cffunction name="test_custom_query_and_orm_query_in_transaction">
		<cftransaction>
			<cfquery name="loc.resultOne" datasource="#application.wheels.dataSourceName#">
			SELECT id FROM users
			</cfquery>
			<cfset loc.resultTwo = model("user").findAll(select="id")>
		</cftransaction>
		<cfset assert("loc.resultOne.recordCount IS loc.resultTwo.recordCount")>
	</cffunction>

	<cffunction name="test_in_operator_with_spaces">
		<cfscript>
			authors = model("author").findAll(where="id != 0 AND id IN (1, 2, 3) AND firstName IN('Per', 'Tony') AND lastName IN ('Djurner', 'Petruzzi')");
			assert("authors.recordCount IS 2");
		</cfscript>
	</cffunction>

</cfcomponent>