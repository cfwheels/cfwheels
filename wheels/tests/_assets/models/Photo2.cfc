<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("photos")>
		<cfset property(name="DESCRIPTION1", column="description")>
		<cfset property(name="photoid", column="id")>
	</cffunction>

</cfcomponent>