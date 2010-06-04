<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset table("users")>
		<cfset setDefaultValidations(true)>
	</cffunction>

</cfcomponent>