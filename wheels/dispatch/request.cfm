<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controllerName" type="string" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfscript>
		var loc = {};

		if (Left(arguments.actionName, 1) == "$" || ListFindNoCase(application.wheels.protectedControllerMethods, arguments.actionName))
			$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.actionName#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in Wheels functions.");

		if (StructKeyExists(arguments.controller, arguments.actionName)) 
		{
			$invoke(componentReference=arguments.controller, method=arguments.actionName);
		} 
		else if (StructKeyExists(arguments.controller, "onMissingMethod"))
		{
			loc.argumentCollection = {};
			loc.argumentCollection.missingMethodName = arguments.actionName;
			loc.argumentCollection.missingMethodArguments = {};
			$invoke(componentReference=arguments.controller, method="onMissingMethod", argumentCollection=loc.argumentCollection);
		}
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
					if (application.wheels.showErrorInformation)
					{
						$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.actionName#` action in the `#arguments.controllerName#` controller.", extendedInfo="Create a file named `#LCase(arguments.actionName)#.cfm` in the `views/#LCase(arguments.controllerName)#` directory (create the directory as well if it doesn't already exist).");
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

<cffunction name="$callActionAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		$callAction(controller=arguments.controller, controllerName=arguments.controllerName, actionName=arguments.actionName);
		$addToCache(key=arguments.key, value=request.wheels.response, time=arguments.time, category=arguments.category);
	</cfscript>
	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="route" type="string" required="true">
	<cfargument name="foundRoute" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};

		loc.returnValue = $getParameterMap(argumentCollection=arguments);
		// decrypt all values except controller and action
		if (application.wheels.obfuscateUrls)
		{
			for (loc.key in loc.returnValue)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						try
						{
							loc.returnValue[loc.key][loc.i] = deobfuscateParam(loc.returnValue[loc.key][loc.i]);
						}
						catch(Any e) 
						{}
					}
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
					// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to the unchecked values for the checkbox (to get around the problem that unchecked checkboxes don't post at all)
					loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
					if (!StructKeyExists(loc.returnValue, loc.formParamName))
					{
						loc.returnValue[loc.formParamName] = [];
						loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
						for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
							loc.returnValue[loc.formParamName][loc.i] = loc.returnValue[loc.key][loc.i];
					}
					StructDelete(loc.returnValue, loc.key);
				}
				else if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
				{
					loc.temp = ListToArray(loc.key, "(");
					loc.firstKey = loc.temp[1];
					loc.secondKey = SpanExcluding(loc.temp[2], ")");
					
					loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						if (!StructKeyExists(loc.dates, loc.firstKey))
							loc.dates[loc.firstKey] = [];
						loc.dates[loc.firstKey][loc.i][ReplaceNoCase(loc.secondKey, "$", "")] = loc.returnValue[loc.key][loc.i];
					}
				}
			}
			for (loc.key in loc.dates)
			{
				loc.iEnd = ArrayLen(loc.dates[loc.key]);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				{
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "year"))
						loc.dates[loc.key][loc.i].year = 1899;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "month"))
						loc.dates[loc.key][loc.i].month = 1;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "day"))
						loc.dates[loc.key][loc.i].day = 1;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "hour"))
						loc.dates[loc.key][loc.i].hour = 0;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "minute"))
						loc.dates[loc.key][loc.i].minute = 0;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "second"))
						loc.dates[loc.key][loc.i].second = 0;
					if (!StructKeyExists(loc.returnValue, loc.key) || !IsArray(loc.returnValue[loc.key]))
						loc.returnValue[loc.key] = [];
					try
					{
						loc.returnValue[loc.key][loc.i] = CreateDateTime(loc.dates[loc.key][loc.i].year, loc.dates[loc.key][loc.i].month, loc.dates[loc.key][loc.i].day, loc.dates[loc.key][loc.i].hour, loc.dates[loc.key][loc.i].minute, loc.dates[loc.key][loc.i].second);
					}
					catch(Any e)
					{
						loc.returnValue[loc.key][loc.i] = "";
					}
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
			// find any new structs and convert them
			$createNewArrayStruct(params=loc.returnValue);
		}
		
		/************************************
		*	We now do the routing and controller
		*	params after we have built all other params
		*	so that we don't have more logic around
		*	params in arrays
		************************************/

		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.foundRoute.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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

		// add name of route to params if a named route is running
		if (StructKeyExists(arguments.foundRoute, "name") && Len(arguments.foundRoute.name) && !StructKeyExists(loc.returnValue, "route"))
			loc.returnValue.route = arguments.foundRoute.name;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getParameterMap" returntype="struct" access="public" output="false">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfargument name="parameters" type="struct" required="false" default="#Duplicate(GetPageContext().getRequest().getParameterMap())#">
	<cfargument name="multipart" type="any" required="false" default="#form.getPartsArray()#">
	<cfscript>
		var loc = {};
		loc.original = {};
		loc.multipart = {};
		loc.parameters = {};
		// merge our coldfusion scopes together
		loc.original = Duplicate(arguments.formScope);
		StructDelete(loc.original, "fieldnames", false);
		StructAppend(loc.original, arguments.urlScope, true);
		// if the form our url scopes were set after the request started, we need to make sure that they are in arrays
		for (loc.item in loc.original)
		{
			loc.parameters[loc.item] = [];
			ArrayAppend(loc.parameters[loc.item], loc.original[loc.item]);
		}
		// get our values from the parameter map, this will always contain url variables and will contain form parameters when not a multipart form
		for (loc.item in arguments.parameters)
		{
			loc.parameters[loc.item] = [];
			loc.iEnd = ArrayLen(arguments.parameters[loc.item]);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				loc.parameters[loc.item][loc.i] = arguments.parameters[loc.item][loc.i];
		}
		// if this is defined, then we have a multipart for and will be getting our form values from here
		if (StructKeyExists(arguments, "multipart"))
		{
			// build our multipart struct
			loc.iEnd = ArrayLen(arguments.multipart);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.param = arguments.multipart[loc.i];
				if (loc.param.isParam())
				{
					if (!StructKeyExists(loc.multipart, loc.param.getName()))
						loc.multipart[loc.param.getName()] = [];
					ArrayAppend(loc.multipart[loc.param.getName()], loc.param.getStringValue());
				}
			}
			
			// now overwrite our parameters with the multipart values
			for (loc.item in loc.multipart)
				loc.parameters[loc.item] = loc.multipart[loc.item];
		}
		// overwrite any parameters in our map with the right values from the url
		for (loc.item in arguments.urlScope)
		{
			loc.parameters[loc.item] = [];
			ArrayAppend(loc.parameters[loc.item], arguments.urlScope[loc.item]);
		}
	</cfscript>
	<cfreturn loc.parameters />
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
				// we split the key into an array so the developer can have multiple levels of params passed in
				loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true); 
				if (!StructKeyExists(arguments.params, loc.name))
					arguments.params[loc.name] = {};
				loc.struct = arguments.params[loc.name]; // we need a reference to the struct so we can nest other structs if needed
				loc.iEnd = ArrayLen(loc.nested);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) // looping over the array allows for infinite nesting
				{
					loc.item = loc.nested[loc.i];
					if (!Len(loc.item)) // if we have an empty struct item it means that the developer is passing in new items
						loc.item = "new";
					if (!StructKeyExists(loc.struct, loc.item))
						loc.struct[loc.item] = {};
					if (loc.i != loc.iEnd)
						loc.struct = loc.struct[loc.item]; // pass the new reference (structs pass a reference instead of a copy) to the next iteration
					else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
						loc.struct[loc.item] = arguments.params[loc.key][1];
					else if (IsArray(arguments.params[loc.key]))
						loc.struct[loc.item] = $arrayToStruct(arguments.params[loc.key]);
					else
						loc.struct[loc.item] = arguments.params[loc.key];
				}
				// delete the original key so it doesn't show up in the params
				StructDelete(arguments.params, loc.key, false);
			}
			else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
				arguments.params[loc.key] = arguments.params[loc.key][1];
		}	
	</cfscript>
	<cfreturn arguments.params />
