<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="caches" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="time" type="numeric" required="false">
	<cfargument name="static" type="boolean" required="false">
	<cfargument name="appendToKey" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		$args(args=arguments, name="caches", combine="action/actions");
		arguments.action = $listClean(arguments.action);
		if (!Len(arguments.action))
		{
			// since no actions were passed in we assume that all actions should be cachable and indicate this with a *
			arguments.action = "*";
		}
		loc.iEnd = ListLen(arguments.action);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.action, loc.i);
			loc.action = {action=loc.item, time=arguments.time, static=arguments.static, appendToKey=arguments.appendToKey};
			$addCachableAction(loc.action);
		}
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$addCachableAction" returntype="void" access="public" output="false">
	<cfargument name="action" type="struct" required="true">
	<cfscript>
		ArrayAppend(variables.$class.cachableActions, arguments.action);
	</cfscript>
</cffunction>

<cffunction name="$clearCachableActions" returntype="void" access="public" output="false">
	<cfscript>
		ArrayClear(variables.$class.cachableActions);
	</cfscript>
</cffunction>

<cffunction name="$setCachableActions" returntype="void" access="public" output="false">
	<cfargument name="actions" type="array" required="true">
	<cfscript>
		variables.$class.cachableActions = arguments.actions;
	</cfscript>
</cffunction>

<cffunction name="$cachableActions" returntype="array" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = variables.$class.cachableActions;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$hasCachableActions" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if (ArrayIsEmpty($cachableActions()))
		{
			loc.rv = false;
		}
		else
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$cacheSettingsForAction" returntype="any" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		loc.cachableActions = $cachableActions();
		loc.iEnd = ArrayLen(loc.cachableActions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (loc.cachableActions[loc.i].action == arguments.action || loc.cachableActions[loc.i].action == "*")
			{
				loc.rv = {};
				loc.rv.time = loc.cachableActions[loc.i].time;
				loc.rv.static = loc.cachableActions[loc.i].static;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>