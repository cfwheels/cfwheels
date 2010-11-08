<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("author")>
	</cffunction>

</cfcomponent>