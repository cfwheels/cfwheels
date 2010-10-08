<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("userphotos")>
		<cfset setPrimaryKey("userid")>
	</cffunction>

</cfcomponent>