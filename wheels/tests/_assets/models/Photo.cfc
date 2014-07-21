<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset belongsTo(name="gallery", modelName="gallery", foreignKey="id")>
		<!--- Uncomment to test issue 284 --->
		<!--- <cfset beforeValidation("beforeValidationCallbackThatSetsProperty,beforeValidationCallbackThatIncreasesVariable")> --->
	</cffunction>

	<!--- Uncomment to test issue 284 --->
	<!--- <cffunction name="beforeValidationCallbackThatSetsProperty">
		<cfset this.beforeValidationCallbackRegistered = true>
	</cffunction> --->

	<!--- Uncomment to test issue 284 --->
	<!--- <cffunction name="beforeValidationCallbackThatIncreasesVariable">
		<cfif NOT StructKeyExists(this, "beforeValidationCallbackCount")>
			<cfset this.beforeValidationCallbackCount = 0>
		</cfif>
		<cfset this.beforeValidationCallbackCount++>
	</cffunction> --->

</cfcomponent>