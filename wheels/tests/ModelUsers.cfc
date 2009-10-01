<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset table("users")>
		<cfset datasource(datasource="wheelstestdb", username="wheelstestdb", password="wheelstestdb")>
	</cffunction>

</cfcomponent>