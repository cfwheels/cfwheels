<cfscript>

/**
 * Internal function.
 */
public struct function $draw(boolean restful=true, boolean methods=arguments.restful) {
	variables.restful = arguments.restful;
	variables.methods = arguments.restful || arguments.methods;

	// Start with clean scope stack that is locked for race conditions.
	$simpleLock(name="mapper.reset", timeout=5, type="exclusive", execute="$resetScopeStack");

	return this;
}

/**
 * Call this to end a nested routing block or the entire route configuration. This method is chained on a sequence of routing mapper method calls started by `mapper()`.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function end() {
	// If last action was a plural resource, set up its RESTful routes.
	if (variables.scopeStack[1].$call == "resources") {
		collection();

		if (ListFind(variables.scopeStack[1].actions, "index")) {
			get(pattern="(.[format])", action="index");
		}
		if (ListFindNoCase(variables.scopeStack[1].actions, "create")) {
			post(pattern="(.[format])", action="create");
		}

		end();

		if (ListFindNoCase(variables.scopeStack[1].actions, "new")) {
			scope(path=variables.scopeStack[1].collectionPath, $call="new");
			get(pattern="new(.[format])", action="new", name="new");
			end();
		}

		member();

		if (ListFind(variables.scopeStack[1].actions, "edit")) {
			get(pattern="edit(.[format])", action="edit", name="edit");
		}
		if (ListFind(variables.scopeStack[1].actions, "show")) {
			get(pattern="(.[format])", action="show");
		}
		if (ListFind(variables.scopeStack[1].actions, "update")) {
			patch(pattern="(.[format])", action="update");
			put(pattern="(.[format])", action="update");
		}
		if (ListFind(variables.scopeStack[1].actions, "delete")) {
			delete(pattern="(.[format])", action="delete");
		}

		end();
	// If last action was a singular resource, set up its RESTful routes.
	} else if (variables.scopeStack[1].$call == "resource") {
		if (ListFind(variables.scopeStack[1].actions, "create")) {
			collection();
			post(pattern="(.[format])", action="create");
			end();
		}

		if (ListFind(variables.scopeStack[1].actions, "new")) {
			scope(path=variables.scopeStack[1].memberPath, $call="new");
			get(pattern="new(.[format])", action="new", name="new");
			end();
		}

		member();

		if (ListFind(variables.scopeStack[1].actions, "edit")) {
			get(pattern="edit(.[format])", action="edit", name="edit");
		}
		if (ListFind(variables.scopeStack[1].actions, "show")) {
			get(pattern="(.[format])", action="show");
		}
		if (ListFind(variables.scopeStack[1].actions, "update")) {
			patch(pattern="(.[format])", action="update");
			put(pattern="(.[format])", action="update");
		}
		if (ListFind(variables.scopeStack[1].actions, "delete")) {
			delete(pattern="(.[format])", action="delete");
		}

		end();
	}

	// Remove top of stack to end nesting.
	ArrayDeleteAt(variables.scopeStack, 1);

	return this;
}

</cfscript>
