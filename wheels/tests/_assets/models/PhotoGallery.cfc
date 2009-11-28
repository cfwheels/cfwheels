<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="user", modelName="user", foreignKey="userid")>
		<cfset hasMany(name="photogalleryphotos", modelName="photogalleryphoto", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>