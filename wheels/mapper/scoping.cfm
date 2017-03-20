<cfscript>

/**
 * Set certain parameters for future calls.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name Named route prefix.
 * @path Path prefix.
 * @module Namespace to append to controllers.
 * @controller Controller to use in routes.
 * @shallow Turn on shallow resources.
 * @shallowPath Shallow path prefix.
 * @shallowName Shallow name prefix.
 * @constraints Variable patterns to use for matching.
 */
public struct function scope(
	string name,
	string path,
	string module,
	string controller,
	boolean shallow,
	string shallowPath,
	string shallowName,
	struct constraints,
	string $call="scope"
) {

	// Set shallow path and prefix if not in a resource.
	if (!ListFindNoCase("resource,resources", variables.scopeStack[1].$call)) {
		if (!StructKeyExists(arguments, "shallowPath") && StructKeyExists(arguments, "path")) {
			arguments.shallowPath = arguments.path;
		}
		if (!StructKeyExists(arguments, "shallowName") && StructKeyExists(arguments, "name")) {
			arguments.shallowName = arguments.name;
		}
	}

	// Combine path with scope path.
	if (StructKeyExists(variables.scopeStack[1], "path") && StructKeyExists(arguments, "path")) {
		arguments.path = normalizePattern(variables.scopeStack[1].path & "/" & arguments.path);
	}

	// Combine module with scope module.
	if (StructKeyExists(variables.scopeStack[1], "module") && StructKeyExists(arguments, "module")) {
		arguments.module = variables.scopeStack[1].module & "." & arguments.module;
	}

	// Combine name with scope name.
	if (StructKeyExists(arguments, "name") && StructKeyExists(variables.scopeStack[1], "name")) {
		arguments.name = variables.scopeStack[1].name & capitalize(arguments.name);
	}

	// Combine shallow path with scope shallow path.
	if (StructKeyExists(variables.scopeStack[1], "shallowPath") && StructKeyExists(arguments, "shallowPath")) {
		arguments.shallowPath = normalizePattern(variables.scopeStack[1].shallowPath & "/" & arguments.shallowPath);
	}

	// Copy existing constraints if they were previously set.
	if (StructKeyExists(variables.scopeStack[1], "constraints") && StructKeyExists(arguments, "constraints")) {
		StructAppend(arguments.constraints, variables.scopeStack[1].constraints, false);
	}

	// Put scope arguments on the stack.
	StructAppend(arguments, variables.scopeStack[1], false);
	ArrayPrepend(variables.scopeStack, arguments);

	return this;
}

/**
 * ???.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function namespace(
	required string module,
	string name=arguments.module,
	string path=hyphenize(arguments.module)
) {
	return scope(argumentCollection=arguments, $call="namespace");
}

/**
 * ???.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function controller(
	required string controller,
	string name=arguments.controller,
	string path=hyphenize(arguments.controller)
) {
	return scope(argumentCollection=arguments, $call="controller");
}

/**
 * Set variable patterns to use for matching.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function constraints() {
	return scope(constraints=arguments, $call="constraints");
}

</cfscript>
