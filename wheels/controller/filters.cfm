<cfscript>

// PUBLIC CONTROLLER INITIALIZATION FUNCTIONS

public void function filters(
	required string through,
	string type = "before",
	string only = "",
	string except = "",
	string placement = "append"
) {
	arguments.through = $listClean(arguments.through);
	arguments.only = $listClean(arguments.only);
	arguments.except = $listClean(arguments.except);
	local.namedArguments = "through,type,only,except,placement";
	local.iEnd = ListLen(arguments.through);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		local.filter = {};
		local.filter.through = ListGetAt(arguments.through, local.i);
		local.filter.type = arguments.type;
		local.filter.only = arguments.only;
		local.filter.except = arguments.except;
		local.filter.arguments = {};
		if (StructCount(arguments) > ListLen(local.namedArguments)) {
			local.dynamicArgument = local.filter.through & "Arguments";
			if (StructKeyExists(arguments, local.dynamicArgument)) {
				local.filter.arguments = arguments[local.dynamicArgument];
			}
			for (local.key in arguments) {
				if (!ListFindNoCase(ListAppend(local.namedArguments, local.dynamicArgument), local.key)) {
					local.filter.arguments[local.key] = arguments[local.key];
				}
			}
		}
		if (arguments.placement == "append") {
			ArrayAppend(variables.$class.filters, local.filter);
		} else {
			ArrayPrepend(variables.$class.filters, local.filter);
		}
	}
}

public void function setFilterChain(required array chain) {
	// Clear current filter chain and then re-add from the passed in chain
	variables.$class.filters = [];
	local.iEnd = ArrayLen(arguments.chain);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		filters(argumentCollection=arguments.chain[local.i]);
	}
}

public array function filterChain(string type = "all") {
	if (!ListFindNoCase("before,after,all", arguments.type)) {
		// Throw error because an invalid type was passed in
		$throw(
			type="Wheels.InvalidFilterType",
			message="The filter type of `#arguments.type#` is invalid.",
			extendedInfo="Please use either `before` or `after`."
		);
	}
	if (arguments.type == "all") {
		// Return all filters
		local.rv = variables.$class.filters;
	} else {
		// Loop over the filters and return all those that match the supplied type
		local.rv = [];
		local.iEnd = ArrayLen(variables.$class.filters);
		for (local.i=1; local.i <= local.iEnd; local.i++) {
			if (variables.$class.filters[local.i].type == arguments.type) {
				ArrayAppend(local.rv, variables.$class.filters[local.i]);
			}
		}
	}
	return local.rv;
}

// PRIVATE FUNCTIONS

public void function $runFilters(required string type, required string action) {
	local.filters = filterChain(arguments.type);
	local.iEnd = ArrayLen(local.filters);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		local.filter = local.filters[local.i];
		loc.listsNotSpecified = !Len(local.filter.only) && !Len(local.filter.except);
		loc.inOnlyList = Len(local.filter.only) && ListFindNoCase(local.filter.only, arguments.action);
		loc.notInExceptionList = Len(local.filter.except) && !ListFindNoCase(local.filter.except, arguments.action);
		if (loc.listsNotSpecified || loc.inOnlyList || loc.notInExceptionList) {
			if (!StructKeyExists(variables, local.filter.through)) {
				$throw(
					type="Wheels.FilterNotFound",
					message="CFWheels tried to run the `#local.filter.through#` function as a #arguments.type# filter but could not find it.",
					extendedInfo="Make sure there is a function named `#local.filter.through#` in the `#variables.$class.name#.cfc` file."
				);
			}
			local.result = $invoke(method=local.filter.through, invokeArgs=local.filter.arguments);
			if ((StructKeyExists(local, "result") && !local.result) || $performedRenderOrRedirect()) {
				// The filter function returned false or rendered content so we skip the remaining filters
				break;
			}
		}
	}
}

</cfscript>