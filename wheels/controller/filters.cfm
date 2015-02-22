<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="filters" returntype="void" access="public" output="false" hint="Tells CFWheels to run a function before an action is run or after an action has been run. You can also specify multiple functions and actions."
	examples=
	'
		// Always execute `restrictAccess` before all actions in this controller
		filters("restrictAccess");

		// Always execute `isLoggedIn` and `checkIPAddress` (in that order) before all actions in this controller except the `home` and `login` actions
		filters(through="isLoggedIn,checkIPAddress", except="home,login");
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="setFilterChain,filterChain">
	<cfargument name="through" type="string" required="true" hint="Function(s) to execute before or after the action(s).">
	<cfargument name="type" type="string" required="false" default="before" hint="Whether to run the function(s) before or after the action(s).">
	<cfargument name="only" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell CFWheels that the filter function(s) should only be run on these actions.">
	<cfargument name="except" type="string" required="false" default="" hint="Pass in a list of action names (or one action name) to tell CFWheels that the filter function(s) should be run on all actions except the specified ones.">
	<cfscript>
		var loc = {};
		arguments.through = $listClean(arguments.through);
		arguments.only = $listClean(arguments.only);
		arguments.except = $listClean(arguments.except);
		loc.namedArguments = "through,type,only,except";
		loc.iEnd = ListLen(arguments.through);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.filter = {};
			loc.filter.through = ListGetAt(arguments.through, loc.i);
			loc.filter.type = arguments.type;
			loc.filter.only = arguments.only;
			loc.filter.except = arguments.except;
			loc.filter.arguments = {};
			if (StructCount(arguments) > ListLen(loc.namedArguments))
			{
				loc.dynamicArgument = loc.filter.through & "Arguments";
				if (StructKeyExists(arguments, loc.dynamicArgument))
				{
					loc.filter.arguments = arguments[loc.dynamicArgument];
				}
				for (loc.key in arguments)
				{
					if (!ListFindNoCase(ListAppend(loc.namedArguments, loc.dynamicArgument), loc.key))
					{
						loc.filter.arguments[loc.key] = arguments[loc.key];
					}
				}
			}
			ArrayAppend(variables.$class.filters, loc.filter);
		}
	</cfscript>
</cffunction>

<cffunction name="setFilterChain" returntype="void" access="public" output="false" hint="Use this function if you need a more low level way of setting the entire filter chain for a controller."
	examples=
	'
		// Set filter chain directly in an array
		setFilterChain([
			{through="restrictAccess"},
			{through="isLoggedIn,checkIPAddress", except="home,login"},
			{type="after", through="logConversion", only="thankYou"}
		]);
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="filters,filterChain">
	<cfargument name="chain" type="array" required="true" hint="An array of structs, each of which represent an `argumentCollection` that get passed to the `filters` function. This should represent the entire filter chain that you want to use for this controller.">
	<cfscript>
		var loc = {};
		
		// clear current filter chain and then re-add from the passed in chain
		variables.$class.filters = [];
		loc.iEnd = ArrayLen(arguments.chain);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			filters(argumentCollection=arguments.chain[loc.i]);
		}
	</cfscript>
</cffunction>

<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="filterChain" returntype="array" access="public" output="false" hint="Returns an array of all the filters set on this controller in the order in which they will be executed."
	examples=
	'
		// Get filter chain, remove the first item, and set it back
		myFilterChain = filterChain();
		ArrayDeleteAt(myFilterChain, 1);
		setFilterChain(myFilterChain);
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="filters,setFilterChain">
	<cfargument name="type" type="string" required="false" default="all" hint="Use this argument to return only `before` or `after` filters.">
	<cfscript>
		var loc = {};
		if (!ListFindNoCase("before,after,all", arguments.type))
		{
			// throw error because an invalid type was passed in
			$throw(type="Wheels.InvalidFilterType", message="The filter type of `#arguments.type#` is invalid.", extendedInfo="Please use either `before` or `after`.");
		}
		if (arguments.type == "all")
		{
			// return all filters
			loc.rv = variables.$class.filters;
		}
		else
		{
			// loop over the filters and return all those that match the supplied type
			loc.rv = ArrayNew(1);
			loc.iEnd = ArrayLen(variables.$class.filters);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (variables.$class.filters[loc.i].type == arguments.type)
				{
					ArrayAppend(loc.rv, variables.$class.filters[loc.i]);
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$runFilters" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.filters = filterChain(arguments.type);
		loc.iEnd = ArrayLen(loc.filters);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.filter = loc.filters[loc.i];
			if ((!Len(loc.filter.only) && !Len(loc.filter.except)) || (Len(loc.filter.only) && ListFindNoCase(loc.filter.only, arguments.action)) || (Len(loc.filter.except) && !ListFindNoCase(loc.filter.except, arguments.action)))
			{
				if (!StructKeyExists(variables, loc.filter.through))
				{
					$throw(type="Wheels.FilterNotFound", message="CFWheels tried to run the `#loc.filter.through#` function as a #arguments.type# filter but could not find it.", extendedInfo="Make sure there is a function named `#loc.filter.through#` in the `#variables.$class.name#.cfc` file.");
				}
				loc.result = $invoke(method=loc.filter.through, invokeArgs=loc.filter.arguments);
				if ((StructKeyExists(loc, "result") && !loc.result) || $performedRenderOrRedirect())
				{
					// the filter function returned false or rendered content so we skip the remaining filters
					break;
				}
			}
		}
	</cfscript>
</cffunction>