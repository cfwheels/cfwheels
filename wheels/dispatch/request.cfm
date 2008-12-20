<cffunction name="$runFilters" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		if (arguments.type == "before")
			loc.filters = arguments.controller.$getBeforeFilters();
		else
			loc.filters = arguments.controller.$getAfterFilters();
		loc.iEnd = ArrayLen(loc.filters);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			if ((!Len(loc.filters[loc.i].only) && !Len(loc.filters[loc.i].except)) || (Len(loc.filters[loc.i].only) && ListFindNoCase(loc.filters[loc.i].only, loc.params.action)) || (Len(loc.filters[loc.i].except) && !ListFindNoCase(loc.filters[loc.i].except, loc.params.action)))
				$invoke(component=arguments.controller, method=loc.filters[loc.i].through);
		}
	</cfscript>
</cffunction>

<cffunction name="$runVerifications" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.verifications = arguments.controller.$getVerifications();
		loc.abort = false;
		loc.iEnd = ArrayLen(loc.verifications);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.verification = loc.verifications[loc.i];
			if ((!Len(loc.verification.only) && !Len(loc.verification.except)) || (Len(loc.verification.only) && ListFindNoCase(loc.verification.only, loc.params.action)) || (Len(loc.verification.except) && !ListFindNoCase(loc.verification.except, loc.params.action)))
			{
				if (IsBoolean(loc.verification.post) && ((loc.verification.post && cgi.request_method != "post") || (!loc.verification.post && cgi.request_method == "post")))
					loc.abort = true;
				if (IsBoolean(loc.verification.get) && ((loc.verification.get && cgi.request_method != "get") || (!loc.verification.get && cgi.request_method == "get")))
					loc.abort = true;
				if (IsBoolean(loc.verification.ajax) && ((loc.verification.ajax && cgi.http_x_requested_with != "XMLHTTPRequest") || (!loc.verification.ajax && cgi.http_x_requested_with == "XMLHTTPRequest")))
					loc.abort = true;
				loc.jEnd = ListLen(loc.verification.params);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (!StructKeyExists(loc.params, ListGetAt(loc.verification.params, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.session);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (!StructKeyExists(session, ListGetAt(loc.verification.session, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.cookie);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (!StructKeyExists(cookie, ListGetAt(loc.verification.cookie, loc.j)))
						loc.abort = true;
				}
			}
			if (loc.abort)
			{
				if (Len(loc.verification.handler))
				{
					$invoke(component=arguments.controller, method=loc.verification.handler);
					$location(url=cgi.http_referer, addToken=false);
				}
				else
				{
					$abort();
				}			
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$getRouteFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#cgi.script_name#">
	<cfscript>
		var returnValue = "";
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
			returnValue = "";
		else
			returnValue = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$findMatchingRoute" returntype="struct" access="public" output="false">
	<cfargument name="route" type="string" required="true">
	<cfargument name="routes" type="array" required="false" default="#application.wheels.routes#">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(arguments.routes);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.currentRoute = arguments.routes[loc.i].pattern;
			if (arguments.route == "" && loc.currentRoute == "")
			{
				loc.returnValue = arguments.routes[loc.i];
				break;
			}
			else
			{
				if (ListLen(arguments.route, "/") GTE ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
				{
					loc.match = true;
					loc.jEnd = ListLen(loc.currentRoute, "/");
					for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
					{
						loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
						loc.thisRoute = ReplaceList(loc.item, "[,]", ",");
						loc.thisURL = ListGetAt(arguments.route, loc.j, "/");
						if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisURL)
							loc.match = false;
					}
					if (loc.match)
					{
						loc.returnValue = arguments.routes[loc.i];
						break;
					}
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your 'config/routes.cfm' file that matches the '#arguments.route#' request.");
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="route" type="string" required="true">
	<cfargument name="foundRoute" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		
		// add all normal URL variables to struct (i.e. ?x=1&y=2 etc)
		loc.returnValue = arguments.urlScope; 
		
		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.foundRoute.pattern, "/");
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.item = ListGetAt(arguments.foundRoute.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
				loc.returnValue[ReplaceList(loc.item, "[,]", ",")] = ListGetAt(arguments.route, loc.i, "/");
		}

		// add controller and action unless they already exist
		if (!StructKeyExists(loc.returnValue, "controller"))
			loc.returnValue.controller = arguments.foundRoute.controller;
		if (!StructKeyExists(loc.returnValue, "action"))
			loc.returnValue.action = arguments.foundRoute.action;
		
		// convert controller to upperCamelCase and action to normal camelCase
		loc.returnValue.controller = REReplace(loc.returnValue.controller, "-([a-z])", "\u\1", "all");
		loc.returnValue.action = REReplace(loc.returnValue.action, "-([a-z])", "\u\1", "all");
	
		// decrypt all values except controller and action
		if (application.settings.obfuscateURLs)
		{
			for (loc.key in loc.returnValue)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					try
					{
						loc.returnValue[loc.key] = deobfuscateParam(loc.returnValue[loc.key]);
					}
					catch(Any e) {}
				}
			}
		}
	
		if (StructCount(arguments.formScope))
		{
			// loop through form variables, merge any date variables into one, fix checkbox submissions
			loc.dates = {};
			for (loc.key in arguments.formScope)
			{
				if (FindNoCase("($checkbox)", loc.key))
				{
					// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to 0 (to get around the problem that unchecked checkboxes don't post at all)
					loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
					if (!StructKeyExists(arguments.formScope, loc.formParamName))
						arguments.formScope[loc.formParamName] = 0;
					StructDelete(arguments.formScope, loc.key);
				}
				else if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
				{
					loc.temp = ListToArray(loc.key, "(");
					loc.firstKey = loc.temp[1];
					loc.secondKey = SpanExcluding(loc.temp[2], ")");
					if (!StructKeyExists(loc.dates, loc.firstKey))
						loc.dates[loc.firstKey] = {};
					loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = arguments.formScope[loc.key];
				}
			}
			for (loc.key in loc.dates)
			{
				if (!StructKeyExists(loc.dates[loc.key], "year"))
					loc.dates[loc.key].year = 1899;
				if (!StructKeyExists(loc.dates[loc.key], "month"))
					loc.dates[loc.key].month = 12;
				if (!StructKeyExists(loc.dates[loc.key], "day"))
					loc.dates[loc.key].day = 30;
				if (!StructKeyExists(loc.dates[loc.key], "hour"))
					loc.dates[loc.key].hour = 0;
				if (!StructKeyExists(loc.dates[loc.key], "minute"))
					loc.dates[loc.key].minute = 0;
				if (!StructKeyExists(loc.dates[loc.key], "second"))
					loc.dates[loc.key].second = 0;
				try
				{
					arguments.formScope[loc.key] = CreateDateTime(loc.dates[loc.key].year, loc.dates[loc.key].month, loc.dates[loc.key].day, loc.dates[loc.key].hour, loc.dates[loc.key].minute, loc.dates[loc.key].second);
				}
				catch(Any e)
				{
					arguments.formScope[loc.key] = "";
				} 
				if (StructKeyExists(arguments.formScope, "#loc.key#($year)"))
					StructDelete(arguments.formScope, "#loc.key#($year)");
				if (StructKeyExists(arguments.formScope, "#loc.key#($month)"))
					StructDelete(arguments.formScope, "#loc.key#($month)");
				if (StructKeyExists(arguments.formScope, "#loc.key#($day)"))
					StructDelete(arguments.formScope, "#loc.key#($day)");
				if (StructKeyExists(arguments.formScope, "#loc.key#($hour)"))
					StructDelete(arguments.formScope, "#loc.key#($hour)");
				if (StructKeyExists(arguments.formScope, "#loc.key#($minute)"))
					StructDelete(arguments.formScope, "#loc.key#($minute)");
				if (StructKeyExists(arguments.formScope, "#loc.key#($second)"))
					StructDelete(arguments.formScope, "#loc.key#($second)");
			}
		
			// add form variables to the params struct
			for (loc.key in arguments.formScope)
			{
				loc.match = REFindNoCase("(.*?)\[(.*?)\]", loc.key, 1, true);
				if (ArrayLen(loc.match.pos) IS 3)
				{
					// model object form field, build a struct to hold the data, named after the model object
					loc.objectName = LCase(Mid(loc.key, loc.match.pos[2], loc.match.len[2]));
					loc.fieldName = LCase(Mid(loc.key, loc.match.pos[3], loc.match.len[3]));
					if (!StructKeyExists(loc.returnValue, loc.objectName))
						loc.returnValue[loc.objectName] = {};
					loc.returnValue[loc.objectName][loc.fieldName] = arguments.formScope[loc.key];
				}
				else
				{
					// normal form field
					loc.returnValue[loc.key] = arguments.formScope[loc.key];
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (application.settings.showDebugInformation)
			$debugPoint("setup");
		
		// set route from incoming url, find a matching one and create the params struct
		loc.route = $getRouteFromRequest();
		loc.foundRoute = $findMatchingRoute(route=loc.route);
		loc.params = $createParams(route=loc.route, foundRoute=loc.foundRoute);
		
		// set params in the request scope as well so we can display it in the debug info outside of the controller context
		request.wheels.params = loc.params;
		
		// create an empty flash unless it already exists
		if (!StructKeyExists(session, "flash"))
			session.flash = {};
		
		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		
		if (application.settings.showDebugInformation)
			$debugPoint("setup,beforeFilters");
		
		// run verifications and before filters if they exist on the controller
		$runVerifications(loc.controller);
		$runFilters(controller=loc.controller, type="before");
		
		if (application.settings.showDebugInformation)
			$debugPoint("beforeFilters,action");
			
		// call action on controller if it exists
		loc.actionIsCachable = false;
		if (application.settings.cacheActions && StructIsEmpty(session.flash) && StructIsEmpty(form))
		{
			loc.cachableActions = loc.controller.$getCachableActions();
			loc.iEnd = ArrayLen(loc.cachableActions);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				if (loc.cachableActions[loc.i].action == loc.params.action)
				{
					loc.actionIsCachable = true;
					loc.timeToCache = loc.cachableActions[loc.i].time;
				}
			}
		}
		if (loc.actionIsCachable)
		{
			loc.category = "action";
			loc.key = "#cgi.script_name##cgi.path_info##cgi.query_string#";
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.key = loc.key;
			loc.conditionArgs.category = loc.category;
			loc.executeArgs = {};
			loc.executeArgs.controller = loc.controller;
			loc.executeArgs.controllerName = loc.params.controller;
			loc.executeArgs.actionName = loc.params.action;
			loc.executeArgs.key = loc.key;
			loc.executeArgs.time = loc.timeToCache;
			loc.executeArgs.category = loc.category;
			$doubleCheckLock(name=loc.lockName, condition="$actionIsInCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			$callAction(loc.controller, loc.params.controller, loc.params.action);
		}
		if (application.settings.showDebugInformation)
			$debugPoint("action,afterFilters");
		$runFilters(controller=loc.controller, type="after");
		if (application.settings.showDebugInformation)
			$debugPoint("afterFilters");
		
		// clear the flash (note that this is not done for redirectTo since the processing does not get here)
		StructClear(session.flash);
	</cfscript>
	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="$callActionAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		$callAction(controller=arguments.controller, controllerName=arguments.controllerName, actionName=arguments.actionName);
		$addToCache(key=arguments.key, value=request.wheels.response, time=arguments.time, category=arguments.category);
	</cfscript>
	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="$actionIsInCache" returntype="any" access="public" output="false">
	<cfreturn $getFromCache(key=arguments.key, category=arguments.category)>
</cffunction>

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controllerName" type="string" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments.controller, arguments.actionName))
			$invoke(component=arguments.controller, method=arguments.actionName);
		if (!StructKeyExists(request.wheels, "response"))
		{
			// a render function has not been called yet so call it here
			try
			{
				arguments.controller.renderPage();
			}
			catch(Any e)
			{
				if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(arguments.controllerName)#/#LCase(arguments.actionName)#.cfm")))
				{
					$throw(object=e);
				}
				else
				{
					// if a plugin view page was requested, show it, otherwise show error instead
					if (arguments.controllerName IS "plugins")
					{
						arguments.controller.$renderPlugin(arguments.actionName);
					}
					else
					{
						if (application.settings.showErrorInformation)
						{
							$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the '#arguments.actionName#' action in the '#arguments.controllerName#' controller.", extendedInfo="Create a file named '#LCase(arguments.actionName)#.cfm' in the 'views/#LCase(arguments.controllerName)#' directory (create the directory as well if it doesn't already exist).");
						}
						else
						{
							$header(statusCode="404", statusText="Not Found");
							$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
							$abort();
						}
					}
				}
			}
		}
	</cfscript>
</cffunction>