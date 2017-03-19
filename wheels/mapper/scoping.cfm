<cfscript>

/**
	* Set certain parameters for future calls
	* @param  {string}  name          Named route prefix
	* @param  {string}  path          Path prefix
	* @param  {string}  module        Namespace to append to controllers
	* @param  {string}  controller    Controller to use in routes
	* @param  {boolean} shallow       Turn on shallow resources
	* @param  {string}  shallowPath   Shallow path prefix
	* @param  {string}  shallowName   Shallow name prefix
	* @param  {struct}  constraints   Variable patterns to use for matching
	* @param  {string}  $call
	* @return {struct}
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
	if (!ListFindNoCase("resource,resources", scopeStack[1].$call)) {
		if (!StructKeyExists(arguments, "shallowPath") && StructKeyExists(arguments, "path")) {
			arguments.shallowPath = arguments.path;
		}
		if (!StructKeyExists(arguments, "shallowName") && StructKeyExists(arguments, "name")) {
			arguments.shallowName = arguments.name;
		}
	}

	// Combine path with scope path.
	if (StructKeyExists(scopeStack[1], "path") && StructKeyExists(arguments, "path")) {
		arguments.path = normalizePattern(scopeStack[1].path & "/" & arguments.path);
	}

	// Combine module with scope module.
	if (StructKeyExists(scopeStack[1], "module") && StructKeyExists(arguments, "module")) {
		arguments.module = scopeStack[1].module & "." & arguments.module;
	}

	// combine name with scope name
	if (StructKeyExists(arguments, "name") && StructKeyExists(scopeStack[1], "name")) {
		arguments.name = scopeStack[1].name & capitalize(arguments.name);
	}

	// Combine shallow path with scope shallow path.
	if (StructKeyExists(scopeStack[1], "shallowPath") && StructKeyExists(arguments, "shallowPath")) {
		arguments.shallowPath = normalizePattern(scopeStack[1].shallowPath & "/" & arguments.shallowPath);
	}

	// Copy existing constraints if they were previously set.
	if (StructKeyExists(scopeStack[1], "constraints") && StructKeyExists(arguments, "constraints")) {
		StructAppend(arguments.constraints, scopeStack[1].constraints, false);
	}

	// Put scope arguments on the stack.
	StructAppend(arguments, scopeStack[1], false);
	ArrayPrepend(scopeStack, arguments);

	return this;
}

/**
 * Internal function.
 */
public struct function namespace(
	required string module,
	string name=arguments.module,
	string path=hyphenize(arguments.module)
) {
	return scope(argumentCollection=arguments, $call="namespace");
}

/**
 * Internal function.
 */
public struct function $controller(
	required string controller,
	string name=arguments.controller,
	string path=hyphenize(arguments.controller)
) {
	return scope(argumentCollection=arguments, $call="controller");
}

/**
 * Internal function.
 * Set variable patterns to use for matching.
 */
public struct function constraints() {
	return scope(constraints=arguments, $call="constraints");
}

</cfscript>
