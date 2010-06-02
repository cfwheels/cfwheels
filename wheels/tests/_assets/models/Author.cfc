<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<cfset beforeSave("callbackThatReturnsTrue")>
		<cfset beforeDelete("callbackThatReturnsTrue")>
		<cfset property(name="firstName", label="First name(s)", defaultValue="Dave")>
	</cffunction>

	<cffunction name="callbackThatReturnsTrue">
		<cfreturn true>
	</cffunction>

</cfcomponent>