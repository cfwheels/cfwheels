<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="users", class="users", foreignKey="userid")>
		<cfset hasMany(name="photogalleryphotos", class="photogalleryphotos", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>