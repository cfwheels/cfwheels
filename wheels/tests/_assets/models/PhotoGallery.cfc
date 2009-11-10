<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="user", class="user", foreignKey="userid")>
		<cfset hasMany(name="photogalleryphotos", class="photogalleryphoto", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>