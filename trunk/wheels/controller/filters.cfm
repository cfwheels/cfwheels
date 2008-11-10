<cffunction name="filters" returntype="void" access="public" output="false">
	<cfargument name="through" type="string" required="true">
	<cfargument name="type" type="string" required="false" default="before">
	<cfargument name="only" type="string" required="false" default="">
	<cfargument name="except" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.through);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.through, loc.i));
			loc.thisFilter = {};
			loc.thisFilter.through = loc.item;
			loc.thisFilter.only = Replace(arguments.only, ", ", ",", "all");
			loc.thisFilter.except = Replace(arguments.except, ", ", ",", "all");
			if (arguments.type IS "before")
				ArrayAppend(variables.wheels.beforeFilters, loc.thisFilter);
			else
				ArrayAppend(variables.wheels.afterFilters, loc.thisFilter);
		}	
	</cfscript>
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
	<cfscript>
		ArrayAppend(variables.wheels.verifications, StructCopy(arguments));
	</cfscript>
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