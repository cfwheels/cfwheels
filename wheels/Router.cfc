<cfcomponent output="false">

	<cfinclude template="global/cfml.cfm">
	<cfinclude template="plugins/injection.cfm">

	<cffunction name="init">
		<cfset REGEX_VARIABLES = "\[[^\]]*\]">
		<cfset $reload()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add" returntype="void" access="public" output="false" hint="Adds a new route to your application."
		examples=
		'
			<!--- Adds a route which will invoke the `profile` action on the `user` controller with `params.userName` set when the URL matches the `pattern` argument --->
			<cfset add(name="userProfile", pattern="user/[username]", controller="user", action="profile")>
		'
		categories="configuration" chapters="using-routes" functions="">
		<cfargument name="name" type="string" required="false" default="" hint="Name for the route.">
		<cfargument name="pattern" type="string" required="true" hint="The URL pattern for the route.">
		<cfargument name="controller" type="string" required="false" default="" hint="Controller to call when route matches (unless the controller name exists in the pattern).">
		<cfargument name="action" type="string" required="false" default="" hint="Action to call when route matches (unless the action name exists in the pattern).">
		<cfscript>
			var loc = {};
	
			// throw errors when controller or action is not passed in as arguments and not included in the pattern
			if (!Len(arguments.controller) && arguments.pattern Does Not Contain "[controller]")
				$throw(type="Wheels.IncorrectArguments", message="The `controller` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `controller` argument to specifically tell Wheels which controller to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
			if (!Len(arguments.action) && arguments.pattern Does Not Contain "[action]")
				$throw(type="Wheels.IncorrectArguments", message="The `action` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `action` argument to specifically tell Wheels which action to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
	
			$save(argumentCollection=arguments);
		</cfscript>
	</cffunction>
	
	<cffunction name="search" returntype="struct" access="public" output="false">
		<cfargument name="route" type="string" required="true">
		<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(routes.mapped);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.currentRoute = routes.mapped[loc.i].pattern;
			if (arguments.route == "" && loc.currentRoute == "")
			{
				loc.returnValue = routes.mapped[loc.i];
				break;
			}
			else
			{
				if (ListLen(arguments.route, "/") >= ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
				{
					loc.match = true;
					loc.jEnd = ListLen(loc.currentRoute, "/");
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
					{
						loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
						loc.thisRoute = ReplaceList(loc.item, "[,]", ",");
						loc.thisURL = ListGetAt(arguments.route, loc.j, "/");
						if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisURL)
							loc.match = false;
					}
					if (loc.match)
					{
						loc.returnValue = routes.mapped[loc.i];
						break;
					}
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your `config/routes.cfm` file that matches the `#arguments.route#` request.");
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="searchNamed" returntype="struct" access="public" output="false">
		<cfargument name="route" type="string" required="true">
		<cfscript>
			var loc = {};
			
			// throw an error if a route with this name has not been set by developer in the config/routes.cfm file
			if (application.wheels.showErrorInformation && !StructKeyExists(routes.named, arguments.route))
				$throw(type="Wheels.RouteNotFound", message="Could not find the `#arguments.route#` route.", extendedInfo="Create a new route in `config/routes.cfm` with the name `#arguments.route#`.");
	
			loc.routePos = routes.named[arguments.route];
			if (loc.routePos Contains ",")
			{
				// there are several routes with this name so we need to figure out which one to use by checking the passed in arguments
				loc.iEnd = ListLen(loc.routePos);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.returnValue = routes.mapped[ListGetAt(loc.routePos, loc.i)];
					loc.foundRoute = true;
					loc.jEnd = ListLen(loc.returnValue.variables);
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
					{
						loc.variable = ListGetAt(loc.returnValue.variables, loc.j);
						if (!StructKeyExists(arguments, loc.variable) || !Len(arguments[loc.variable]))
							loc.foundRoute = false;
					}
					if (loc.foundRoute)
						break;
				}
			}
			else
			{
				loc.returnValue = routes.mapped[loc.routePos];
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="$reload">
		<cfscript>
		routes = {};
		routes.mapped = [];
		routes.named = {};
		</cfscript>
	</cffunction>
	
	<cffunction name="$save">
		<cfscript>
		var loc = {};
		loc.thisRoute = Duplicate(arguments);
		loc.thisRoute.variables = [];
		loc.vars = ReMatchNoCase(REGEX_VARIABLES, arguments.pattern);
		if (!ArrayIsEmpty(loc.vars))
		{
			loc.iEnd = ArrayLen(loc.vars);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				ArrayAppend(loc.thisRoute.variables, ReplaceList(loc.vars[loc.i], "[,]", ""));
			}
		}
		loc.thisRoute.variables = ArrayToList(loc.thisRoute.variables);
		ArrayAppend(routes.mapped, loc.thisRoute);
		loc.numRoutes = ArrayLen(routes.mapped);
		
		// store a reference to the name for the route if passed
		if (StructKeyExists(loc.thisRoute, "name") && len(loc.thisRoute.name))
		{
			if (!StructKeyExists(routes.named, loc.thisRoute.name))
				routes.named[loc.thisRoute.name] = "";
			routes.named[loc.thisRoute.name] = ListAppend(routes.named[loc.thisRoute.name], loc.numRoutes);
		}
		</cfscript>
	</cffunction>
	
	<cffunction name="$inspect">
		<cfreturn duplicate(variables)>
	</cffunction>
	
	<cffunction name="$getRoutes">
		<cfreturn duplicate(variables.routes)>
	</cffunction>
	
	<cffunction name="$setRoutes">
		<cfargument name="routes" type="struct" required="true">
		<cfset variables.routes = arguments.routes>
	</cffunction>
	
</cfcomponent>