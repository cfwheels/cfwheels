<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="caches" returntype="void" access="public" output="false" hint="Tells Wheels to cache one or more actions."
	examples=
	'
		<cfset caches(actions="browseByUser,browseByTitle", time=30)>
	'
	categories="controller-initialization" chapters="caching" functions="">
	<cfargument name="actions" type="string" required="false" default="" hint="Action(s) to cache (can also be called with the `action` argument).">
	<cfargument name="time" type="numeric" required="false" hint="Minutes to cache the action(s) for.">
	<cfargument name="static" type="boolean" required="false" hint="Set to `true` to tell Wheels that this is a static page and that it can skip running the controller filters (before and after filters set on actions) and application events (onSessionStart, onRequestStart etc).">
	<cfscript>
		var loc = {};
		$insertDefaults(name="caches", input=arguments);
		arguments = $combineArguments(args=arguments, combine="actions,action", required=false);
		if (!Len(arguments.actions))
		{
			// since no actions were passed in we assume that all actions should be cachable and indicate this with a *
			arguments.actions = "*";
		}
		loc.iEnd = ListLen(arguments.actions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.actions, loc.i));
			loc.action = {action=loc.item, time=arguments.time, static=arguments.static};
			ArrayAppend(variables.wheels.cachableActions, loc.action);
		}
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$cacheSettingsForAction" returntype="any" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		loc.cachableActions = variables.wheels.cachableActions;
		loc.iEnd = ArrayLen(loc.cachableActions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (loc.cachableActions[loc.i].action == arguments.action || loc.cachableActions[loc.i].action == "*")
			{
				loc.returnValue = {};			
				loc.returnValue.time = loc.cachableActions[loc.i].time;
				loc.returnValue.static = loc.cachableActions[loc.i].static;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>