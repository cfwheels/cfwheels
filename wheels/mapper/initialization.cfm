<cfscript>
/**
 * Internal function.
 */
public struct function $init(boolean restful = true, boolean methods = arguments.restful, boolean mapFormat = true) {
	// Set up control variables.
	variables.scopeStack = [];
	variables.restful = arguments.restful;
	variables.methods = arguments.restful || arguments.methods;
	variables.mapFormat = arguments.mapFormat;

	// Set up default variable constraints.
	variables.constraints = {};
	variables.constraints.format = "\w+";
	variables.constraints.controller = "[^\/]+";

	// Set up constraint for globbed routes.
	variables.constraints["\*\w+"] = ".+";

	return this;
}
</cfscript>
