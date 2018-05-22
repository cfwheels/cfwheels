<cfscript>

/**
 * Returns itself (the Dispatch object).
 */
public any function $init() {
	return this;
}

/**
 * Create a struct to hold the params, merge form and url scopes into it, add JSON body etc.
 */
public struct function $createParams(
	required string path,
	required struct route,
	required struct formScope,
	required struct urlScope
) {
	local.rv = {};
	local.rv = $mergeUrlAndFormScopes(params=local.rv, urlScope=arguments.urlScope, formScope=arguments.formScope);
	local.rv = $parseJsonBody(params=local.rv);
	local.rv = $mergeRoutePattern(params=local.rv, route=arguments.route, path=arguments.path);
	local.rv = $deobfuscateParams(params=local.rv);
	local.rv = $translateBlankCheckBoxSubmissions(params=local.rv);
	local.rv = $translateDatePartSubmissions(params=local.rv);
	local.rv = $createNestedParamStruct(params=local.rv);

	// Do the routing / controller params after all other params so that we don't have more logic around params in arrays.
	local.rv = $ensureControllerAndAction(params=local.rv, route=arguments.route);
	local.rv = $addRouteFormat(params=local.rv, route=arguments.route);
	local.rv = $addRouteName(params=local.rv, route=arguments.route);

	return local.rv;
}

/**
 * Internal function.
 */
