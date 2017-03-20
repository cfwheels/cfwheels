<cfscript>

/**
 * Match a url.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name Name for route. Used for path helpers.
 * @pattern Pattern to match for route.
 * @to Set controller##action for route.
 * @methods HTTP verbs that match route.
 * @module Namespace to append to controller.
 * @on Created resource route under "member" or "collection".
 */
public struct function match(
	string name,
	string pattern,
	string to,
	string methods,
	string module,
	string on,
	struct constraints={}
) {

	// Evaluate match on member or collection.
	if (StructKeyExists(arguments, "on")) {
		if (arguments.on == "member") {
			return member().match(argumentCollection=arguments, on="").end();
		}
		if (arguments.on == "collection") {
			return collection().match(argumentCollection=arguments, on="").end();
		}
	}

	// Use scoped controller if found.
	if (StructKeyExists(variables.scopeStack[1], "controller") && !StructKeyExists(arguments, "controller")) {
		arguments.controller = variables.scopeStack[1].controller;
	}

	// Use scoped module if found.
	if (StructKeyExists(variables.scopeStack[1], "module")) {
		if (StructKeyExists(arguments, "module")) {
			arguments.module &= "." & variables.scopeStack[1].module;
		} else {
			arguments.module = variables.scopeStack[1].module;
		}
	}

	// Interpret "to" as "controller##action".
	if (StructKeyExists(arguments, "to")) {
		arguments.controller = ListFirst(arguments.to, "##");
		arguments.action = ListLast(arguments.to, "##");
		StructDelete(arguments, "to");
	}

	// Pull route name from arguments if it exists.
	local.name = "";
	if (StructKeyExists(arguments, "name")) {
		local.name = arguments.name;

		// Guess pattern and/or action.
		if (!StructKeyExists(arguments, "pattern")) {
			arguments.pattern = hyphenize(arguments.name);
		}
		if (!StructKeyExists(arguments, "action") && !Find("[action]", arguments.pattern)) {
			arguments.action = arguments.name;
		}

	}

	// Die if pattern is not defined.
	if (!StructKeyExists(arguments, "pattern")) {
		Throw(type="Wheels.MapperArgumentMissing", message="Either 'pattern' or 'name' must be defined.");
	}

	// Accept either "method" or "methods".
	if (StructKeyExists(arguments, "method")) {
		arguments.methods = arguments.method;
		StructDelete(arguments, "method");
	}

	// Remove 'methods' argument if settings disable it.
	if (!variables.methods && StructKeyExists(arguments, "methods")) {
		StructDelete(arguments, "methods");
	}

	// See if we have any globing in the pattern and if so add a constraint for each glob.
	if (REFindNoCase("\*([^\/]+)", arguments.pattern)) {
		local.globs = REMatch("\*([^\/]+)", arguments.pattern);
		for (local.glob in local.globs) {
			local.var = replaceList(local.glob, "*,[,]", "");
			arguments.pattern = replace(arguments.pattern, local.glob, "[#local.var#]");
			arguments.constraints[local.var] = ".*";
		}
	}

	// Use constraints from stack.
	if (StructKeyExists(variables.scopeStack[1], "constraints")) {
		StructAppend(arguments.constraints, variables.scopeStack[1].constraints, false);
	}

	// Add shallow path to pattern.
	// Or, add scoped path to pattern.
	if ($shallow()) {
		arguments.pattern = $shallowPathForCall() & "/" & arguments.pattern;
	} else if (StructKeyExists(variables.scopeStack[1], "path")) {
		arguments.pattern = variables.scopeStack[1].path & "/" & arguments.pattern;
	}

	// If both module and controller are set, combine them.
	if (StructKeyExists(arguments, "module") && StructKeyExists(arguments, "controller")) {
		arguments.controller = arguments.module & "." & arguments.controller;
		StructDelete(arguments, "module");
	}

	// Build named routes in correct order according to rails conventions.
	switch (variables.scopeStack[1].$call) {
		case "resource":
		case "resources":
		case "collection":
			local.nameStruct = [local.name, $shallow() ? $shallowNameForCall() : $scopeName(), $collection()];
			break;
		case "member":
		case "new":
			local.nameStruct = [local.name, $shallow() ? $shallowNameForCall() : $scopeName(), $member()];
			break;
		default:
			local.nameStruct = [$scopeName(), $collection(), local.name];
	}

	// Transform array into named route.
	local.name = ArrayToList(local.nameStruct);
	local.name = REReplace(local.name, "^,+|,+$", "", "all");
	local.name = REReplace(local.name, ",+(\w)", "\U\1", "all");
	local.name = REReplace(local.name, ",", "", "all");

	// If we have a name, add it to arguments.
	if (Len(local.name)) {
		arguments.name = local.name;
	}

	// Handle optional pattern segments.
	if (Find("(", arguments.pattern)) {

		// Confirm nesting of optional segments.
		if (REFind("\).*\(", arguments.pattern)) {
			Throw(type="Wheels.InvalidRoute", message="Optional pattern segments must be nested.");
		}

		// Strip closing parens from pattern.
		local.pattern = Replace(arguments.pattern, ")", "", "all");

		// Loop over all possible patterns.
		while (Len(local.pattern)) {

			// Add current route to Wheels.
			$addRoute(argumentCollection=arguments, pattern=Replace(local.pattern, "(", "", "all"));

			// Remove last optional segment.
			local.pattern = REReplace(local.pattern, "(^|\()[^(]+$", "");

		}

	} else {

		// Add route to Wheels as is.
		$addRoute(argumentCollection=arguments);

	}

	return this;
}

/**
 * Match a GET url.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function get(string name) {
	return match(method="get", argumentCollection=arguments);
}

/**
 * Match a POST url.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function post(string name) {
	return match(method="post", argumentCollection=arguments);
}

/**
 * Match a PUT url.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function put(string name) {
	return match(method="put", argumentCollection=arguments);
}

/**
 * Match a PATCH url.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function patch(string name) {
	return match(method="patch", argumentCollection=arguments);
}

/**
 * Match a DELETE url.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function delete(string name) {
	return match(method="delete", argumentCollection=arguments);
}

/**
 * Match a root directory.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function root(string to) {
	return match(name="root", pattern="/(.[format])", argumentCollection=arguments);
}

/**
 * Special wildcard matching.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function wildcard(string action="index") {
	if (StructKeyExists(variables.scopeStack[1], "controller")) {
		match(name="wildcard", pattern="[action]/[key](.[format])", action=arguments.action);
		match(name="wildcard", pattern="[action](.[format])", action=arguments.action);
	} else {
		match(name="wildcard", pattern="[controller]/[action]/[key](.[format])", action=arguments.action);
		match(name="wildcard", pattern="[controller](/[action](.[format]))", action=arguments.action);
	}
	return this;
}

</cfscript>
