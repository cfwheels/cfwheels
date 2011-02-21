<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany(name="shops", foreignKey="citycode")>
		<cfset property(name="id", column="countyid")>
	</cffunction>

</cfcomponent>