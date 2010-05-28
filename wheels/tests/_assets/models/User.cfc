<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset hasMany(name="photogalleries")>
		<cfset hasMany(name="outerjoinphotogalleries", modelName="photogallery", jointype="outer")>
		<cfset validatesPresenceOf("username,password,firstname,lastname")>
		<cfset validatesUniquenessOf("username")>
		<cfset validatesLengthOf(property="username", minimum="4", when="onCreate")>
		<cfset validatesLengthOf(property="password", minimum="4", when="onUpdate")>
		<cfset validate("validateCalled")>
		<cfset validateOnCreate("validateOnCreateCalled")>
		<cfset validateOnUpdate("validateOnUpdateCalled")>
	</cffunction>
	
	<cffunction name="validateCalled">
		<cfset this._validateCalled = true>
	</cffunction>
	
	<cffunction name="validateOnCreateCalled">
		<cfset this._validateOnCreateCalled = true>
	</cffunction>
	
	<cffunction name="validateOnUpdateCalled">
		<cfset this._validateOnUpdateCalled = true>
	</cffunction>

</cfcomponent>