<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<cfset validatesPresenceOf(property="firstName,lastName,email,password")>
		<cfset validatesLengthOf(property="firstName,lastName,email", maximum=50, allowBlank=true, message="[property] must be 50 characters or less")>
		<cfset validatesLengthOf(property="password", maximum=20, allowBlank=true)>
		<cfset validatesFormatOf(property="email", regex="^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$", allowBlank=true)>
		<cfset validatesUniquenessOf(property="email")>
		<cfset validatesConfirmationOf(property="password")>
	</cffunction>

</cfcomponent>