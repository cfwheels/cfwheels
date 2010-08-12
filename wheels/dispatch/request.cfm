<cffunction name="$init" returntype="any" access="public" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="format" type="string" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfscript>
		var loc = {};

		loc.returnValue = Duplicate(arguments.formScope);
		StructAppend(loc.returnValue, arguments.urlScope, true);
		
		// get rid of the fieldnames
		StructDelete(loc.returnValue, "fieldnames", false);

		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.route.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.route.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
				loc.returnValue[ReplaceList(loc.item, "[,]", "")] = ListGetAt(arguments.path, loc.i, "/");
		}

		// decrypt all values except controller and action
		if (application.wheels.obfuscateUrls)
		{
			for (loc.key in loc.returnValue)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					try
					{
						loc.returnValue[loc.key] = deobfuscateParam(loc.returnValue[loc.key]);
					}
					catch(Any e)
					{}
				}
			}
		}

		if (StructCount(loc.returnValue))
		{
			// loop through form variables, merge any date variables into one, fix checkbox submissions
			loc.dates = {};
			for (loc.key in loc.returnValue)
			{
				if (FindNoCase("($checkbox)", loc.key))
				{
					// if no other form parameter exists with this name it means that the checkbox was left 
					// blank and therefore we force the value to the unchecked values for the checkbox 
					// (to get around the problem that unchecked checkboxes don't post at all)
					loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
					if (!StructKeyExists(loc.returnValue, loc.formParamName))
						loc.returnValue[loc.formParamName] = loc.returnValue[loc.key];
					StructDelete(loc.returnValue, loc.key);
				}
				else if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
				{
					loc.temp = ListToArray(loc.key, "(");
					loc.firstKey = loc.temp[1];
					loc.secondKey = SpanExcluding(loc.temp[2], ")");

					if (!StructKeyExists(loc.dates, loc.firstKey))
						loc.dates[loc.firstKey] = {};
					loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = loc.returnValue[loc.key];
				}
			}
			for (loc.key in loc.dates)
			{
				if (!StructKeyExists(loc.dates[loc.key], "year"))
					loc.dates[loc.key].year = 1899;
				if (!StructKeyExists(loc.dates[loc.key], "month"))
					loc.dates[loc.key].month = 1;
				if (!StructKeyExists(loc.dates[loc.key], "day"))
					loc.dates[loc.key].day = 1;
				if (!StructKeyExists(loc.dates[loc.key], "hour"))
					loc.dates[loc.key].hour = 0;
				if (!StructKeyExists(loc.dates[loc.key], "minute"))
					loc.dates[loc.key].minute = 0;
				if (!StructKeyExists(loc.dates[loc.key], "second"))
					loc.dates[loc.key].second = 0;
				if (!StructKeyExists(loc.returnValue, loc.key) || !IsArray(loc.returnValue[loc.key]))
					loc.returnValue[loc.key] = [];
				try
				{
					loc.returnValue[loc.key] = CreateDateTime(loc.dates[loc.key].year, loc.dates[loc.key].month, loc.dates[loc.key].day, loc.dates[loc.key].hour, loc.dates[loc.key].minute, loc.dates[loc.key].second);
				}
				catch(Any e)
				{
					loc.returnValue[loc.key] = "";
				}
				
				if (StructKeyExists(loc.returnValue, "#loc.key#($year)"))
					StructDelete(loc.returnValue, "#loc.key#($year)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($month)"))
					StructDelete(loc.returnValue, "#loc.key#($month)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($day)"))
					StructDelete(loc.returnValue, "#loc.key#($day)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($hour)"))
					StructDelete(loc.returnValue, "#loc.key#($hour)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($minute)"))
					StructDelete(loc.returnValue, "#loc.key#($minute)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($second)"))
					StructDelete(loc.returnValue, "#loc.key#($second)");
			}
			
			// add form variables to the params struct
			$createNestedParamStruct(params=loc.returnValue);
		}

		/***********************************************
		*	We now do the routing and controller
		*	params after we have built all other params
		*	so that we don't have more logic around
		*	params in arrays
		***********************************************/
		
		// add controller and action unless they already exist
		if (!StructKeyExists(loc.returnValue, "controller"))
			loc.returnValue.controller = arguments.route.controller;
		if (!StructKeyExists(loc.returnValue, "action"))
			loc.returnValue.action = arguments.route.action;
		
		// add in our format if it is available
		if (StructKeyExists(arguments.route, "formatVariable") && Len(arguments.format))
			loc.returnValue[arguments.route.formatVariable] = arguments.format;

		// convert controller to upperCamelCase and action to normal camelCase
		loc.returnValue.controller = REReplace(loc.returnValue.controller, "-([a-z])", "\u\1", "all");
		loc.returnValue.action = REReplace(loc.returnValue.action, "-([a-z])", "\u\1", "all");

		// add name of route to params if a named route is running
		if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(loc.returnValue, "route"))
			loc.returnValue.route = arguments.route.name;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createNestedParamStruct" returntype="struct" access="public" output="false">
	<cfargument name="params" type="struct" required="true" />
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
					arguments.params[loc.name] = {};
				
				loc.struct = arguments.params[loc.name]; // we need a reference to the struct so we can nest other structs if needed
				loc.iEnd = ArrayLen(loc.nested);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) // looping over the array allows for infinite nesting
				{
					loc.item = loc.nested[loc.i];
					if (!StructKeyExists(loc.struct, loc.item))
						loc.struct[loc.item] = {};
					if (loc.i != loc.iEnd)
						loc.struct = loc.struct[loc.item]; // pass the new reference (structs pass a reference instead of a copy) to the next iteration
					else
						loc.struct[loc.item] = arguments.params[loc.key];
				}
				// delete the original key so it doesn't show up in the params
				StructDelete(arguments.params, loc.key, false);
			}
		}
	</cfscript>
	<cfreturn arguments.params />
