<cffunction name="caches" returntype="void" access="public" output="false">
	<cfargument name="actions" type="string" required="false" default="">
	<cfargument name="time" type="numeric" required="false" default="#application.settings.defaultCacheTime#">
	<cfset var locals = structNew()>

	<cfloop list="#arguments.actions#" index="locals.i">
		<cfset locals.thisAction = structNew()>
		<cfset locals.thisAction.action = trim(locals.i)>
		<cfset locals.thisAction.time = arguments.time>
		<cfset arrayAppend(variables.wheels.cachableActions, locals.thisAction)>
	</cfloop>

</cffunction>

<cffunction name="$getCachableActions" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.cachableActions>
</cffunction>