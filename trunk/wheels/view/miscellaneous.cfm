<cffunction name="includePartial" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="$type" type="any" required="false" default="include">
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="cycle" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="true">
	<cfargument name="name" type="any" required="false" default="default">
	<cfset var loc = structNew()>

	<cfif NOT isDefined("request.wheels.cycle.#arguments.name#")>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, 1)>
	<cfelse>
		<cfset loc.foundAt = listFindNoCase(arguments.values, request.wheels.cycle[arguments.name])>
		<cfif loc.foundAt IS listLen(arguments.values)>
			<cfset loc.foundAt = 0>
		</cfif>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, loc.foundAt + 1)>
	</cfif>

	<cfreturn request.wheels.cycle[arguments.name]>
</cffunction>