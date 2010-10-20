<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo(name="user", modelName="user", foreignKey="userid")>
		<cfset hasMany(name="photos", modelName="photo", foreignKey="galleryid")>
		<cfset nestedProperties(associations="photos", allowDelete="true")>
	</cffunction>

</cfcomponent>