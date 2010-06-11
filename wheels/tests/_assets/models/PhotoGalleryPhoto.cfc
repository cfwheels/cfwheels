<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset belongsTo(name="photogallery", modelName="photogallery", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>