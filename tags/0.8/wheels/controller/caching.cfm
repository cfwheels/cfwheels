<cffunction name="caches" returntype="void" access="public" output="false">
	<cfargument name="actions" type="string" required="false" default="">
	<cfargument name="time" type="numeric" required="false" default="#application.settings.defaultCacheTime#">
	<cfset var loc = {}>

	<cfloop list="#arguments.actions#" index="loc.i">
		<cfset loc.thisAction = StructNew()>
		<cfset loc.thisAction.action = trim(loc.i)>
		<cfset loc.thisAction.time = arguments.time>
		<cfset arrayAppend(variables.wheels.cachableActions, loc.thisAction)>
	</cfloop>

</cffunction>

<cffunction name="$getCachableActions" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.cachableActions>
</cffunction>