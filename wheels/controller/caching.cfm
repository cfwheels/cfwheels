<cfscript>

/**
 * Tells CFWheels to cache one or more actions.
 *
 * @doc.section Controller
 * @doc.category Initialization Functions
 * @doc.test wheels/tests/controller/caching/caches.cfc
 *
 */
public void function caches(string action="", numeric time, boolean static, string appendToKey="") {
	$args(args=arguments, name="caches", combine="action/actions");
	arguments.action = $listClean(arguments.action);

	// When no actions are passed in we assume that all actions should be cachable and indicate this with a *.
	if (!Len(arguments.action)) {
		arguments.action = "*";
	}

	local.iEnd = ListLen(arguments.action);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.action, local.i);
		local.action = {
			action = local.item,
			time = arguments.time,
			static = arguments.static,
			appendToKey = arguments.appendToKey
		};
		$addCachableAction(local.action);
	}
}

/**
 * Internal function.
 * Called from the caches function.
 * Tests: wheels/tests/controller/caching/$addcachableaction.cfc
 */
public void function $addCachableAction(required struct action) {
	ArrayAppend(variables.$class.cachableActions, arguments.action);
}

/**
 * Internal function.
 * Called when processing a request, and from other functions in this file, to get all cachable actions.
 * Tests: wheels/tests/controller/caching/$cachableactions.cfc
 */
public array function $cachableActions() {
	return variables.$class.cachableActions;
}

/**
 * Internal function.
 * Get cache info, only called from the test suite
 * Tests: wheels/tests/controller/caching/$cachesettingsforaction.cfc
 */
public any function $cacheSettingsForAction(required string action) {
	local.rv = false;
	local.cachableActions = $cachableActions();
	local.iEnd = ArrayLen(local.cachableActions);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		if (local.cachableActions[local.i].action == arguments.action || local.cachableActions[local.i].action == "*") {
			local.rv = {};
			local.rv.time = local.cachableActions[local.i].time;
			local.rv.static = local.cachableActions[local.i].static;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 * Delete all cache info, only called from the test suite.
 * Tests: wheels/tests/controller/caching/$clearcachableactions.cfc
 */
public void function $clearCachableActions() {
	ArrayClear(variables.$class.cachableActions);
}

/**
 * Internal function.
 * Called when processing a request to see if any actions are cachable.
 * Tests: wheels/tests/controller/caching/$hascachableactions.cfc
 */
public boolean function $hasCachableActions() {
	if (ArrayIsEmpty($cachableActions())) {
		return false;
	} else {
		return true;
	}
}

/**
 * Internal function
 * Set cache info, only called from the test suite.
 * Tests: wheels/tests/controller/caching/$setcachableactions.cfc
 */
public void function $setCachableActions(required array actions) {
	variables.$class.cachableActions = arguments.actions;
}

</cfscript>
