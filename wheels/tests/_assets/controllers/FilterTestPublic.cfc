<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset filters(through="filterTestPublic")>
	</cffunction>

	<cffunction name="filterTestPublic" access="public">
		<cfset request.filterTestPublic = true>
	</cffunction>

</cfcomponent>