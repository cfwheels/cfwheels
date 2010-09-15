<cfcomponent extends="wheelsMapping.model">

	<cffunction name="init">
		<cfset property(name="birthDay", column="birthday")>
		<cfset table("users")>
		<cfset automaticValidations(true)>
	</cffunction>

</cfcomponent>