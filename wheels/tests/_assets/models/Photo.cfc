<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset belongsTo(name="gallery", modelName="gallery", foreignKey="id")>
		<cfset beforeValidation("beforeValidationCallbackThatSetsProperty,beforeValidationCallbackThatIncreasesVariable")>
	</cffunction>

	<cffunction name="beforeValidationCallbackThatSetsProperty">
		<cfset this.beforeValidationCallbackRegistered = true>
	</cffunction>

	<cffunction name="beforeValidationCallbackThatIncreasesVariable">
		<cfif NOT StructKeyExists(this, "beforeValidationCallbackCount")>
			<cfset this.beforeValidationCallbackCount = 0>
		</cfif>
		<cfset this.beforeValidationCallbackCount++>
	</cffunction>

</cfcomponent>