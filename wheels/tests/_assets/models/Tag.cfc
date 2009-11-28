<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="init">
		<cfset beforeSave("runCallbackThatReturnsFalse")>
	</cffunction>

	<cffunction name="runCallbackThatReturnsFalse">
		<cfreturn false>
	</cffunction>

</cfcomponent>