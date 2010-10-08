<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("author")>

		<cfset beforeCreate("oracleAutoInc")>
	</cffunction>

</cfcomponent>