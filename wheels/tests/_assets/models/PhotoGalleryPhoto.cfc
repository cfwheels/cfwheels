<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="photogallery", class="photogallery", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>