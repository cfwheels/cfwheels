<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset table("users")>
		<cfset property(name="birthDay", column="birthday")>
		<cfset automaticValidations(true)>
	</cffunction>

</cfcomponent>