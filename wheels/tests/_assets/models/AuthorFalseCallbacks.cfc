<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset table("Authors")>
		<cfset hasMany("posts")>
		<cfset hasOne("profile")>
		<cfset afterSave("callbackThatReturnsFalse")>
		<cfset afterDelete("callbackThatReturnsFalse")>
	</cffunction>

	<cffunction name="callbackThatReturnsFalse">
		<cfreturn false>
	</cffunction>

</cfcomponent>