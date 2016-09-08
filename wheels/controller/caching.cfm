<cfscript>

// PUBLIC CONTROLLER INITIALIZATION FUNCTIONS

public void function caches(string action = "", numeric time, boolean static, string appendToKey = "") {
	$args(args=arguments, name="caches", combine="action/actions");
	arguments.action = $listClean(arguments.action);

	// When no actions are passed in we assume that all actions should be cachable and indicate this with a *
	if (!Len(arguments.action)) {
		arguments.action = "*";
	}

	local.iEnd = ListLen(arguments.action);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.action, local.i);
		local.action = {action=local.item, time=arguments.time, static=arguments.static, appendToKey=arguments.appendToKey};
		$addCachableAction(local.action);
	}
}

// INTERNAL FUNCTIONS

public void function $addCachableAction(required struct action) {
	ArrayAppend(variables.$class.cachableActions, arguments.action);
}

public void function $clearCachableActions() {
	ArrayClear(variables.$class.cachableActions);
}

public void function $setCachableActions(required array actions) {
	variables.$class.cachableActions = arguments.actions;
}

public array function $cachableActions() {
	return variables.$class.cachableActions;
}

public boolean function $hasCachableActions() {
	if (ArrayIsEmpty($cachableActions())) {
		return false;
	} else {
		return true;
	}
}

public any function $cacheSettingsForAction(required string action) {
	local.rv = false;
	local.cachableActions = $cachableActions();
	local.iEnd = ArrayLen(local.cachableActions);
	for (local.i=1; local.i <= local.iEnd; local.i++) {
		if (local.cachableActions[local.i].action == arguments.action || local.cachableActions[local.i].action == "*") {
			local.rv = {};
			local.rv.time = local.cachableActions[local.i].time;
			local.rv.static = local.cachableActions[local.i].static;
		}
	}
	return local.rv;
}

</cfscript>