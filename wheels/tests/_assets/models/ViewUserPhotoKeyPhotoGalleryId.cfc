<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset table("userphotos")>
		<cfset setPrimaryKey("photogalleryid")>
		<cfset hasMany(
				name="photogalleryphotos"
				,modelName="photogalleryphoto"
				,foreignKey="photogalleryid"
			)>
	</cffunction>

</cfcomponent>