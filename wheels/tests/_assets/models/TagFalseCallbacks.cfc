<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("tags")>
		<cfset afterSave("callbackThatReturnsFalse")>
		<cfset afterDelete("callbackThatReturnsFalse")>
	</cffunction>

	<cffunction name="callbackThatReturnsFalse">
		<cfreturn false>
	</cffunction>

</cfcomponent>