</cffunction>

<cffunction name="$findMatchingRoute" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="format" type="string" required="true" />
	<cfscript>
		var loc = {};
		
		loc.iEnd = ArrayLen(application.wheels.routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.format = false;
			if (StructKeyExists(application.wheels.routes[loc.i], "format"))
				loc.format = application.wheels.routes[loc.i].format;
			loc.currentRoute = application.wheels.routes[loc.i].pattern;
			if (loc.currentRoute == "*") {
				loc.returnValue = application.wheels.routes[loc.i];
				break;
			} 
			else if (arguments.path == "" && loc.currentRoute == "")
			{
				loc.returnValue = application.wheels.routes[loc.i];
				break;
			}
			else if (ListLen(arguments.path, "/") gte ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
			{
				loc.match = true;
				loc.jEnd = ListLen(loc.currentRoute, "/");
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
					loc.thisRoute = ReplaceList(loc.item, "[,]", "");
					loc.thisURL = ListGetAt(arguments.path, loc.j, "/");
					if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisURL)
						loc.match = false;
				}
				if (loc.match)
				{
					loc.returnValue = application.wheels.routes[loc.i];
					if (Len(arguments.format) && !IsBoolean(loc.format))
						loc.returnValue[ReplaceList(loc.format, "[,]", "")] = arguments.format;
					break;
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your `config/routes.cfm` file that matches the `#arguments.path#` request.");
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getPathFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfargument name="scriptName" type="string" required="true">
	<cfscript>
		var returnValue = "";
		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
			returnValue = "";
		else
			returnValue = ListFirst(Right(arguments.pathInfo, Len(arguments.pathInfo)-1), ".");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$getFormatFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfscript>
		var returnValue = "";
		if (Find(".", arguments.pathInfo))
			returnValue = ListLast(arguments.pathInfo, ".");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// determine the path from the url, find a matching route for it and create the params struct
		loc.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
		loc.format = $getFormatFromRequest(pathInfo=arguments.pathInfo);
		loc.route = $findMatchingRoute(path=loc.path, format=loc.format);
		loc.params = $createParams(path=loc.path, format=loc.format, route=loc.route, formScope=arguments.formScope, urlScope=arguments.urlScope);
		
		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = loc.params;

		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		
		// if the controller fails to process, instantiate a new controller and try again
		if (!loc.controller.$processAction())
		{
			loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
			loc.controller.$processAction();
		}
		
		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (loc.controller.$performedRedirect())
			$location(argumentCollection=loc.controller.$getRedirect());

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		loc.controller.$flashClear();
	</cfscript>
	<cfreturn loc.controller.response()>
</cffunction>