<cfscript>

	// PUBLIC CONTROLLER INITIALIZATION FUNCTIONS

	public void function caches(string action="", numeric time, boolean static, string appendToKey="") {
		var loc = {};
		$args(args=arguments, name="caches", combine="action/actions");
		arguments.action = $listClean(arguments.action);

		// when no actions are passed in we assume that all actions should be cachable and indicate this with a *
		if (!Len(arguments.action)) {
			arguments.action = "*";
		}

		loc.iEnd = ListLen(arguments.action);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			loc.item = ListGetAt(arguments.action, loc.i);
			loc.action = {action=loc.item, time=arguments.time, static=arguments.static, appendToKey=arguments.appendToKey};
			$addCachableAction(loc.action);
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
		var loc = {};
		loc.rv = false;
		loc.cachableActions = $cachableActions();
		loc.iEnd = ArrayLen(loc.cachableActions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			if (loc.cachableActions[loc.i].action == arguments.action || loc.cachableActions[loc.i].action == "*") {
				loc.rv = {};
				loc.rv.time = loc.cachableActions[loc.i].time;
				loc.rv.static = loc.cachableActions[loc.i].static;
			}
		}
		return loc.rv;
	}
</cfscript>