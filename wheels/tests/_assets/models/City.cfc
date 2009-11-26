<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset hasMany(name="shops", foreignKey="citycode")>
	</cffunction>

</cfcomponent>