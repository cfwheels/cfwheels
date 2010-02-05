<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="photogallery", modelName="photogallery", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>