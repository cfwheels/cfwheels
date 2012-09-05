<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("users")>
		<cfset automaticValidations(true)>
	</cffunction>

</cfcomponent>