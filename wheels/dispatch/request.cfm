<!--- PRIVATE FUNCTIONS --->

<cffunction name="$init" returntype="any" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = this;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = {};
		loc.rv = $mergeUrlAndFormScopes(params=loc.rv, urlScope=arguments.urlScope, formScope=arguments.formScope);
		loc.rv = $mergeRoutePattern(params=loc.rv, route=arguments.route, path=arguments.path);
		loc.rv = $decryptParams(params=loc.rv);
		loc.rv = $translateBlankCheckBoxSubmissions(params=loc.rv);
		loc.rv = $translateDatePartSubmissions(params=loc.rv);
		loc.rv = $createNestedParamStruct(params=loc.rv);

		// we now do the routing and controller params after we have built all other params so that we don't have more logic around params in arrays
		loc.rv = $ensureControllerAndAction(params=loc.rv, route=arguments.route);
		loc.rv = $addRouteFormat(params=loc.rv, route=arguments.route);
		loc.rv = $addRouteName(params=loc.rv, route=arguments.route);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$createNestedParamStruct" returntype="struct" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		for (loc.key in loc.rv)
		{
			if (Find("[", loc.key) && Right(loc.key, 1) == "]")
			{
				// object form field
				loc.name = SpanExcluding(loc.key, "[");

				// we split the key into an array so the developer can have unlimited levels of params passed in
				loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true);
				if (!StructKeyExists(loc.rv, loc.name))
				{
					loc.rv[loc.name] = {};
				}

				// we need a reference to the struct so we can nest other structs if needed
				loc.struct = loc.rv[loc.name];
				loc.iEnd = ArrayLen(loc.nested);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					// looping over the array allows for infinite nesting
					loc.item = loc.nested[loc.i];
					if (!StructKeyExists(loc.struct, loc.item))
					{
						loc.struct[loc.item] = {};
					}
					if (loc.i != loc.iEnd)
					{
						// pass the new reference (structs pass a reference instead of a copy) to the next iteration
						loc.struct = loc.struct[loc.item];
					}
					else
					{
						loc.struct[loc.item] = loc.rv[loc.key];
					}
				}
				// delete the original key so it doesn't show up in the params
				StructDelete(loc.rv, loc.key);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$findMatchingRoute" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(application.wheels.routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.format = "";
			loc.route = application.wheels.routes[loc.i];
			if (StructKeyExists(loc.route, "format"))
			{
				loc.format = loc.route.format;
			}
			loc.currentRoute = loc.route.pattern;
			if (loc.currentRoute == "*")
			{
				loc.rv = loc.route;
				break;
			}
			else if (arguments.path == "" && loc.currentRoute == "")
			{
				loc.rv = loc.route;
				break;
			}
			else if (ListLen(arguments.path, "/") >= ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
			{
				loc.match = true;
				loc.jEnd = ListLen(loc.currentRoute, "/");
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
					loc.thisRoute = ReplaceList(loc.item, "[,]", "");
					loc.thisUrl = ListFirst(ListGetAt(arguments.path, loc.j, "/"), ".");
					if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisUrl)
					{
						loc.match = false;
					}
				}
				if (loc.match)
				{
					loc.rv = loc.route;
					if (Len(loc.format))
					{
						// we need to duplicate the route here otherwise we overwrite the one in the application scope
						loc.rv = Duplicate(loc.rv);
						loc.key = ReplaceList(loc.format, "[,]", "");
						loc.rv[loc.key] = $getFormatFromRequest(pathInfo=arguments.path);
					}
					break;
				}
			}
		}
		if (!StructKeyExists(loc, "rv"))
		{
			$throw(type="Wheels.RouteNotFound", message="CFWheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your `config/routes.cfm` file that matches the `#arguments.path#` request.");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$getPathFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfargument name="scriptName" type="string" required="true">
	<cfscript>
		var loc = {};

		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
		{
			loc.rv = "";
		}
		else
		{
			loc.rv = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$getFormatFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		if (Find(".", arguments.pathInfo))
		{
			loc.rv = ListLast(arguments.pathInfo, ".");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		if (get("showDebugInformation"))
		{
			$debugPoint("setup");
		}

		loc.params = $paramParser(argumentCollection=arguments);

		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = loc.params;

		if (get("showDebugInformation"))
		{
			$debugPoint("setup");
		}

		// create the requested controller and call the action on it
		loc.controller = controller(name=loc.params.controller, params=loc.params);
		loc.controller.$processAction();

		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (loc.controller.$performedRedirect())
		{
			$location(argumentCollection=loc.controller.$getRedirect());
		}

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		loc.controller.$flashClear();

		loc.rv = loc.controller.response();
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$paramParser" returntype="struct" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		loc.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
		loc.route = $findMatchingRoute(path=loc.path);
		loc.rv = $createParams(path=loc.path, route=loc.route, formScope=arguments.formScope, urlScope=arguments.urlScope);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$mergeUrlAndFormScopes" returntype="struct" access="public" output="false" hint="Merges the URL and form scope into a single structure, URL scope has precedence.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfscript>
		StructAppend(arguments.params, arguments.formScope);
		StructAppend(arguments.params, arguments.urlScope);

		// get rid of the fieldnames
		StructDelete(arguments.params, "fieldnames");
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$mergeRoutePattern" returntype="struct" access="public" output="false" hint="Parses the route pattern, identifies the variable markers within the pattern and assigns the value from the url variables with the path.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="path" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		if (StructKeyExists(arguments.route, "format") && Len(arguments.route.format))
		{
			arguments.path = Reverse(ListRest(Reverse(arguments.path), "."));
		}
		loc.iEnd = ListLen(arguments.route.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.route.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
			{
				loc.key = ReplaceList(loc.item, "[,]", "");
				loc.rv[loc.key] = ListGetAt(arguments.path, loc.i, "/");
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$decryptParams" returntype="struct" access="public" output="false" hint="Loops through the params struct passed in and attempts to deobfuscate them. ignores the controller and action params values.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		if (get("obfuscateUrls"))
		{
			for (loc.key in loc.rv)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					try
					{
						loc.rv[loc.key] = deobfuscateParam(loc.rv[loc.key]);
					}
					catch (any e) {}
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$translateBlankCheckBoxSubmissions" returntype="struct" access="public" output="false" hint="Loops through the params struct and handle the cases where checkboxes are unchecked.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		for (loc.key in loc.rv)
		{
			if (FindNoCase("($checkbox)", loc.key))
			{
				// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to the unchecked values for the checkbox (to get around the problem that unchecked checkboxes don't post at all)
				loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
				if (!StructKeyExists(loc.rv, loc.formParamName))
				{
					loc.rv[loc.formParamName] = loc.rv[loc.key];
				}
				StructDelete(loc.rv, loc.key);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$translateDatePartSubmissions" returntype="struct" access="public" output="false" hint="Combines date parts into a single value.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		loc.dates = {};
		for (loc.key in loc.rv)
		{
			if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second|\$ampm)\)$", loc.key))
			{
				loc.temp = ListToArray(loc.key, "(");
				loc.firstKey = loc.temp[1];
				loc.secondKey = SpanExcluding(loc.temp[2], ")");
				if (!StructKeyExists(loc.dates, loc.firstKey))
				{
					loc.dates[loc.firstKey] = {};
				}
				loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = loc.rv[loc.key];
			}
		}
		for (loc.key in loc.dates)
		{
			if (!StructKeyExists(loc.dates[loc.key], "year"))
			{
				loc.dates[loc.key].year = 1899;
			}
			if (!StructKeyExists(loc.dates[loc.key], "month"))
			{
				loc.dates[loc.key].month = 1;
			}
			if (!StructKeyExists(loc.dates[loc.key], "day"))
			{
				loc.dates[loc.key].day = 1;
			}
			if (!StructKeyExists(loc.dates[loc.key], "hour"))
			{
				loc.dates[loc.key].hour = 0;
			}
			if (!StructKeyExists(loc.dates[loc.key], "minute"))
			{
				loc.dates[loc.key].minute = 0;
			}
			if (!StructKeyExists(loc.dates[loc.key], "second"))
			{
				loc.dates[loc.key].second = 0;
			}
			if (StructKeyExists(loc.dates[loc.key], "ampm"))
			{
				if (loc.dates[loc.key].ampm == "am" && loc.dates[loc.key].hour == 12)
				{
					loc.dates[loc.key].hour = 0;
				}
				else if (loc.dates[loc.key].ampm == "pm" && loc.dates[loc.key].hour != 12)
				{
					loc.dates[loc.key].hour += 12;
				}
			}
			try
			{
				loc.rv[loc.key] = CreateDateTime(loc.dates[loc.key].year, loc.dates[loc.key].month, loc.dates[loc.key].day, loc.dates[loc.key].hour, loc.dates[loc.key].minute, loc.dates[loc.key].second);
			}
			catch (any e)
			{
				loc.rv[loc.key] = "";
			}
			StructDelete(loc.rv, loc.key & "($year)");
			StructDelete(loc.rv, loc.key & "($month)");
			StructDelete(loc.rv, loc.key & "($day)");
			StructDelete(loc.rv, loc.key & "($hour)");
			StructDelete(loc.rv, loc.key & "($minute)");
			StructDelete(loc.rv, loc.key & "($second)");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$ensureControllerAndAction" returntype="struct" access="public" output="false" hint="Ensure that the controller and action params exists and camelized.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		if (!StructKeyExists(loc.rv, "controller"))
		{
			loc.rv.controller = arguments.route.controller;
		}
		if (!StructKeyExists(loc.rv, "action"))
		{
			loc.rv.action = arguments.route.action;
		}

		// filter out illegal characters from the controller and action arguments
		loc.rv.controller = ReReplace(loc.rv.controller, "[^0-9A-Za-z-_]", "", "all");
		loc.rv.action = ReReplace(loc.rv.action, "[^0-9A-Za-z-_\.]", "", "all");

		// convert controller to upperCamelCase and action to normal camelCase
		loc.rv.controller = REReplace(loc.rv.controller, "(^|-)([a-z])", "\u\2", "all");
		loc.rv.action = REReplace(loc.rv.action, "-([a-z])", "\u\1", "all");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$addRouteFormat" returntype="struct" access="public" output="false" hint="Adds in the format variable from the route if it exists.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		if (StructKeyExists(arguments.route, "formatVariable") && StructKeyExists(arguments.route, "format"))
		{
			loc.rv[arguments.route.formatVariable] = arguments.route.format;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$addRouteName" returntype="struct" access="public" output="false" hint="Adds in the name variable from the route if it exists.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.params;
		if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(loc.rv, "route"))
		{
			loc.rv.route = arguments.route.name;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>