<cfscript>
	loc.route = {pattern="[controller]/[action]/[key]"};
	ArrayAppend(application.wheels.routes, loc.route);
	loc.route = {pattern="[controller]/[action]"};
	ArrayAppend(application.wheels.routes, loc.route);
	loc.route = {pattern="[controller]", action="index"};
	ArrayAppend(application.wheels.routes, loc.route);
	loc.iEnd = ArrayLen(application.wheels.routes);
	for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
	{
		loc.route = application.wheels.routes[loc.i];
		if (StructKeyExists(loc.route, "name"))
			application.wheels.namedRoutePositions[loc.route.name] = loc.i;
	}
</cfscript>