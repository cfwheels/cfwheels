<cfcomponent extends="wheels.tests.Test">

	<cffunction name="test_columns_returns_array">
		<cfset loc.columns = model("author").columns() />
		<cfset assert('IsArray(loc.columns) eq true') />
	</cffunction>

</cfcomponent>