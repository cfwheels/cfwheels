<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset belongsTo(name="gallery", modelName="gallery", foreignKey="id")>
	</cffunction>

</cfcomponent>