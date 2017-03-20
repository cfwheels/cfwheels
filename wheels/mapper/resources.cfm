<cfscript>

/**
 * Set up a singular REST resource.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name Name of resource.
 * @nested Whether or not additional calls will be nested.
 * @path Path for resource.
 * @controller Override controller used by resource.
 * @singular Override singularize() result in plural resources.
 * @plural Override pluralize() result in singular resource.
 * @only List of REST routes to generate.
 * @except List of REST routes not to generate, takes priority over only.
 * @shallow Turn on shallow resources.
 * @shallowPath Shallow path prefix.
 * @shallowName Shallow name prefix.
 * @constraints Variable patterns to use for matching.
 */
public struct function resource(
	required string name,
	boolean nested=false,
	string path=hyphenize(arguments.name),
	string controller,
	string singular,
	string plural,
	string only,
	string except,
	boolean shallow,
	string shallowPath,
	string shallowName,
	struct constraints,
	string $call="resource",
	boolean $plural=false
) {
	local.args = {};

	// If name is a list, add each of the resources in the list.
	if (Find(",", arguments.name)) {

		// Error if the user asked for a nested resource.
		if (arguments.nested) {
			Throw(type="Wheels.InvalidResource", message="Multiple resources in same declaration cannot be nested.");
		}

		// Remove path so new resources do not break.
		StructDelete(arguments, "path");

		// Build each new resource.
		local.names = ListToArray(arguments.name);
		local.iEnd = ArrayLen(local.names);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			resource(name=local.names[local.i], argumentCollection=arguments);
		}
		return this;
	}

	if (arguments.$plural) {

		// Setup singular and plural words.
		if (!StructKeyExists(arguments, "singular")) {
			arguments.singular = singularize(arguments.name);
		}
		arguments.plural = arguments.name;

		// Set collection and scoped paths.
		local.args.collection = arguments.plural;
		local.args.nestedPath = "#arguments.path#/[#arguments.singular#Key]";
		local.args.memberPath = "#arguments.path#/[key]";

		// For uncountable plurals, append "Index".
		if (arguments.singular == arguments.plural) {
			local.args.collection &= "Index";
		}

		local.args.actions = "index,new,create,show,edit,update,delete";
	} else {

		// Setup singular and plural words.
		arguments.singular = arguments.name;
		if (!StructKeyExists(arguments, "plural")) {
			arguments.plural = pluralize(arguments.name);
		}

		// Set collection and scoped paths.
		local.args.collection = arguments.singular;
		local.args.memberPath = arguments.path;
		local.args.nestedPath = arguments.path;

		local.args.actions = "new,create,show,edit,update,delete";
	}
	local.args.member = arguments.singular;
	local.args.collectionPath = arguments.path;

	// Consider only / except REST routes for resources.
	// Allow arguments.only to override local.args.only.
	if (StructKeyExists(arguments, "only") && ListLen(arguments.only) > 0) {
		local.args.actions = LCase(arguments.only);
	}

	// Remove unwanted routes from local.args.only.
	if (StructKeyExists(arguments, "except") && ListLen(arguments.except) > 0) {
		local.except = ListToArray(arguments.except);
		local.iEnd = ArrayLen(local.except);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.args.actions = REReplace(local.args.actions, "\b#local.except[local.i]#\b(,?|$)", "");
		}
	}

	// If controller name was passed, use it.
	// Else, set controller name based on naming preference
	if (StructKeyExists(arguments, "controller")) {
		local.args.controller = arguments.controller;
	} else {
		switch (get("resourceControllerNaming")) {
			case "name":
				local.args.controller = arguments.name;
				break;
			case "singular":
				local.args.controller = arguments.singular;
				break;
			default:
				local.args.controller = arguments.plural;
		}
	}

	// If parent resource is found.
	if (StructKeyExists(variables.scopeStack[1], "member")) {

		// Use member and nested path.
		local.args.name = variables.scopeStack[1].member;
		local.args.path = variables.scopeStack[1].nestedPath;

		// Store parent resource (and avoid too deep nesting).
		local.args.parentResource = Duplicate(variables.scopeStack[1]);
		if (StructKeyExists(local.args.parentResource, "parentResource")) {
			StructDelete(local.args.parentResource, "parentResource");
		}

	}

	// Pass along shallow route options.
	if (StructKeyExists(arguments, "shallow")) {
		local.args.shallow = arguments.shallow;
	}
	if (StructKeyExists(arguments, "shallowPath")) {
		local.args.shallowPath = arguments.shallowPath;
	}
	if (StructKeyExists(arguments, "shallowName")) {
		local.args.shallowName = arguments.shallowName;
	}

	// Pass along constraints.
	if (StructKeyExists(arguments, "constraints")) {
		local.args.constraints = arguments.constraints;
	}

	// Scope the resource.
	scope($call=arguments.$call, argumentCollection=local.args);

	// Call end() automatically unless this is a nested call.
	// See 'end()' source for the resource routes logic.
	if (!arguments.nested) {
		end();
	}

	return this;
}

/**
 * Set up a plural REST resource.
 *
 * [section: Configuration]
 * [category: Routing]
 *
 * @name See documentation for [doc:resource].
 * @nested See documentation for [doc:resource].
 * @path See documentation for [doc:resource].
 * @controller See documentation for [doc:resource].
 * @singular See documentation for [doc:resource].
 * @plural See documentation for [doc:resource].
 * @only See documentation for [doc:resource].
 * @except See documentation for [doc:resource].
 * @shallow See documentation for [doc:resource].
 * @shallowPath See documentation for [doc:resource].
 * @shallowName See documentation for [doc:resource].
 * @constraints See documentation for [doc:resource].
 */
public struct function resources(required string name, boolean nested=false) {
	return resource($plural=true, $call="resources", argumentCollection=arguments);
}

/**
 * Internal function.
 */
public struct function member() {
	return scope(path=variables.scopeStack[1].memberPath, $call="member");
}

/**
 * Internal function.
 */
public struct function collection() {
	return scope(path=variables.scopeStack[1].collectionPath, $call="collection");
}

</cfscript>
