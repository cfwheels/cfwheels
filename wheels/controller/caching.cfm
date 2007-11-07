<cffunction name="cachesAction" returntype="any" access="public" output="false">
	<cfargument name="actions" type="any" required="true">
	<cfargument name="time" type="any" required="false" default="#application.settings.caching.actions#">
	<cfset var local = structNew()>

	<cfloop list="#arguments.actions#" index="local.i">
		<cfset local.this_action = structNew()>
		<cfset local.this_action.action = trim(local.i)>
		<cfset local.this_action.time = arguments.time>
		<cfset arrayAppend(variables.class.cachable_actions, local.this_action)>
	</cfloop>

</cffunction>


<cffunction name="CFW_getCachableActions" returntype="any" access="public" output="false">
	<cfreturn variables.class.cachable_actions>
</cffunction>