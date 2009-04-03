<cffunction name="filters" returntype="void" access="public" output="false" hint="Tells Wheels to run a function before an action is run or after an action has been run. You can also specify multiple functions and actions.">
	<cfargument name="through" type="string" required="true" hint="Function(s) to execute before or after the action(s)">
	<cfargument name="type" type="string" required="false" default="before" hint="Whether to run the function(s) before or after the action(s)">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should only be run on these actions">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.through);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
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

<cffunction name="verifies" returntype="void" access="public" output="false" hint="Tells Wheels to verify that some specific criterias are met before running an action.">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the verifications should only be run on these actions">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones">
	<cfargument name="post" type="any" required="false" default="" hint="Set to true to verify that this is a post request">
	<cfargument name="get" type="any" required="false" default="" hint="Set to true to verify that this is a get request">
	<cfargument name="ajax" type="any" required="false" default="" hint="Set to true to verify that this is an AJAX request">
	<cfargument name="cookie" type="any" required="false" default="" hint="Verify that the passed in variable name exists in the cookie">
	<cfargument name="session" type="any" required="false" default="" hint="Verify that the passed in variable name exists in the session">
	<cfargument name="params" type="any" required="false" default="" hint="Verify that the passed in variable name exists in the params">
	<cfargument name="handler" type="any" required="false" default="false" hint="Pass in the name of a function that should handle failed verifications (default is to just abort the request when a verification fails)">
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