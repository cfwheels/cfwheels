<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo(name="user")>
		<cfset belongsTo(name="friend", foreignKey="associateuserid")>
	</cffunction>

</cfcomponent>
