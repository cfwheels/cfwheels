<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("author")>
		<cfset beforeCreate("beforeCreateCallbackThatIncreasesVariable")>
		<cfset beforeSave("beforeSaveCallbackThatIncreasesVariable")>
		<cfset afterCreate("afterCreateCallbackThatIncreasesVariable")>
		<cfset beforeSave("afterSaveCallbackThatIncreasesVariable")>
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

</cfcomponent>