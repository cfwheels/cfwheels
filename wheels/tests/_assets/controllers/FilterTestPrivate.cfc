<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset filters(through="filterTestPrivate")>
	</cffunction>

	<cffunction name="filterTestPrivate" access="private">
		<cfset request.testPassed = true>
	</cffunction>

</cfcomponent>