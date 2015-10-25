<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("User")>
    <cfset validatesPresenceOf("id1,id2")>
    <cfset validatesUniquenessOf(property="id1", scope="id2")>
	</cffunction>

</cfcomponent>