<cfscript>

/**
 * Internal function.
 */
public void function $compileRegex(rquired string regex) {
	local.pattern = CreateObject("java", "java.util.regex.Pattern");
	try {
		local.regex = local.pattern.compile(arguments.regex);
		return;
	} catch (any e) {
		local.identifier = arguments.pattern;
		if (StructKeyExists(arguments, "name")) {
			local.identifier = arguments.name;
		}
		Throw(
			type="Wheels.InvalidRegex",
			message="The route `#local.identifier#` has created invalid regex of `#arguments.regex#`."
		);
	}
}

/**
 * Internal function.
 * Force leading slashes, remove trailing and duplicate slashes.
 */
public string function $normalizePattern(required string pattern) {

	// First clear the ending slashes.
	local.pattern = REReplace(arguments.pattern, "(^\/+|\/+$)", "", "all");

	// Reset middle slashes to singles if they are multiple.
	local.pattern = REReplace(local.pattern, "\/+", "/", "all");

	// Remove a slash next to a period.
	local.pattern = REReplace(local.pattern, "\/+\.", ".", "all");

	// Return with a prepended slash.
	return "/" & Replace(local.pattern, "//", "/", "all");

}

/**
 * Internal function.
 * Transform route pattern into regular expression.
 */
public string function $patternToRegex(required string pattern, struct constraints={}) {

	// Escape any dots in pattern.
	local.rv = Replace(arguments.pattern, ".", "\.", "all");

	// Further mask pattern variables.
	// This keeps constraint patterns from being replaced twice.
	local.rv = REReplace(local.rv, "\[(\*?\w+)\]", ":::\1:::", "all");

	// Replace known variable keys using constraints.
	local.constraints = StructCopy(arguments.constraints);
	StructAppend(local.constraints, variables.constraints, false);
	for (local.key in local.constraints) {
		local.rv = REReplaceNoCase(local.rv, ":::#local.key#:::", "(#local.constraints[local.key]#)", "all");
	}

	// Replace remaining variables with default regex.
	local.rv = REReplace(local.rv, ":::\w+:::", "([^\./]+)", "all");
	local.rv = REReplace(local.rv, "^\/*(.*)\/*$", "^\1/?$");

	// Escape any forward slashes.
	local.rv = REReplace(local.rv, "(\/|\\\/)", "\/", "all");

	return local.rv;
}

/**
 * Internal function.
 * Pull list of variables out of route pattern.
 */
public string function $stripRouteVariables(required string pattern) {
	local.matchArray = ArrayToList(REMatch("\[\*?(\w+)\]", arguments.pattern));
	return REReplace(local.matchArray, "[\*\[\]]", "", "all");
}

/**
 * Private internal function.
 * Add route to Wheels, removing useless params.
 */
private void function $addRoute(
	required string pattern, required struct constraints) {

	// Remove controller and action if they are route variables.
	if (Find("[controller]", arguments.pattern) && StructKeyExists(arguments, "controller")) {
		StructDelete(arguments, "controller");
	}
	if (Find("[action]", arguments.pattern) && StructKeyExists(arguments, "action")) {
		StructDelete(arguments, "action");
	}

	// Normalize pattern, convert to regex, and strip out variable names.
	arguments.pattern = $normalizePattern(arguments.pattern);
	arguments.regex = $patternToRegex(arguments.pattern, arguments.constraints);
	arguments.variables = $stripRouteVariables(arguments.pattern);

	// compile our regex to make sure the developer is using proper regex
	$compileRegex(argumentCollection=arguments);

	// add route to Wheels
	ArrayAppend(application[$appKey()].routes, arguments);

}

/**
 * Private internal function.
 * Get member name if defined.
 */
private string function $member() {
	return StructKeyExists(variables.scopeStack[1], "member") ? variables.scopeStack[1].member : "";
}

/**
 * Private internal function.
 * Get collection name if defined.
 */
private string function $collection() {
	return StructKeyExists(variables.scopeStack[1], "collection") ? variables.scopeStack[1].collection : "";
}

/**
 * Private internal function.
 * Get scoped route name if defined.
 */
private string function $scopeName() {
	return StructKeyExists(variables.scopeStack[1], "name") ? variables.scopeStack[1].name : "";
}

/**
 * Private internal function.
 * See if resource is shallow.
 */
private boolean function $shallow() {
	return StructKeyExists(variables.scopeStack[1], "shallow") && variables.scopeStack[1].shallow == true;
}

/**
 * Private internal function.
 * Get scoped shallow route name if defined.
 */
private string function $shallowName() {
	return StructKeyExists(variables.scopeStack[1], "shallowName") ? variables.scopeStack[1].shallowName : "";
}

/**
 * Private internal function.
 * Get scoped shallow path if defined.
 */
private string function $shallowPath() {
	return StructKeyExists(variables.scopeStack[1], "shallowPath") ? variables.scopeStack[1].shallowPath : "";
}

/**
 * Private internal function.
 */
private string function $shallowNameForCall() {
	if (ListFindNoCase("collection,new", variables.scopeStack[1].$call) && StructKeyExists(variables.scopeStack[1], "parentResource")) {
		return ListAppend($shallowName(), variables.scopeStack[1].parentResource.member);
	}
	return $shallowName();
}

/**
 * Private internal function.
 */
private string function $shallowPathForCall() {
	local.path = "";
	switch (variables.scopeStack[1].$call) {
		case "member":
			local.path = variables.scopeStack[1].memberPath;
			break;
		case "collection":
		case "new":
			if (StructKeyExists(variables.scopeStack[1], "parentResource")) {
				local.path = variables.scopeStack[1].parentResource.nestedPath;
			}
			local.path &= "/" & variables.scopeStack[1].collectionPath;
			break;
	}
	return $shallowPath() & "/" & local.path;
}

/**
 * Private internal function.
 */
private void function $resetScopeStack() {
	variables.scopeStack = [];
	ArrayPrepend(variables.scopeStack, {});
	variables.scopeStack[1].$call = "$draw";
}

</cfscript>
