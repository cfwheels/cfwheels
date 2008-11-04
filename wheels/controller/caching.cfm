<cffunction name="caches" returntype="void" access="public" output="false">
	<cfargument name="actions" type="string" required="false" default="">
	<cfargument name="time" type="numeric" required="false" default="#application.settings.defaultCacheTime#">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.actions);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.actions, loc.i));
			loc.thisAction = {};
			loc.thisAction.action = loc.item;
			loc.thisAction.time = arguments.time;
			ArrayAppend(variables.wheels.cachableActions, loc.thisAction);
		}	
	</cfscript>
</cffunction>

<cffunction name="$getCachableActions" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.cachableActions>
</cffunction>