<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="filters" returntype="void" access="public" output="false">
	<cfargument name="through" type="string" required="true">
	<cfargument name="type" type="string" required="false" default="before">
	<cfargument name="only" type="string" required="false" default="">
	<cfargument name="except" type="string" required="false" default="">
	<cfargument name="placement" type="string" required="false" default="append">
	<cfscript>
		var loc = {};
		arguments.through = $listClean(arguments.through);
		arguments.only = $listClean(arguments.only);
		arguments.except = $listClean(arguments.except);
		loc.namedArguments = "through,type,only,except,placement";
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
			if (arguments.placement == "append")
			{
				ArrayAppend(variables.$class.filters, loc.filter);
			}
			else
			{
				ArrayPrepend(variables.$class.filters, loc.filter);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="setFilterChain" returntype="void" access="public" output="false">
	<cfargument name="chain" type="array" required="true">
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

<cffunction name="filterChain" returntype="array" access="public" output="false">
	<cfargument name="type" type="string" required="false" default="all">
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
			loc.rv = [];
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