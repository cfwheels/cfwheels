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
		<cfset arrayAppend(variables.class.before_filters, local.this_filter)>
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
		<cfset arrayAppend(variables.class.after_filters, local.this_filter)>
	</cfloop>
</cffunction>


<cffunction name="verify" returntype="any" access="public" output="false">
	<cfargument name="post" type="any" required="false" default="false">
	<cfargument name="get" type="any" required="false" default="false">
	<cfargument name="ajax" type="any" required="false" default="false">
	<cfargument name="params" type="any" required="false" default="">
	<cfargument name="session" type="any" required="false" default="">
	<cfargument name="cookie" type="any" required="false" default="">
	<cfargument name="back" type="any" required="false" default="false">
	<cfargument name="only" type="any" required="false" default="">
	<cfargument name="except" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset local.this_verification = structNew()>
	<cfloop collection="#arguments#" item="local.i">
		<cfif listFindNoCase("post,get,ajax,params,session,cookie,back,only,except", local.i)>
			<cfset local.this_verification[lCase(local.i)] = replace(arguments[local.i], ", ", ",", "all")>
		<cfelse>
			<cfset local.this_verification["flash_#lCase(local.i)#"] = arguments[local.i]>
		</cfif>
	</cfloop>
	<cfset arrayAppend(variables.class.verifications, local.this_verification)>
</cffunction>

<cffunction name="CFW_getBeforeFilters" returntype="any" access="public" output="false">
	<cfreturn variables.class.before_filters>
</cffunction>


<cffunction name="CFW_getAfterFilters" returntype="any" access="public" output="false">
	<cfreturn variables.class.after_filters>
</cffunction>


<cffunction name="CFW_getVerifications" returntype="any" access="public" output="false">
	<cfreturn variables.class.verifications>
</cffunction>