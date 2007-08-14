<cffunction name="beforeFilter" returntype="any" access="public" output="false">
	<cfargument name="filters" type="any" required="true">
	<cfargument name="only" type="any" required="false" default="">
	<cfargument name="except" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfloop list="#arguments.filters#" index="local.i">
		<cfset local.this_filter = structNew()>
		<cfset local.this_filter.filter = trim(local.i)>
		<cfset local.this_filter.only = replace(arguments.only, ", ", ",", "all")>
		<cfset local.this_filter.except = replace(arguments.except, ", ", ",", "all")>
		<cfset arrayAppend(variables.before_filters, local.this_filter)>
	</cfloop>

</cffunction>


<cffunction name="afterFilter" returntype="any" access="public" output="false">
	<cfargument name="filters" type="any" required="true">
	<cfargument name="only" type="any" required="false" default="">
	<cfargument name="except" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfloop list="#arguments.filters#" index="local.i">
		<cfset local.this_filter = structNew()>
		<cfset local.this_filter.filter = trim(local.i)>
		<cfset local.this_filter.only = replace(arguments.only, ", ", ",", "all")>
		<cfset local.this_filter.except = replace(arguments.except, ", ", ",", "all")>
		<cfset arrayAppend(variables.after_filters, local.this_filter)>
	</cfloop>

</cffunction>


<cffunction name="getBeforeFilters" returntype="any" access="public" output="false">
	<cfreturn variables.before_filters>
</cffunction>


<cffunction name="getAfterFilters" returntype="any" access="public" output="false">
	<cfreturn variables.after_filters>
</cffunction>