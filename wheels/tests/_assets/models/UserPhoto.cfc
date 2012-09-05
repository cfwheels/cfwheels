<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("userphotos")>
		<cfset setPrimaryKey("userid")>
		<cfset automaticValidations(true)>
	</cffunction>

</cfcomponent>