<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset belongsTo(name="photogalleries", class="photogalleries", foreignKey="photogalleryid")>
	</cffunction>

</cfcomponent>