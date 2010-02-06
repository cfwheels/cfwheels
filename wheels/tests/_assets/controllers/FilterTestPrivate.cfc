<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset filters(through="filterTestPrivate")>
	</cffunction>

	<cffunction name="filterTestPrivate" access="private">
		<cfset request.filterTestPrivate = true>
	</cffunction>

</cfcomponent>