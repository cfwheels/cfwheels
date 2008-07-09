<cffunction name="filters" returntype="void" access="public" output="false">
	<cfargument name="through" type="string" required="true">
	<cfargument name="only" type="string" required="false" default="">
	<cfargument name="except" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="before">
	<cfset var locals = structNew()>
	<cfloop list="#arguments.through#" index="locals.i">
		<cfset locals.thisFilter = structNew()>
		<cfset locals.thisFilter.through = trim(locals.i)>
		<cfset locals.thisFilter.only = replace(arguments.only, ", ", ",", "all")>
		<cfset locals.thisFilter.except = replace(arguments.except, ", ", ",", "all")>
		<cfif arguments.type IS "before">
			<cfset arrayAppend(variables.wheels.beforeFilters, locals.thisFilter)>
		<cfelse>
			<cfset arrayAppend(variables.wheels.afterFilters, locals.thisFilter)>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="verifies" returntype="void" access="public" output="false">
	<cfargument name="only" type="string" required="false" default="">
	<cfargument name="except" type="string" required="false" default="">
	<cfargument name="post" type="any" required="false" default="">
	<cfargument name="get" type="any" required="false" default="">
	<cfargument name="ajax" type="any" required="false" default="">
	<cfargument name="cookie" type="any" required="false" default="">
	<cfargument name="session" type="any" required="false" default="">
	<cfargument name="params" type="any" required="false" default="">
	<cfargument name="handler" type="any" required="false" default="false">
	<cfset arrayAppend(variables.wheels.verifications, StructCopy(arguments))>
</cffunction>

<cffunction name="$getBeforeFilters" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.beforeFilters>
</cffunction>

<cffunction name="$getAfterFilters" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.afterFilters>
</cffunction>

<cffunction name="$getVerifications" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.verifications>
</cffunction>