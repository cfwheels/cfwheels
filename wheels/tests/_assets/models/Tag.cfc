<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo(name="parent", modelName="tag", foreignKey="parentid", joinType="outer")>
		<cfset hasMany(name="children", modelName="tag", foreignKey="parentid")>
		<cfset hasMany(name="classifications")>
		<cfset beforeSave("callbackThatReturnsTrue")>
		<cfset property(name="name", label="Tag name")>
		<cfset property(name="virtual", label="Virtual property")>
	</cffunction>

	<cffunction name="callbackThatIncreasesVariable">
		<cfif NOT StructKeyExists(this, "callbackCount")>
			<cfset this.callbackCount = 0>
		</cfif>
		<cfset this.callbackCount++>
	</cffunction>

	<cffunction name="callbackThatReturnsFalse">
		<cfreturn false>
	</cffunction>

	<cffunction name="callbackThatReturnsTrue">
		<cfreturn true>
	</cffunction>

	<cffunction name="callbackThatReturnsNothing">
	</cffunction>

	<cffunction name="callbackThatSetsProperty">
		<cfset this.setByCallback = true>
	</cffunction>

	<cffunction name="firstCallback">
		<cfif NOT StructKeyExists(this, "orderTest")>
			<cfset this.orderTest = "">
		</cfif>
		<cfset this.orderTest = ListAppend(this.orderTest, "first")>
	</cffunction>

	<cffunction name="secondCallback">
		<cfif NOT StructKeyExists(this, "orderTest")>
			<cfset this.orderTest = "">
		</cfif>
		<cfset this.orderTest = ListAppend(this.orderTest, "second")>
		<cfreturn false>
	</cffunction>

</cfcomponent>