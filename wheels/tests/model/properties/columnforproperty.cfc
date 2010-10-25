<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_columnForProperty_returns_column_name">
		<cfset loc.model = model("author").new() />
		<cfset assert('loc.model.columnForProperty("firstName") eq "firstname"') />
	</cffunction>

	<cffunction name="test_columnForProperty_returns_false">
		<cfset loc.model = model("author").new() />
		<cfset assert('loc.model.columnForProperty("myFavy") eq false') />
	</cffunction>

	<cffunction name="test_columnForProperty_dynamic_method_call">
		<cfset loc.model = model("author").new() />
		<cfset assert('loc.model.columnForFirstName() eq "firstname"') />
	</cffunction>

</cfcomponent>