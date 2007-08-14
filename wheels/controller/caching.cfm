<cffunction name="cachesRequest" returntype="any" access="public" output="false">
	<cfargument name="requests" type="any" required="true">
	<cfargument name="time" type="any" required="false" default="#application.settings.default_cache_time#">
	<cfset var local = structNew()>

	<cfloop list="#arguments.requests#" index="local.i">
		<cfset local.this_request = structNew()>
		<cfset local.this_request.request = trim(local.i)>
		<cfset local.this_request.time = arguments.time>
		<cfset arrayAppend(variables.cachable_requests, local.this_request)>
	</cfloop>

</cffunction>


<cffunction name="getCachableRequests" returntype="any" access="public" output="false">
	<cfreturn variables.cachable_requests>
</cffunction>


<cffunction name="cachesAction" returntype="any" access="public" output="false">
	<cfargument name="actions" type="any" required="true">
	<cfargument name="time" type="any" required="false" default="#application.settings.default_cache_time#">
	<cfset var local = structNew()>

	<cfloop list="#arguments.actions#" index="local.i">
		<cfset local.this_action = structNew()>
		<cfset local.this_action.action = trim(local.i)>
		<cfset local.this_action.time = arguments.time>
		<cfset arrayAppend(variables.cachable_actions, local.this_action)>
	</cfloop>

</cffunction>


<cffunction name="getCachableActions" returntype="any" access="public" output="false">
	<cfreturn variables.cachable_actions>
</cffunction>