<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="filters" returntype="void" access="public" output="false" hint="Tells Wheels to run a function before an action is run or after an action has been run. You can also specify multiple functions and actions."
	examples=
	'
		<!--- Always execute `restrictAccess` before all actions in this controller --->
		<cfset filters("restrictAccess")>

		<!--- Always execute `isLoggedIn` and `checkIPAddress` (in that order) before all actions in this controller except the `home` and `login` actions --->
		<cfset filters(through="isLoggedIn,checkIPAddress", except="home,login")>
	'
	categories="controller-initialization" chapters="filters-and-verification" functions="verifies">
	<cfargument name="through" type="string" required="true" hint="Function(s) to execute before or after the action(s).">
	<cfargument name="type" type="string" required="false" default="before" hint="Whether to run the function(s) before or after the action(s).">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should only be run on these actions.">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones.">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#" hint="Pass in arguments that should be passed through to the filter function. These can also be passed in as named arguments.">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.through);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.through, loc.i));
			loc.thisFilter = {};
			loc.thisFilter.through = loc.item;
			loc.thisFilter.only = $listClean(arguments.only);
			loc.thisFilter.except = $listClean(arguments.except);
			loc.thisFilter.args = arguments.args;
			if (StructCount(arguments) > 5)
				for (loc.key in arguments)
					if (!ListFindNoCase("through,type,only,except,args", loc.key))
						loc.thisFilter.args[loc.key] = arguments[loc.key];
			if (arguments.type == "before")
				ArrayAppend(variables.wheels.beforeFilters, loc.thisFilter);
			else
				ArrayAppend(variables.wheels.afterFilters, loc.thisFilter);
		}
	</cfscript>
</cffunction>

<cffunction name="verifies" returntype="void" access="public" output="false" hint="Tells Wheels to verify that some specific criterias are met before running an action."
	examples=
	'
		<!--- Tell Wheels to verify that the `handleForm` action is always a post request when executed --->
		<cfset verifies(only="handleForm", post=true)>
	'
	categories="controller-initialization" chapters="filters-and-verification" functions="filters">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the verifications should only be run on these actions.">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones.">
	<cfargument name="post" type="any" required="false" default="" hint="Set to true to verify that this is a post request.">
	<cfargument name="get" type="any" required="false" default="" hint="Set to true to verify that this is a get request.">
	<cfargument name="ajax" type="any" required="false" default="" hint="Set to true to verify that this is an AJAX request.">
	<cfargument name="cookie" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the cookie.">
	<cfargument name="session" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the session.">
	<cfargument name="params" type="string" required="false" default="" hint="Verify that the passed in variable name exists in the params.">
	<cfargument name="handler" type="string" required="false" default="#application.wheels.functions.verifies.handler#" hint="Pass in the name of a function that should handle failed verifications (default is to just abort the request when a verification fails).">
	<cfscript>
		ArrayAppend(variables.wheels.verifications, Duplicate(arguments));
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$getVerifications" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.verifications>
</cffunction>

<cffunction name="$runFilters" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		if (arguments.type == "before")
			loc.filters = variables.wheels.beforeFilters;
		else
			loc.filters = variables.wheels.afterFilters;
		loc.iEnd = ArrayLen(loc.filters);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if ((!Len(loc.filters[loc.i].only) && !Len(loc.filters[loc.i].except)) || (Len(loc.filters[loc.i].only) && ListFindNoCase(loc.filters[loc.i].only, arguments.action)) || (Len(loc.filters[loc.i].except) && !ListFindNoCase(loc.filters[loc.i].except, arguments.action)))
			{
				loc.filterMethod = loc.filters[loc.i].through;
				if (StructKeyExists(variables, loc.filterMethod))
				{
					loc.args = loc.filters[loc.i].args;
					loc.args.method = loc.filterMethod;
					$invoke(argumentCollection=loc.args);
				}
				else
				{
					$throw(type="Wheels.filterNotFound", message="Wheels tried to run the `#loc.filterMethod#` function as a #arguments.type# filter but could not find it.", extendedInfo="Make sure there is a function named `#loc.filterMethod#` in the `#variables.wheels.name#.cfc` file.");
				}
			}
		}
	</cfscript>
</cffunction>