public struct function $createNestedParamStruct(required struct params) {
	local.rv = arguments.params;
	for (local.key in local.rv) {
		if (Find("[", local.key) && Right(local.key, 1) == "]") {

			// Object form field.
			local.name = SpanExcluding(local.key, "[");

			// We split the key into an array so the developer can have unlimited levels of params passed in.
			local.nested = ListToArray(ReplaceList(local.key, local.name & "[,]", ""), "[", true);
			if (!StructKeyExists(local.rv, local.name)) {
				local.rv[local.name] = {};
			}

			// We need a reference to the struct so we can nest other structs if needed.
			// Looping over the array allows for infinite nesting.
			local.struct = local.rv[local.name];
			local.iEnd = ArrayLen(local.nested);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				if (IsStruct(local.struct)) {
					local.item = local.nested[local.i];
					if (!StructKeyExists(local.struct, local.item)) {
						local.struct[local.item] = {};
					}
					if (local.i != local.iEnd) {

						// Pass the new reference (structs pass a reference instead of a copy) to the next iteration.
						local.struct = local.struct[local.item];

					} else {
						local.struct[local.item] = local.rv[local.key];
					}
				}
			}

			// Delete the original key so it doesn't show up in the params.
			StructDelete(local.rv, local.key);

		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public struct function $findMatchingRoute(required string path, string requestMethod=$getRequestMethod()) {

	// If this is a HEAD request, look for the corresponding GET route
	if (arguments.requestMethod == 'HEAD'){
		arguments.requestMethod = 'GET'; 
	}

	// Loop over Wheels routes.
	for (local.route in application.wheels.routes) {

		// If method doesn't match, skip this route.
		if (StructKeyExists(local.route, "methods") && !ListFindNoCase(local.route.methods, arguments.requestMethod)) {
			continue;
		}

		// Make sure route has been converted to regular expression.
		if (!StructKeyExists(local.route, "regex")) {
			local.route.regex = application.wheels.mapper.$patternToRegex(local.route.pattern);
		}

		// If route matches regular expression, set it for return.
		if (REFindNoCase(local.route.regex, arguments.path) || (!Len(arguments.path) && local.route.pattern == "/")) {
			local.rv = Duplicate(local.route);
			break;
		}

	}

	// If returned route contains a redirect, execute that asap
	if(structKeyExists(local, "rv") && structKeyExists(local.rv, "redirect")){
		$location(url=local.rv.redirect, addToken=false);
	}

	// Throw error if no route was found.
	if (!StructKeyExists(local, "rv")) {

		local.alternativeMatchingMethodsForURL="";

		// Try and provide some more information for why the route hasn't matched:
		// For example, the developer is accidentally GETing to a route which only allows POST
		for (local.route in application.wheels.routes) {

			// Make sure route has been converted to regular expression.
			if (!StructKeyExists(local.route, "regex")) {
				local.route.regex = application.wheels.mapper.$patternToRegex(local.route.pattern);
			}

			// If route matches regular expression, append to alternatives to display
			if (REFindNoCase(local.route.regex, arguments.path) || (!Len(arguments.path) && local.route.pattern == "/")) {
				local.alternativeMatchingMethodsForURL=ListAppend(local.alternativeMatchingMethodsForURL, local.route.methods);
			}
		}

		// If we have any routes which match the regex, but not the method, add this information to the error message.
		if ( len(local.alternativeMatchingMethodsForURL) ) {
			$throwErrorOrShow404Page(
				type="Wheels.RouteNotFound",
				message="Incorrect HTTP Verb for route",
				extendedInfo="The `#arguments.path#` path does not allow `#arguments.requestMethod#` requests, only `#UCASE(local.alternativeMatchingMethodsForURL)#` requests. Ensure you are using the correct HTTP Verb and that your `config/routes.cfm` file is configured correctly."
			);
		} else {
			$throwErrorOrShow404Page(
				type="Wheels.RouteNotFound",
				message="Could not find a route that matched this request.",
				extendedInfo="Make sure there is a route configured in your `config/routes.cfm` file that matches the `#arguments.path#` request."
			);

		}
	}

	return local.rv;
}

/**
 * Return the path without the leading "/".
 */
public string function $getPathFromRequest(required string pathInfo, required string scriptName) {
	if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || !Len(arguments.pathInfo)) {
		return "";
	} else {
		return Right(arguments.pathInfo, Len(arguments.pathInfo) - 1);
	}
}

/**
 * Parse incoming params, create controller object, call an action on it and return the response.
 * Called from index.cfm in the root so what we return here is the final result of the request processing.
 */
public string function $request(
	string pathInfo=request.cgi.path_info,
	string scriptName=request.cgi.script_name,
	struct formScope=form,
	struct urlScope=url
) {
	if ($get("showDebugInformation")) {
		$debugPoint("setup");
	}

	local.params = $paramParser(argumentCollection=arguments);

	// Set params in the request scope as well so we can display it in the debug info outside of the controller context.
	request.wheels.params = local.params;

	if ($get("showDebugInformation")) {
		$debugPoint("setup");
	}

	// Create the requested controller and call the action on it.
	local.controller = controller(name=local.params.controller, params=local.params);
	local.controller.processAction();

	// If there is a delayed redirect pending we execute it here thus halting the rest of the request.
	if (local.controller.$performedRedirect()) {
		$location(argumentCollection=local.controller.getRedirect());
	}

	// Clear out the flash (note that this is not done for redirects since the processing does not get here).
	local.controller.$flashClear();

	return local.controller.response();
}

/**
 * Find the route that matches the path, create params struct and return it.
 */
public struct function $paramParser(
	string pathInfo=request.cgi.path_info,
	string scriptName=request.cgi.script_name,
	struct formScope=form,
	struct urlScope=url
) {
	local.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
	local.route = $findMatchingRoute(path=local.path);
	return $createParams(path=local.path, route=local.route, formScope=arguments.formScope, urlScope=arguments.urlScope);
}

/**
 * Merges the URL and form scope into a single structure, URL scope has precedence.
 */
public struct function $mergeUrlAndFormScopes(
	required struct params,
	required struct urlScope,
	required struct formScope
) {
	StructAppend(arguments.params, arguments.formScope);
	StructAppend(arguments.params, arguments.urlScope);

	// Get rid of the unnecessary "fieldnames" key that ACF always adds to the form scope.
	StructDelete(arguments.params, "fieldnames");

	return arguments.params;
}

/**
 * If content type is JSON, deserialize it into a struct and add to the params struct.
 */
public struct function $parseJsonBody(required struct params) {
	local.headers = request.wheels.httpRequestData.headers;
	local.content = request.wheels.httpRequestData.content;
	if (StructKeyExists(local.headers, "Content-Type")) {
		// Content-Type may also include charset so we need only check the first item in the list
		local.type = spanExcluding(local.headers["Content-Type"],";");

		// Only proceed if the content type is JSON.
		// Allow multiple JSON content types by checking the start and end of the string.
		// This way we allow both "application/json" and "application/vnd.api+json" (JSON API) for example.
		if (Left(local.type, 12) == "application/" && Right(local.type, 4) == "json") {

			// On ACF we need to convert from binary to a string before we can work with it.
			if (IsBinary(local.content)) {
				local.content = ToString(local.content);
			}

			// If what we have now is valid JSON, deserialize it to a struct and append to params.
			// Call with "false" so existing form and URL values take precedence.
			if (IsJSON(local.content)) {
				StructAppend(arguments.params, DeserializeJSON(local.content), false);
			}

		}

	}
	return arguments.params;
}

/**
 * Parses the route pattern, identifies the variable markers within the pattern and assigns the value from the url variables with the path.
 */
public struct function $mergeRoutePattern(required struct params, required struct route, required string path) {
	local.rv = arguments.params;
	local.matches = REFindNoCase(arguments.route.regex, arguments.path, 1, true);
	local.iEnd = ArrayLen(local.matches.pos);
	for (local.i = 2; local.i <= local.iEnd; local.i++) {
		local.key = ListGetAt(arguments.route.variables, local.i - 1);
		local.rv[local.key] = Mid(arguments.path, local.matches.pos[local.i], local.matches.len[local.i]);
	}
	return local.rv;
}

/**
 * Loops through the params struct passed in and attempts to deobfuscate it.
 * Ignores the controller and action params values.
 */
public struct function $deobfuscateParams(required struct params) {
	local.rv = arguments.params;
	if ($get("obfuscateUrls")) {
		for (local.key in local.rv) {
			if (local.key != "controller" && local.key != "action") {
				try {
					local.rv[local.key] = deobfuscateParam(local.rv[local.key]);
				} catch (any e) {}
			}
		}
	}
	return local.rv;
}

/**
 * Loops through the params struct and handle the cases where checkboxes are unchecked.
 */
public struct function $translateBlankCheckBoxSubmissions(required struct params) {
	local.rv = arguments.params;
	for (local.key in local.rv) {
		if (FindNoCase("($checkbox)", local.key)) {

			// If no other form parameter exists with this name it means that the checkbox was left blank.
			// Therefore we force the value to the unchecked value for the checkbox.
			// This gets around the problem that unchecked checkboxes don't post at all.
			local.formParamName = ReplaceNoCase(local.key, "($checkbox)", "");
			if (!StructKeyExists(local.rv, local.formParamName)) {
				local.rv[local.formParamName] = local.rv[local.key];
			}

			StructDelete(local.rv, local.key);
		}
	}
	return local.rv;
}

/**
 * Combines date parts into a single value.
 */
public struct function $translateDatePartSubmissions(required struct params) {
	local.rv = arguments.params;
	local.dates = {};
	for (local.key in local.rv) {
		if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second|\$ampm)\)$", local.key)) {
			local.temp = ListToArray(local.key, "(");
			local.firstKey = local.temp[1];
			local.secondKey = SpanExcluding(local.temp[2], ")");
			if (!StructKeyExists(local.dates, local.firstKey)) {
				local.dates[local.firstKey] = {};
			}
			local.dates[local.firstKey][ReplaceNoCase(local.secondKey, "$", "")] = local.rv[local.key];
		}
	}
	for (local.key in local.dates) {
		if (!StructKeyExists(local.dates[local.key], "year")) {
			local.dates[local.key].year = 1899;
		}
		if (!StructKeyExists(local.dates[local.key], "month")) {
			local.dates[local.key].month = 1;
		}
		if (!StructKeyExists(local.dates[local.key], "day")) {
			local.dates[local.key].day = 1;
		}
		if (!StructKeyExists(local.dates[local.key], "hour")) {
			local.dates[local.key].hour = 0;
		}
		if (!StructKeyExists(local.dates[local.key], "minute")) {
			local.dates[local.key].minute = 0;
		}
		if (!StructKeyExists(local.dates[local.key], "second")) {
			local.dates[local.key].second = 0;
		}
		if (StructKeyExists(local.dates[local.key], "ampm")) {
			if (local.dates[local.key].ampm == "am" && local.dates[local.key].hour == 12) {
				local.dates[local.key].hour = 0;
			} else if (local.dates[local.key].ampm == "pm" && local.dates[local.key].hour != 12) {
				local.dates[local.key].hour += 12;
			}
		}
		try {
			local.rv[local.key] = CreateDateTime(
				local.dates[local.key].year,
				local.dates[local.key].month,
				local.dates[local.key].day,
				local.dates[local.key].hour,
				local.dates[local.key].minute,
				local.dates[local.key].second
			);
		} catch (any e) {
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
 * Ensure that the controller and action params exist and are camelized.
 */
public struct function $ensureControllerAndAction(required struct params, required struct route) {
	local.rv = arguments.params;
	if (!StructKeyExists(local.rv, "controller")) {
		local.rv.controller = arguments.route.controller;
	}
	if (!StructKeyExists(local.rv, "action")) {
		local.rv.action = arguments.route.action;
	}

	// We now need to have dot notation allowed in the controller hence the \.
	local.rv.controller = ReReplace(local.rv.controller, "[^0-9A-Za-z-_\.]", "", "all");

	// Filter out illegal characters from the controller and action arguments.
	local.rv.action = ReReplace(local.rv.action, "[^0-9A-Za-z-_\.]", "", "all");

	// Convert controller to upperCamelCase.
	local.cName = ListLast(local.rv.controller, ".");
	local.cName = REReplace(local.cName, "(^|-)([a-z])", "\u\2", "all");
	local.cLen = ListLen(local.rv.controller, ".");
	if (local.cLen) {
		local.rv.controller = ListSetAt(local.rv.controller, local.cLen, local.cName, ".");
	}

	// Action to normal camelCase.
	local.rv.action = REReplace(local.rv.action, "-([a-z])", "\u\1", "all");

	return local.rv;
}

/**
 * Adds in the format variable from the route if it exists.
 */
public struct function $addRouteFormat(required struct params, required struct route) {
	local.rv = arguments.params;
	if (StructKeyExists(arguments.route, "formatVariable") && StructKeyExists(arguments.route, "format")) {
		local.rv[arguments.route.formatVariable] = arguments.route.format;
	}
	return local.rv;
}

/**
 * Adds in the name variable from the route if it exists.
 */
public struct function $addRouteName(required struct params, required struct route) {
	local.rv = arguments.params;
	if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(local.rv, "route")) {
		local.rv.route = arguments.route.name;
	}
	return local.rv;
}

/**
 * Determine HTTP verb used in request.
 */
public string function $getRequestMethod() {

	// If request is a post, check for alternate verb.
	if (request.cgi.request_method == "post" && StructKeyExists(form, "_method")) {
		return form["_method"];
	}

	// If request is a get, check for alternate verb.
	if (request.cgi.request_method == "get" && StructKeyExists(url, "_method")) {
		return url["_method"];
	}

	return request.cgi.request_method;
}

</cfscript>
