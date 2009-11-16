<cfscript>
	// load the routes that handle controller / action / key type URLs unless the developer has specified to not load them
	if (application.wheels.loadDefaultRoutes)
	{
		loc.route = {pattern="[controller]/[action]/[key]"};
		ArrayAppend(application.wheels.routes, loc.route);
		loc.route = {pattern="[controller]/[action]"};
		ArrayAppend(application.wheels.routes, loc.route);
		loc.route = {pattern="[controller]", action="index"};
		ArrayAppend(application.wheels.routes, loc.route);
	}
	loc.iEnd = ArrayLen(application.wheels.routes);
	for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
	{
		loc.route = application.wheels.routes[loc.i];
		if (StructKeyExists(loc.route, "name"))
		{
			if (!StructKeyExists(application.wheels.namedRoutePositions, loc.route.name))
				application.wheels.namedRoutePositions[loc.route.name] = "";
			application.wheels.namedRoutePositions[loc.route.name] = ListAppend(application.wheels.namedRoutePositions[loc.route.name], loc.i);
		}
	}
</cfscript>