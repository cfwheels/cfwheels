<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("post")>

		<cfset beforeCreate("oracleAutoInc")>
	</cffunction>

</cfcomponent>