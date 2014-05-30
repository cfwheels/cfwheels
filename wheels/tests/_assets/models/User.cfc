<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany(name="galleries")>
		<cfset hasOne(name="combikey")>
		<!--- crazy join to test the joinKey argument --->
		<cfset hasOne(name="author", foreignKey="firstName", joinKey="firstName")>
		<cfset hasMany(name="authors", foreignKey="firstName", joinKey="firstName")>
		<cfset hasMany(name="authorsCustom", modelName="authors", join="INNER JOIN authors ON authors.firstname = users.firstname AND authors.lastname = users.lastname")>
		<cfset hasMany(name="combikeys")>
		<cfset hasMany(name="outerjoinphotogalleries", modelName="gallery", jointype="outer")>
		<cfset validatesPresenceOf("username,password,firstname,lastname")>
		<cfset validatesUniquenessOf("username")>
		<cfset validatesLengthOf(property="username", minimum="4", maximum="20", when="onCreate", message="Please shorten your [property] please. [maximum] characters is the maximum length allowed.")>
		<cfset validatesLengthOf(property="password", minimum="4", when="onUpdate")>
		<cfset validate("validateCalled")>
		<cfset validateOnCreate("validateOnCreateCalled")>
		<cfset validateOnUpdate("validateOnUpdateCalled")>
 		<cfif application.wheels.dataAdapter eq "Oracle">
			<cfset property(name="fullName", sql="users.firstname || ' ' || users.lastname")>
		<cfelseif application.wheels.dataAdapter eq "MySQL">
			<cfset property(name="fullName", sql="concat(users.firstname, ' ', users.lastname)")>
		<cfelseif application.wheels.dataAdapter eq "PostgreSQL">
			<cfset property(name="fullName", sql="users.firstname || ' ' || users.lastname")>
		<cfelse>
			<cfset property(name="fullName", sql="users.firstname + ' ' + users.lastname")>
		</cfif>
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