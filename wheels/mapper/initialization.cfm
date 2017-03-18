<cfscript>

/**
 * Internal Function
 */
public struct function init(boolean restful=true, boolean methods=arguments.restful) {

	// Set up control variables.
	variables.scopeStack = [];
	variables.restful = arguments.restful;
	variables.methods = arguments.restful OR arguments.methods;

	// Set up default variable constraints.
	variables.constraints = {};
	variables.constraints["format"] = "\w+";
	variables.constraints["controller"] = "[^\/]+";

	// Set up constraint for globbed routes.
	variables.constraints["\*\w+"] = ".+";

	// Fix naming collision with cfwheels controller() methods.
	this.controller = variables.controller = Duplicate(variables.$controller);

	return this;
}

</cfscript>
