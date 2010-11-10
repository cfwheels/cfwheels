<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("User")>
	</cffunction>

</cfcomponent>