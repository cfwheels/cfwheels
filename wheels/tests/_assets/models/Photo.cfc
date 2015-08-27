<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset belongsTo(name="gallery", modelName="gallery", foreignKey="id")>
		<cfset beforeValidation("beforeValidationCallbackThatSetsProperty,beforeValidationCallbackThatIncreasesVariable")>
		<cfset beforeCreate("beforeCreateCallbackThatIncreasesVariable")>
		<cfset beforeSave("beforeSaveCallbackThatIncreasesVariable")>
		<cfset afterCreate("afterCreateCallbackThatIncreasesVariable")>
		<cfset beforeSave("afterSaveCallbackThatIncreasesVariable")>
		<cfset validatesPresenceOf("filename")>
		<!--- The evaluated `condition` will throw an exception if callbacks aren't executed properly when this object is a nested property --->
		<cfset validate(method="validateBeforeValidationRunsProperlyAsNestedAssociation", condition="this.beforeValidationCallbackRegistered")>
	</cffunction>

	<cffunction name="afterCreateCallbackThatIncreasesVariable" access="private">
		<cfif not StructKeyExists(this, "afterCreateCallbackCount")>
			<cfset this.afterCreateCallbackCount = 0>
		</cfif>
		<cfset this.afterCreateCallbackCount++>
	</cffunction>
	<cffunction name="afterSaveCallbackThatIncreasesVariable" access="private">
		<cfif not StructKeyExists(this, "afterSaveCallbackCount")>
			<cfset this.afterSaveCallbackCount = 0>
		</cfif>
		<cfset this.afterSaveCallbackCount++>
	</cffunction>

	<cffunction name="beforeCreateCallbackThatIncreasesVariable" access="private">
		<cfif not StructKeyExists(this, "beforeCreateCallbackCount")>
			<cfset this.beforeCreateCallbackCount = 0>
		</cfif>
		<cfset this.beforeCreateCallbackCount++>
	</cffunction>

	<cffunction name="beforeSaveCallbackThatIncreasesVariable" access="private">
		<cfif not StructKeyExists(this, "beforeSaveCallbackCount")>
			<cfset this.beforeSaveCallbackCount = 0>
		</cfif>
		<cfset this.beforeSaveCallbackCount++>
	</cffunction>

	<cffunction name="beforeValidationCallbackThatSetsProperty" access="private">
		<cfset this.beforeValidationCallbackRegistered = true>
	</cffunction>

	<cffunction name="beforeValidationCallbackThatIncreasesVariable" access="private">
		<cfif NOT StructKeyExists(this, "beforeValidationCallbackCount")>
			<cfset this.beforeValidationCallbackCount = 0>
		</cfif>
		<cfset this.beforeValidationCallbackCount++>
	</cffunction>

	<cffunction name="validateBeforeValidationRunsProperlyAsNestedAssociation" access="private">
	</cffunction>

</cfcomponent>