</cffunction>

<cffunction name="$createNewArrayStruct" returntype="void" access="public" output="false">
	<cfargument name="params" type="struct" required="true" />
	<cfscript>
		var loc = {};
		
		loc.newStructArray = StructFindKey(arguments.params, "new", "all");
		loc.iEnd = ArrayLen(loc.newStructArray);
		
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.owner = loc.newStructArray[loc.i].owner.new;
			loc.value = loc.newStructArray[loc.i].value;
			loc.map = {};
			$mapStruct(map=loc.map, struct=loc.value);
			
			StructClear(loc.value); // clear the struct now that we have our paths and values
			
			for (loc.item in loc.map) // remap our new struct
			{
				// move the last element to the first
				loc.newPos = loc.item;
				loc.last = Replace(ListLast(loc.newPos, "["), "]", "");
				if (IsNumeric(loc.last))
				{
					loc.newPos = ListDeleteAt(loc.newPos, ListLen(loc.newPos, "["), "[");
					loc.newPos = ListPrepend(loc.newPos, "[" & loc.last, "]");
				}
				else
				{
					loc.newPos = ListPrepend(loc.newPos, "[1", "]");
				}
				loc.map[loc.item].newPos = ListToArray(Replace(loc.newPos, "]", "", "all"), "[", false);
				
				// loop through the position array and build our new struct
				loc.struct = loc.value;
				loc.jEnd = ArrayLen(loc.map[loc.item].newPos);
				for (loc.j = 1; loc.j lte loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(loc.struct, loc.map[loc.item].newPos[loc.j]))
						loc.struct[loc.map[loc.item].newPos[loc.j]] = {};
					if (loc.j != loc.jEnd)
						loc.struct = loc.struct[loc.map[loc.item].newPos[loc.j]];
					else
						loc.struct[loc.map[loc.item].newPos[loc.j]] = loc.map[loc.item].value;
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$findMatchingRoute" returntype="struct" access="public" output="false">
	<cfargument name="route" type="string" required="true">
	<cfargument name="routes" type="array" required="false" default="#application.wheels.routes#">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(arguments.routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.currentRoute = arguments.routes[loc.i].pattern;
			if (arguments.route == "" && loc.currentRoute == "")
			{
				loc.returnValue = arguments.routes[loc.i];
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
						loc.returnValue = arguments.routes[loc.i];
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

<cffunction name="$getRouteFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfscript>
		var returnValue = "";
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
			returnValue = "";
		else
			returnValue = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
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

		if (application.wheels.showDebugInformation)
			$debugPoint("setup,beforeFilters");

		// run verifications and before filters if they exist on the controller
		$runVerifications(controller=loc.controller, actionName=loc.params.action, params=loc.params);
		loc.controller.$runFilters(type="before", action=loc.params.action);
		
		// check to see if the controller params has changed and if so, instantiate the new controller and re-run filters and verifications
		if (loc.params.controller != loc.controller.controllerName()) {
			loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
			$runVerifications(controller=loc.controller, actionName=loc.params.action, params=loc.params);
			$runFilters(controller=loc.controller, type="before", actionName=loc.params.action);
		}
		
		if (application.wheels.showDebugInformation)
			$debugPoint("beforeFilters,action");

		// only proceed to call the action if the before filter has not already rendered content
		if (!StructKeyExists(request.wheels, "response") || !Len(request.wheels.response))
		{
			// call action on controller if it exists
			loc.actionIsCachable = false;
			if (application.wheels.cacheActions && StructIsEmpty(session.flash) && StructIsEmpty(form))
			{
				loc.cachableActions = loc.controller.$getCachableActions();
				loc.iEnd = ArrayLen(loc.cachableActions);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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
				loc.key = "#request.cgi.script_name##request.cgi.path_info##request.cgi.query_string#";
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
				request.wheels.response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
			}
			else
			{
				$callAction(controller=loc.controller, controllerName=loc.params.controller, actionName=loc.params.action);
			}
		}
		if (application.wheels.showDebugInformation)
			$debugPoint("action,afterFilters");
		loc.controller.$runFilters(type="after", action=loc.params.action);
		if (application.wheels.showDebugInformation)
			$debugPoint("afterFilters");

		// clear the flash (note that this is not done for redirectTo since the processing does not get here)
		StructClear(session.flash);
	</cfscript>
	<cfreturn Trim(request.wheels.response)>
</cffunction>

<cffunction name="$returnDispatcher" returntype="any" access="public" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="$runVerifications" returntype="void" access="public" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="actionName" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.verifications = arguments.controller.$getVerifications();
		loc.abort = false;
		loc.iEnd = ArrayLen(loc.verifications);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.verification = loc.verifications[loc.i];
			if ((!Len(loc.verification.only) && !Len(loc.verification.except)) || (Len(loc.verification.only) && ListFindNoCase(loc.verification.only, arguments.actionName)) || (Len(loc.verification.except) && !ListFindNoCase(loc.verification.except, arguments.actionName)))
			{
				if (IsBoolean(loc.verification.post) && ((loc.verification.post && request.cgi.request_method != "post") || (!loc.verification.post && request.cgi.request_method == "post")))
					loc.abort = true;
				if (IsBoolean(loc.verification.get) && ((loc.verification.get && request.cgi.request_method != "get") || (!loc.verification.get && request.cgi.request_method == "get")))
					loc.abort = true;
				if (IsBoolean(loc.verification.ajax) && ((loc.verification.ajax && request.cgi.http_x_requested_with != "XMLHTTPRequest") || (!loc.verification.ajax && request.cgi.http_x_requested_with == "XMLHTTPRequest")))
					loc.abort = true;
				loc.jEnd = ListLen(loc.verification.params);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(arguments.params, ListGetAt(loc.verification.params, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.session);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(session, ListGetAt(loc.verification.session, loc.j)))
						loc.abort = true;
				}
				loc.jEnd = ListLen(loc.verification.cookie);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(cookie, ListGetAt(loc.verification.cookie, loc.j)))
						loc.abort = true;
				}
			}
			if (loc.abort)
			{
				if (Len(loc.verification.handler))
				{
					$invoke(componentReference=arguments.controller, method=loc.verification.handler);
					$location(url=request.cgi.http_referer, addToken=false);
				}
				else
				{
					$abort();
				}
			}
		}
	</cfscript>
</cffunction>