<cffunction name="includePartial" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="_type" type="any" required="false" default="include">
	<cfreturn _includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="cycle" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="true">
	<cfargument name="name" type="any" required="false" default="default">
	<cfset var local = structNew()>

	<cfif NOT isDefined("request.wheels.cycle.#arguments.name#")>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, 1)>
	<cfelse>
		<cfset local.found_at = listFindNoCase(arguments.values, request.wheels.cycle[arguments.name])>
		<cfif local.found_at IS listLen(arguments.values)>
			<cfset local.found_at = 0>
		</cfif>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, local.found_at + 1)>
	</cfif>

	<cfreturn request.wheels.cycle[arguments.name]>
</cffunction>