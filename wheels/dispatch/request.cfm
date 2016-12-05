<cfscript>
/**
* PRIVATE FUNCTIONS
*/
	public any function $init() {
		local.rv = this;
		return local.rv;
	}

	public struct function $createParams(
		required string path,
		required struct route,
		required struct formScope,
		required struct urlScope
	) {
		local.rv = {};
		local.rv = $mergeUrlAndFormScopes(params=local.rv, urlScope=arguments.urlScope, formScope=arguments.formScope);
		local.rv = $mergeRoutePattern(params=local.rv, route=arguments.route, path=arguments.path);
		local.rv = $decryptParams(params=local.rv);
		local.rv = $translateBlankCheckBoxSubmissions(params=local.rv);
		local.rv = $translateDatePartSubmissions(params=local.rv);
		local.rv = $createNestedParamStruct(params=local.rv);

		// we now do the routing and controller params after we have built all other params so that we don't have more logic around params in arrays
		local.rv = $ensureControllerAndAction(params=local.rv, route=arguments.route);
		local.rv = $addRouteFormat(params=local.rv, route=arguments.route);
		local.rv = $addRouteName(params=local.rv, route=arguments.route);
		return local.rv;
	}

	public struct function $createNestedParamStruct(required struct params) {
		local.rv = arguments.params;
		for (local.key in local.rv)
		{
			if (Find("[", local.key) && Right(local.key, 1) == "]")
			{
				// object form field
				local.name = SpanExcluding(local.key, "[");

				// we split the key into an array so the developer can have unlimited levels of params passed in
				local.nested = ListToArray(ReplaceList(local.key, local.name & "[,]", ""), "[", true);
				if (!StructKeyExists(local.rv, local.name))
				{
					local.rv[local.name] = {};
				}

				// we need a reference to the struct so we can nest other structs if needed
				local.struct = local.rv[local.name];
				local.iEnd = ArrayLen(local.nested);
				for (local.i=1; local.i <= local.iEnd; local.i++)
				{
					// looping over the array allows for infinite nesting
					local.item = local.nested[local.i];
					if (!StructKeyExists(local.struct, local.item))
					{
						local.struct[local.item] = {};
					}
					if (local.i != local.iEnd)
					{
						// pass the new reference (structs pass a reference instead of a copy) to the next iteration
						local.struct = local.struct[local.item];
					}
					else
					{
						local.struct[local.item] = local.rv[local.key];
					}
				}
				// delete the original key so it doesn't show up in the params
				StructDelete(local.rv, local.key);
			}
		}
		return local.rv;
	}

	public struct function $findMatchingRoute(
		required string path, string requestMethod=$getRequestMethod()) {

		// loop over wheels routes
		for (local.route in application.wheels.routes) {

			// if method doesn't match, skip this route
			if (StructKeyExists(local.route, "methods")
					&& !ListFindNoCase(local.route.methods, arguments.requestMethod))
				continue;

			// make sure route has been converted to regex
			if (!StructKeyExists(local.route, "regex"))
				local.route.regex = application.wheels.mapper.patternToRegex(local.route.pattern);

			// if route matches regular expression, set it for return
			if (REFindNoCase(local.route.regex, arguments.path)
					OR (arguments.path == "" && local.route.pattern == "/")) {
				local.rv = Duplicate(local.route);
				break;
			}
		}

		// throw error if no route was found
		if (NOT StructKeyExists(local, "rv"))
			$throw(
					type="Wheels.RouteNotFound"
				, message="Wheels couldn't find a route that matched this request."
				, extendedInfo="Make sure there is a route setup in your 'config/routes.cfm' file that matches the '#arguments.path#' request."
			);

		return local.rv;
	}

	public string function $getPathFromRequest(required string pathInfo, required string scriptName) {

		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
		{
			local.rv = "";
		}
		else
		{
			local.rv = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
		}
		return local.rv;
	}

	public string function $request(
		string pathInfo=request.cgi.path_info,
		string scriptName=request.cgi.script_name,
		struct formScope=form,
		struct urlScope=url
	) {
		if (get("showDebugInformation"))
		{
			$debugPoint("setup");
		}

		local.params = $paramParser(argumentCollection=arguments);

		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = local.params;

		if (get("showDebugInformation"))
		{
			$debugPoint("setup");
		}

		// create the requested controller and call the action on it
		local.controller = controller(name=local.params.controller, params=local.params);
		local.controller.processAction();

		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (local.controller.$performedRedirect())
		{
			$location(argumentCollection=local.controller.getRedirect());
		}

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		local.controller.$flashClear();

		local.rv = local.controller.response();
		return local.rv;
	}

	public struct function $paramParser(
		string pathInfo=request.cgi.path_info,
		string scriptName=request.cgi.script_name,
		struct formScope=form,
		struct urlScope=url
	) {
		local.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
		local.route = $findMatchingRoute(path=local.path);
		local.rv = $createParams(path=local.path, route=local.route, formScope=arguments.formScope, urlScope=arguments.urlScope);
		return local.rv;
	}

	/**
	*  @hint Merges the URL and form scope into a single structure, URL scope has precedence.
	*/
	public struct function $mergeUrlAndFormScopes(
		required struct params,
		required struct urlScope,
		required struct formScope
	) {
		StructAppend(arguments.params, arguments.formScope);
		StructAppend(arguments.params, arguments.urlScope);

		// get rid of the fieldnames
		StructDelete(arguments.params, "fieldnames");
		return arguments.params;
	}

	/**
	*  @hint Parses the route pattern, identifies the variable markers within the pattern and assigns the value from the url variables with the path.
	*/
	public struct function $mergeRoutePattern(
		required struct params,
		required struct route,
		required string path
	) {

		local.rv = arguments.params;
		local.matches = REFindNoCase(arguments.route.regex, arguments.path, 1, true);
		local.iEnd = ArrayLen(local.matches.pos);

		for (local.i = 2; local.i LTE local.iEnd; local.i++) {
			local.key = ListGetAt(arguments.route.variables, local.i - 1);
			local.rv[local.key] = Mid(arguments.path, local.matches.pos[local.i], local.matches.len[local.i]);
		}

		return local.rv;
	}

	/**
	*  @hint Loops through the params struct passed in and attempts to deobfuscate them. ignores the controller and action params values.
	*/
	public struct function $decryptParams(required struct params) {
		local.rv = arguments.params;
		if (get("obfuscateUrls"))
		{
			for (local.key in local.rv)
			{
				if (local.key != "controller" && local.key != "action")
				{
					try
					{
						local.rv[local.key] = deobfuscateParam(local.rv[local.key]);
					}
					catch (any e) {}
				}
			}
		}
		return local.rv;
	}

	/**
	*  @hint Loops through the params struct and handle the cases where checkboxes are unchecked.
	*/
	public struct function $translateBlankCheckBoxSubmissions(required struct params) {
		local.rv = arguments.params;
		for (local.key in local.rv)
		{
			if (FindNoCase("($checkbox)", local.key))
			{
				// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to the unchecked values for the checkbox (to get around the problem that unchecked checkboxes don't post at all)
				local.formParamName = ReplaceNoCase(local.key, "($checkbox)", "");
				if (!StructKeyExists(local.rv, local.formParamName))
				{
					local.rv[local.formParamName] = local.rv[local.key];
				}
				StructDelete(local.rv, local.key);
			}
		}
		return local.rv;
	}

	/**
	*  @hint Combines date parts into a single value.
	*/
	public struct function $translateDatePartSubmissions(required struct params) {
		local.rv = arguments.params;
		local.dates = {};
		for (local.key in local.rv)
		{
			if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second|\$ampm)\)$", local.key))
			{
				local.temp = ListToArray(local.key, "(");
				local.firstKey = local.temp[1];
				local.secondKey = SpanExcluding(local.temp[2], ")");
				if (!StructKeyExists(local.dates, local.firstKey))
				{
					local.dates[local.firstKey] = {};
				}
				local.dates[local.firstKey][ReplaceNoCase(local.secondKey, "$", "")] = local.rv[local.key];
			}
		}
		for (local.key in local.dates)
		{
			if (!StructKeyExists(local.dates[local.key], "year"))
			{
				local.dates[local.key].year = 1899;
			}
			if (!StructKeyExists(local.dates[local.key], "month"))
			{
				local.dates[local.key].month = 1;
			}
			if (!StructKeyExists(local.dates[local.key], "day"))
			{
				local.dates[local.key].day = 1;
			}
			if (!StructKeyExists(local.dates[local.key], "hour"))
			{
				local.dates[local.key].hour = 0;
			}
			if (!StructKeyExists(local.dates[local.key], "minute"))
			{
				local.dates[local.key].minute = 0;
			}
			if (!StructKeyExists(local.dates[local.key], "second"))
			{
				local.dates[local.key].second = 0;
			}
			if (StructKeyExists(local.dates[local.key], "ampm"))
			{
				if (local.dates[local.key].ampm == "am" && local.dates[local.key].hour == 12)
				{
					local.dates[local.key].hour = 0;
				}
				else if (local.dates[local.key].ampm == "pm" && local.dates[local.key].hour != 12)
				{
					local.dates[local.key].hour += 12;
				}
			}
			try
			{
				local.rv[local.key] = CreateDateTime(local.dates[local.key].year, local.dates[local.key].month, local.dates[local.key].day, local.dates[local.key].hour, local.dates[local.key].minute, local.dates[local.key].second);
			}
			catch (any e)
			{
				local.rv[local.key] = "";
			}
			StructDelete(local.rv, local.key & "($year)");
			StructDelete(local.rv, local.key & "($month)");
			StructDelete(local.rv, local.key & "($day)");
			StructDelete(local.rv, local.key & "($hour)");
			StructDelete(local.rv, local.key & "($minute)");
			StructDelete(local.rv, local.key & "($second)");
		}
		return local.rv;
	}

	/**
	*  @hint Ensure that the controller and action params exists and camelized.
	*/
	public struct function $ensureControllerAndAction(required struct params, required struct route) {
		local.rv = arguments.params;
		if (!StructKeyExists(local.rv, "controller"))
		{
			local.rv.controller = arguments.route.controller;
		}
		if (!StructKeyExists(local.rv, "action"))
		{
			local.rv.action = arguments.route.action;
		}

		// we now need to have dot notation allowed in the controller hence the \.
		local.rv.controller = ReReplace(local.rv.controller, "[^0-9A-Za-z-_\.]", "", "all");
		// filter out illegal characters from the controller and action arguments
		local.rv.action = ReReplace(local.rv.action, "[^0-9A-Za-z-_\.]", "", "all");

		// convert controller to upperCamelCase
		local.cName = ListLast(local.rv.controller, ".");
		local.cName = REReplace(local.cName, "(^|-)([a-z])", "\u\2", "all");
		local.cLen = ListLen(local.rv.controller, ".");
		local.rv.controller = ListSetAt(local.rv.controller, local.cLen, local.cName, ".");

		// action to normal camelCase
		local.rv.action = REReplace(local.rv.action, "-([a-z])", "\u\1", "all");
		return local.rv;
	}

	/**
	*  @hint Adds in the format variable from the route if it exists.
	*/
	public struct function $addRouteFormat(required struct params, required struct route) {
		local.rv = arguments.params;
		if (StructKeyExists(arguments.route, "formatVariable") && StructKeyExists(arguments.route, "format"))
		{
			local.rv[arguments.route.formatVariable] = arguments.route.format;
		}
		return local.rv;
	}

	/**
	*  @hint Adds in the name variable from the route if it exists.
	*/
	public struct function $addRouteName(required struct params, required struct route) {
		local.rv = arguments.params;
		if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(local.rv, "route"))
		{
			local.rv.route = arguments.route.name;
		}
		return local.rv;
	}

	/**
	 *  @hint Determine HTTP verb used in request
	 */
	public string function $getRequestMethod() {
		// if request is a post, check for alternate verb
		if (request.cgi.request_method == "post" && StructKeyExists(form, "_method"))
			return form["_method"];

		// if request is a get, check for alternate verb
		if (request.cgi.request_method == "get" && StructKeyExists(url, "_method"))
			return url["_method"];

		return request.cgi.request_method;
	}
</cfscript>
