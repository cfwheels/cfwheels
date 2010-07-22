<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset belongsTo(name="city", foreignKey="citycode")>
	</cffunction>

</cfcomponent>