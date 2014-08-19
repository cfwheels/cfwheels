<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="filters" returntype="void" access="public" output="false" hint="Tells Wheels to run a function before an action is run or after an action has been run. You can also specify multiple functions and actions in list form."
	examples=
	'
		// Always execute `restrictAccess` before all actions in this controller
		filters("restrictAccess");

		// Always execute `isLoggedIn` and `checkIPAddress` (in that order) before all actions in this controller except the `home` and `login` actions
		filters(through="isLoggedIn,checkIPAddress", except="home,login");
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="setFilterChain,filterChain">
	<cfargument name="through" type="string" required="true" hint="Function(s) to execute before or after the action(s).">
	<cfargument name="type" type="string" required="false" hint="Whether to run the function(s) before or after the action(s).">
	<cfargument name="only" type="string" required="false" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should only be run on these actions.">
	<cfargument name="except" type="string" required="false" hint="Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones.">
	<cfscript>
		var loc = {};
		arguments = $args(name="filters", args=arguments);
		arguments.through = $listClean(arguments.through);
		arguments.only = $listClean(arguments.only);
		arguments.except = $listClean(arguments.except);
		loc.definedArguments = $definedArguments(filters);
		loc.iEnd = ListLen(arguments.through);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// set basic properties for the filter
			loc.filter = {through=ListGetAt(arguments.through, loc.i), type=arguments.type, only=arguments.only, except=arguments.except, arguments={}};

			// check if custom arguments were passed in and if so, specify that they should be passed in to the filter function when executed
			if (StructCount(arguments) > ListLen(loc.definedArguments))
			{
				// check if the arguments were passed in as "restrictAccessArguments" (for example) and then specify that the entire struct should be passed along
				loc.dynamicArgument = loc.filter.through & "Arguments";
				if (StructKeyExists(arguments, loc.dynamicArgument))
				{
					loc.filter.arguments = arguments[loc.dynamicArgument];
				}

				// loop through all arguments and specify that they should be passed along unless they are one of the named ones belonging to this function ("only", "except" etc) or is the struct we just looked for above
				for (loc.key in arguments)
				{
					if (!ListFindNoCase(ListAppend(loc.definedArguments, loc.dynamicArgument), loc.key))
					{
						loc.filter.arguments[loc.key] = arguments[loc.key];
					}
				}
			}

			// put the newly created filter specification in the array that holds all of them
			ArrayAppend(variables.wheels.class.filters, loc.filter);
		}
	</cfscript>
</cffunction>

<cffunction name="setFilterChain" returntype="void" access="public" output="false" hint="Use this function if you need a more low level way of setting the entire filter chain for a controller."
	examples=
	'
		// Set filter chain directly in an array
		local.filters = [];
		local.filters[1] = {through="restrictAccess"};
		local.filters[2] = {through="isLoggedIn,checkIPAddress", except="home,login"};
		local.filters[3] = {type="after", through="logConversion", only="thankYou"};
		setFilterChain(local.filters);
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="filters,filterChain">
	<cfargument name="chain" type="array" required="true" hint="An array of structs, each of which represent an `argumentCollection` that gets passed to the `filters` function. This should represent the entire filter chain that you want to use for this controller.">
	<cfscript>
		var loc = {};
		
		// clear current filter chain
		variables.wheels.class.filters = [];
		
		// loop through passed in chain argument and add each item to filter chain
		loc.iEnd = ArrayLen(arguments.chain);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			filters(argumentCollection=arguments.chain[loc.i]);
		}
	</cfscript>
</cffunction>

<!--- PUBLIC CONTROLLER CLASS FUNCTIONS --->

<cffunction name="filterChain" returntype="array" access="public" output="false" hint="Returns an array of all the filters set on this controller in the order in which they will be executed."
	examples=
	'
		// Get filter chain, remove the first item, and set it back
		local.myFilterChain = filterChain();
		ArrayDeleteAt(local.myFilterChain, 1);
		setFilterChain(local.myFilterChain);
	'
	categories="controller-initialization,filtering" chapters="filters-and-verification" functions="filters,setFilterChain">
	<cfargument name="type" type="string" required="false" default="all" hint="Use this argument to return only `before` or `after` filters.">
	<cfscript>
		var loc = {};

		// invalid type
		if (!ListFindNoCase("before,after,all", arguments.type))
		{
			$throw(type="Wheels.InvalidFilterType", message="The filter type of `#arguments.type#` is invalid.", extendedInfo="Please use either `all`, `before` or `after`.");
		}

		if (arguments.type == "all")
		{
			// return all filters
			loc.returnValue = variables.wheels.class.filters;
		}
		else
		{
			// loop over the filters and return all those that match the supplied filter type
			loc.returnValue = ArrayNew(1);
			loc.iEnd = ArrayLen(variables.wheels.class.filters);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (variables.wheels.class.filters[loc.i].type == arguments.type)
				{
					ArrayAppend(loc.returnValue, variables.wheels.class.filters[loc.i]);
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$runFilters" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.filters = filterChain(arguments.type);
		
		// execute all filters in order according to their "only" and "except" settings
		loc.iEnd = ArrayLen(loc.filters);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.filter = loc.filters[loc.i];
			if ((!Len(loc.filter.only) && !Len(loc.filter.except)) || (Len(loc.filter.only) && ListFindNoCase(loc.filter.only, arguments.action)) || (Len(loc.filter.except) && !ListFindNoCase(loc.filter.except, arguments.action)))
			{
				if (!StructKeyExists(variables, loc.filter.through))
				{
					$throw(type="Wheels.filterNotFound", message="Wheels tried to run the `#loc.filter.through#` function as a #arguments.type# filter but could not find it.", extendedInfo="Make sure there is a function named `#loc.filter.through#` in the `#variables.wheels.class.name#.cfc` file.");
				}
				loc.result = $invoke(method=loc.filter.through, invokeArgs=loc.filter.arguments);
				
				// if the filter function returned false or rendered content we skip the remaining filters in the chain
				if ((StructKeyExists(loc, "result") && IsBoolean(loc.result) && !loc.result) || $performedRenderOrRedirect())
				{
					break;
				}
			}
		}
	</cfscript>
</cffunction>