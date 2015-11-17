<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table(name="users")>
		<cfset hasMany(name="associates", foreignKey="associateuserid")>
	</cffunction>

</cfcomponent>
