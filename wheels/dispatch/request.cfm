<cffunction name="$init" returntype="any" access="public" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		loc.returnValue = $mergeURLAndFormScopes(loc.returnValue, arguments.urlScope, arguments.formScope);
		loc.returnValue = $mergeRoutePattern(loc.returnValue, arguments.route, arguments.path);
		loc.returnValue = $decryptParams(loc.returnValue);
		loc.returnValue = $translateBlankCheckBoxSubmissions(loc.returnValue);
		loc.returnValue = $translateDatePartSubmissions(loc.returnValue);
		loc.returnValue = $createNestedParamStruct(loc.returnValue);

		// we do the routing and controller params after we have built all other params so that we don't have more logic around params in arrays
		loc.returnValue = $ensureControllerAndAction(loc.returnValue, arguments.route);
		loc.returnValue = $addRouteFormat(loc.returnValue, arguments.route);
		loc.returnValue = $addRouteName(loc.returnValue, arguments.route);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createNestedParamStruct" returntype="struct" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		for (loc.key in arguments.params)
		{
			if (Find("[", loc.key) && Right(loc.key, 1) == "]")
			{
				// object form field
				loc.name = SpanExcluding(loc.key, "[");

				// we split the key into an array so the developer can have unlimited levels of params passed in
				loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true);
				if (!StructKeyExists(arguments.params, loc.name))
				{
					arguments.params[loc.name] = {};
				}

				// we need a reference to the struct so we can nest other structs if needed
				loc.struct = arguments.params[loc.name];

				// looping over the array allows for infinite nesting
				loc.iEnd = ArrayLen(loc.nested);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
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
						loc.struct[loc.item] = arguments.params[loc.key];
					}
				}

				// delete the original key so it doesn't show up in the params
				StructDelete(arguments.params, loc.key, false);
			}
		}
	</cfscript>
	<cfreturn arguments.params>
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
				loc.returnValue = loc.route;
				break;
			} 
			else if (arguments.path == "" && loc.currentRoute == "")
			{
				loc.returnValue = loc.route;
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
					loc.returnValue = loc.route;
					if (len(loc.format))
					{
						// we need to duplicate the route here otherwise we overwrite the one in the application scope
						loc.returnValue = Duplicate(loc.returnValue);
						loc.returnValue[ReplaceList(loc.format, "[,]", "")] = $getFormatFromRequest(pathInfo=arguments.path);
					}
					break;
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
		{
			$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your `config/routes.cfm` file that matches the `#arguments.path#` request.");
		}
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getPathFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfargument name="scriptName" type="string" required="true">
	<cfscript>
		var loc = {};
		
		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
		{
			loc.returnValue = "";
		}
		else
		{
			loc.returnValue = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getFormatFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		if (Find(".", arguments.pathInfo))
		{
			loc.returnValue = ListLast(arguments.pathInfo, ".");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("setup");
		}
		loc.params = $paramParser(argumentCollection=arguments);

		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = loc.params;

		if (application.wheels.showDebugInformation)
		{
			$debugPoint("setup");
		}

		// create the requested controller and process the action code for it
		loc.controller = controller(name=loc.params.controller, params=loc.params);
		loc.controller.$processAction();
		
		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (loc.controller.$performedRedirect())
		{
			$location(argumentCollection=loc.controller.$getRedirect());
		}

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		loc.controller.$flashClear();

		// return the response string
		loc.returnValue = loc.controller.response();
	</cfscript>
	<cfreturn loc.returnValue>
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
		return $createParams(path=loc.path, route=loc.route, formScope=arguments.formScope, urlScope=arguments.urlScope);
	</cfscript>
</cffunction>

<cffunction name="$mergeURLAndFormScopes" returntype="struct" access="public" output="false" hint="Merges the url and form scope into a single structure. url scope has presidence.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfscript>
		StructAppend(arguments.params, arguments.formScope, true);
		StructAppend(arguments.params, arguments.urlScope, true);

		// get rid of the fieldnames
		StructDelete(arguments.params, "fieldnames", false);
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$mergeRoutePattern" returntype="struct" access="public" output="false" hint="Parses the route pattern. identifies the variable markers within the pattern and assigns the value from the url variables with the path.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="path" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.route.pattern, "/");
		if (StructKeyExists(arguments.route, "format") && Len(arguments.route.format))
		{
			arguments.path = Reverse(ListRest(Reverse(arguments.path), "."));
		}
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.route.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
			{
				arguments.params[ReplaceList(loc.item, "[,]", "")] = ListGetAt(arguments.path, loc.i, "/");
			}
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$decryptParams" returntype="struct" access="public" output="false" hint="Loops through the params struct passed in and attempts to deobfuscate them. ignores the controller and action params values.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (application.wheels.obfuscateUrls)
		{
			for (loc.key in arguments.params)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					try
					{
						arguments.params[loc.key] = deobfuscateParam(arguments.params[loc.key]);
					}
					catch (any e) {}
				}
			}
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$translateBlankCheckBoxSubmissions" returntype="struct" access="public" output="false" hint="Loops through the params struct and handle the cases where checkboxes are unchecked.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		for (loc.key in arguments.params)
		{
			if (FindNoCase("($checkbox)", loc.key))
			{
				// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to the unchecked values for the checkbox (to get around the problem that unchecked checkboxes don't post at all)
				loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
				if (!StructKeyExists(arguments.params, loc.formParamName))
				{
					arguments.params[loc.formParamName] = arguments.params[loc.key];
				}
				StructDelete(arguments.params, loc.key, false);
			}
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$translateDatePartSubmissions" returntype="struct" access="public" output="false" hint="Combines date parts into a single value.">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.dates = {};
		for (loc.key in arguments.params)
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
				loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = arguments.params[loc.key];
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
				if (loc.dates[loc.key].ampm == "AM" && loc.dates[loc.key].hour == 12)
				{
					loc.dates[loc.key].hour = 0;
				}
				else if (loc.dates[loc.key].ampm == "PM")
				{
					loc.dates[loc.key].hour += 12;
				}
			}
			try
			{
				arguments.params[loc.key] = CreateDateTime(loc.dates[loc.key].year, loc.dates[loc.key].month, loc.dates[loc.key].day, loc.dates[loc.key].hour, loc.dates[loc.key].minute, loc.dates[loc.key].second);
			}
			catch (any e)
			{
				arguments.params[loc.key] = "";
			}
			StructDelete(arguments.params, "#loc.key#($year)", false);
			StructDelete(arguments.params, "#loc.key#($month)", false);
			StructDelete(arguments.params, "#loc.key#($day)", false);
			StructDelete(arguments.params, "#loc.key#($hour)", false);
			StructDelete(arguments.params, "#loc.key#($minute)", false);
			StructDelete(arguments.params, "#loc.key#($second)", false);
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$ensureControllerAndAction" returntype="struct" access="public" output="false" hint="Ensure that the controller and action params exists and camelized.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(arguments.params, "controller"))
		{
			arguments.params.controller = arguments.route.controller;
		}
		if (!StructKeyExists(arguments.params, "action"))
		{
			arguments.params.action = arguments.route.action;
		}

		// filter out illegal characters from the controller and action arguments
		arguments.params.controller = ReReplace(arguments.params.controller, "[^0-9A-Za-z-_]", "", "all");
		arguments.params.action = ReReplace(arguments.params.action, "[^0-9A-Za-z-_\.]", "", "all");

		// convert controller to upperCamelCase and action to normal camelCase
		arguments.params.controller = REReplace(arguments.params.controller, "(^|-)([a-z])", "\u\2", "all");
		arguments.params.action = REReplace(arguments.params.action, "-([a-z])", "\u\1", "all");

	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$addRouteFormat" returntype="struct" access="public" output="false" hint="Adds in the format variable from the route if it exists.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments.route, "formatVariable") && StructKeyExists(arguments.route, "format"))
		{
			arguments.params[arguments.route.formatVariable] = arguments.route.format;
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>

<cffunction name="$addRouteName" returntype="struct" access="public" output="false" hint="Adds in the name variable from the route if it exists.">
	<cfargument name="params" type="struct" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(arguments.params, "route"))
		{
			arguments.params.route = arguments.route.name;
		}
	</cfscript>
	<cfreturn arguments.params>
</cffunction>