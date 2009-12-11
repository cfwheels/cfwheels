<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<cfset beforeSave("callbackThatReturnsTrue")>
		<cfset beforeDelete("callbackThatReturnsTrue")>
	</cffunction>

	<cffunction name="callbackThatReturnsTrue">
		<cfreturn true>
	</cffunction>

</cfcomponent>