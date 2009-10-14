<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset hasMany(name="photogalleries", class="photogalleries", foreignKey="userid")>
	</cffunction>

</cfcomponent>