<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="caches" returntype="void" access="public" output="false" hint="Tells CFWheels to cache one or more actions."
	examples=
	'
		// Cache the `termsOfUse` action
		caches("termsOfUse");

		// Cache the `termsOfUse` action for 30 minutes
		caches(actions="browseByUser,browseByTitle", time=30);

		// Cache the `termsOfUse` and `codeOfConduct` actions, including their filters
		caches(actions="termsOfUse,codeOfConduct", static=true);

		// Cache content separately based on region
		caches(action="home", key="request.region");
	'
	categories="controller-initialization,caching" chapters="caching" functions="">
	<cfargument name="action" type="string" required="false" default="" hint="Action(s) to cache. This argument is also aliased as `actions`.">
	<cfargument name="time" type="numeric" required="false" hint="Minutes to cache the action(s) for.">
	<cfargument name="static" type="boolean" required="false" hint="Set to `true` to tell CFWheels that this is a static page and that it can skip running the controller filters (before and after filters set on actions). Please note that the `onSessionStart` and `onRequestStart` events still execute though.">
	<cfargument name="appendToKey" type="string" required="false" hint="List of variables to be evaluated at runtime and included in the cache key so that content can be cached separately.">
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