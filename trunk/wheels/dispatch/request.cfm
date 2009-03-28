<cffunction name="$runFilters" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		if (arguments.type eq "before")
			loc.filters = arguments.controller.$getBeforeFilters();
		else
			loc.filters = arguments.controller.$getAfterFilters();
		loc.iEnd = ArrayLen(loc.filters);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			if ((not(Len(loc.filters[loc.i].only)) and not(Len(loc.filters[loc.i].except))) or (Len(loc.filters[loc.i].only) and ListFindNoCase(loc.filters[loc.i].only, arguments.actionName)) or (Len(loc.filters[loc.i].except) and not(ListFindNoCase(loc.filters[loc.i].except, arguments.actionName))))
				$invoke(component=arguments.controller, method=loc.filters[loc.i].through);
		}
	</cfscript>
</cffunction>

<cffunction name="$runVerifications" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = "";
		loc.verifications = arguments.controller.$getVerifications();
		loc.abort = false;
		loc.iEnd = ArrayLen(loc.verifications);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.verification = loc.verifications[loc.i];
			if ((not(Len(loc.verification.only)) and not(Len(loc.verification.except))) or (Len(loc.verification.only) and ListFindNoCase(loc.verification.only, arguments.actionName)) or (Len(loc.verification.except) and not(ListFindNoCase(loc.verification.except, arguments.actionName))))
			{
				if (IsBoolean(loc.verification.post) and ((loc.verification.post and cgi.request_method neq "post") or (not(loc.verification.post) and cgi.request_method eq "post")))
					loc.abort = true;
				if (IsBoolean(loc.verification.get) and ((loc.verification.get and cgi.request_method neq "get") or (not(loc.verification.get) and cgi.request_method eq "get")))
					loc.abort = true;
				if (IsBoolean(loc.verification.ajax) and ((loc.verification.ajax and cgi.http_x_requested_with neq "XMLHTTPRequest") or (not(loc.verification.ajax) and cgi.http_x_requested_with eq "XMLHTTPRequest")))
					loc.abort = true;
				loc.jEnd = ListLen(loc.verification.params);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (not(StructKeyExists(loc.params, ListGetAt(loc.verification.params, loc.j))))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.session);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (not(StructKeyExists(session, ListGetAt(loc.verification.session, loc.j))))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.cookie);
				for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
				{
					if (not(StructKeyExists(cookie, ListGetAt(loc.verification.cookie, loc.j))))
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
		if (arguments.pathInfo eq arguments.scriptName or arguments.pathInfo eq "/" or arguments.pathInfo eq "")
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
		var loc = StructNew();
		loc.iEnd = ArrayLen(arguments.routes);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.currentRoute = arguments.routes[loc.i].pattern;
			if (arguments.route eq "" and loc.currentRoute eq "")
			{
				loc.returnValue = arguments.routes[loc.i];
				break;
			}
			else
			{
				if (ListLen(arguments.route, "/") GTE ListLen(loc.currentRoute, "/") and loc.currentRoute neq "")
				{
					loc.match = true;
					loc.jEnd = ListLen(loc.currentRoute, "/");
					for (loc.j=1; loc.j LTE loc.jEnd; loc.j=loc.j+1)
					{
						loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
						loc.thisRoute = ReplaceList(loc.item, "[,]", ",");
						loc.thisURL = ListGetAt(arguments.route, loc.j, "/");
						if (Left(loc.item, 1) neq "[" and loc.thisRoute neq loc.thisURL)
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
		if (not(StructKeyExists(loc, "returnValue")))
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
		var loc = StructNew();
		
		// add all normal URL variables to struct (i.e. ?x=1&y=2 etc)
		loc.returnValue = arguments.urlScope; 
		
		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.foundRoute.pattern, "/");
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.item = ListGetAt(arguments.foundRoute.pattern, loc.i, "/");
			if (Left(loc.item, 1) eq "[")
				loc.returnValue[ReplaceList(loc.item, "[,]", ",")] = ListGetAt(arguments.route, loc.i, "/");
		}

		// add controller and action unless they already exist
		if (not(StructKeyExists(loc.returnValue, "controller")))
			loc.returnValue.controller = arguments.foundRoute.controller;
		if (not(StructKeyExists(loc.returnValue, "action")))
			loc.returnValue.action = arguments.foundRoute.action;
		
		// convert controller to upperCamelCase and action to normal camelCase
		loc.returnValue.controller = REReplace(loc.returnValue.controller, "-([a-z])", "\u\1", "all");
		loc.returnValue.action = REReplace(loc.returnValue.action, "-([a-z])", "\u\1", "all");
	
		// decrypt all values except controller and action
		if (application.wheels.obfuscateUrls)
		{
			for (loc.key in loc.returnValue)
			{
				if (loc.key neq "controller" and loc.key neq "action")
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
			loc.dates = StructNew();
			for (loc.key in arguments.formScope)
			{
				if (FindNoCase("($checkbox)", loc.key))
				{
					// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to 0 (to get around the problem that unchecked checkboxes don't post at all)
					loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
					if (not(StructKeyExists(arguments.formScope, loc.formParamName)))
						arguments.formScope[loc.formParamName] = 0;
					StructDelete(arguments.formScope, loc.key);
				}
				else if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
				{
					loc.temp = ListToArray(loc.key, "(");
					loc.firstKey = loc.temp[1];
					loc.secondKey = SpanExcluding(loc.temp[2], ")");
					if (not(StructKeyExists(loc.dates, loc.firstKey)))
						loc.dates[loc.firstKey] = StructNew();
					loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = arguments.formScope[loc.key];
				}
			}
			for (loc.key in loc.dates)
			{
				if (not(StructKeyExists(loc.dates[loc.key], "year")))
					loc.dates[loc.key].year = 1899;
				if (not(StructKeyExists(loc.dates[loc.key], "month")))
					loc.dates[loc.key].month = 12;
				if (not(StructKeyExists(loc.dates[loc.key], "day")))
					loc.dates[loc.key].day = 30;
				if (not(StructKeyExists(loc.dates[loc.key], "hour")))
					loc.dates[loc.key].hour = 0;
				if (not(StructKeyExists(loc.dates[loc.key], "minute")))
					loc.dates[loc.key].minute = 0;
				if (not(StructKeyExists(loc.dates[loc.key], "second")))
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
					if (not(StructKeyExists(loc.returnValue, loc.objectName)))
						loc.returnValue[loc.objectName] = StructNew();
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
		var loc = StructNew();
		if (application.wheels.showDebugInformation)
			$debugPoint("setup");
		
		// set route from incoming url, find a matching one and create the params struct
		loc.route = $getRouteFromRequest();
		loc.foundRoute = $findMatchingRoute(route=loc.route);
		loc.params = $createParams(route=loc.route, foundRoute=loc.foundRoute);
		
		// set params in the request scope as well so we can display it in the debug info outside of the controller context
		request.wheels.params = loc.params;
		
		// create an empty flash unless it already exists
		if (not(StructKeyExists(session, "flash")))
			session.flash = StructNew();
		
		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		
		if (application.wheels.showDebugInformation)
			$debugPoint("setup,beforeFilters");
		
		// run verifications and before filters if they exist on the controller
		$runVerifications(controller=loc.controller, actionName=loc.params.action);
		$runFilters(controller=loc.controller, type="before", actionName=loc.params.action);
		
		if (application.wheels.showDebugInformation)
			$debugPoint("beforeFilters,action");
			
		// call action on controller if it exists
		loc.actionIsCachable = false;
		if (application.wheels.cacheActions and StructIsEmpty(session.flash) and StructIsEmpty(form))
		{
			loc.cachableActions = loc.controller.$getCachableActions();
			loc.iEnd = ArrayLen(loc.cachableActions);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				if (loc.cachableActions[loc.i].action eq loc.params.action)
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
			loc.conditionArgs = StructNew();
			loc.conditionArgs.key = loc.key;
			loc.conditionArgs.category = loc.category;
			loc.executeArgs = StructNew();
			loc.executeArgs.controller = loc.controller;
			loc.executeArgs.controllerName = loc.params.controller;
			loc.executeArgs.actionName = loc.params.action;
			loc.executeArgs.key = loc.key;
			loc.executeArgs.time = loc.timeToCache;
			loc.executeArgs.category = loc.category;
			$doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			$callAction(controller=loc.controller, controllerName=loc.params.controller, actionName=loc.params.action);
		}
		if (application.wheels.showDebugInformation)
			$debugPoint("action,afterFilters");
		$runFilters(controller=loc.controller, type="after", actionName=loc.params.action);
		if (application.wheels.showDebugInformation)
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

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controllerName" type="string" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		if (StructKeyExists(arguments.controller, arguments.actionName))
			$invoke(component=arguments.controller, method=arguments.actionName);
		if (not(StructKeyExists(request.wheels, "response")))
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
					if (application.wheels.showErrorInformation)
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
	</cfscript>
</cffunction>