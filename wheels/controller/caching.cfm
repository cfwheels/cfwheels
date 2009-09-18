<cffunction name="caches" returntype="void" access="public" output="false" hint="Tells Wheels to cache one or more actions.">
	<cfargument name="actions" type="string" required="false" default="" hint="Action(s) to cache (can also be called with the `action` argument)">
	<cfargument name="time" type="numeric" required="false" default="#application.wheels.functions.caches.time#" hint="Minutes to cache the action(s) for">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "action") && !Len(arguments.actions))
			arguments.actions = argument.action;
		loc.iEnd = ListLen(arguments.actions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.actions, loc.i));
			loc.thisAction = {action=loc.item, time=arguments.time};
			ArrayAppend(variables.wheels.cachableActions, loc.thisAction);
		}	
	</cfscript>
</cffunction>

<cffunction name="$getCachableActions" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.cachableActions>
</cffunction>