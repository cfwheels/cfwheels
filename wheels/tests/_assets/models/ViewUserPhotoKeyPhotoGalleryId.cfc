<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("userphotos")>
		<cfset setPrimaryKey("galleryid")>
		<cfset hasMany(
				name="photos"
				,modelName="photo"
				,foreignKey="galleryid"
			)>
	</cffunction>

</cfcomponent>