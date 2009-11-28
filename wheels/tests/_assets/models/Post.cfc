<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset belongsTo("author")>
	</cffunction>

</cfcomponent>