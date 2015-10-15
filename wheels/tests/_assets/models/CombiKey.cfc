<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("User")>
    <cfset validatesUniquenessOf(property="id1", scope="id2")>
	</cffunction>

</cfcomponent>