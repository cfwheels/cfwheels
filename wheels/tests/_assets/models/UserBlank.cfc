<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset table("users")>
		<cfset automaticValidations(true)>
	</cffunction>

</cfcomponent>