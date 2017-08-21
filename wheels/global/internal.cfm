<cfscript>

/**
 * Call CFML's canonicalize() function but set to blank string if the result is null (happens on Lucee 5).
 */
public string function $canonicalize(required string input) {
	local.rv = canonicalize(arguments.input, false, false);
	if (IsNull(local.rv)) {
		local.rv = "";
	}
	return local.rv;
}

/**
 * Get the status code (e.g. 200, 404 etc) of the response we're about to send.
 */
public string function $statusCode() {
	if (StructKeyExists(server, "lucee")) {
		local.response = getPageContext().getResponse();
	} else {
		local.response = getPageContext().getFusionContext().getResponse();
	}
	return local.response.getStatus();
}

/**
 * Gets the value of the content type header (blank string if it doesn't exist) of the response we're about to send.
 */
public string function $contentType() {
	local.rv = "";
	if (StructKeyExists(server, "lucee")) {
		local.response = getPageContext().getResponse();
	} else {
		local.response = getPageContext().getFusionContext().getResponse();
	}
	if (local.response.containsHeader("Content-Type")) {
		local.header = local.response.getHeader("Content-Type");
		if (!IsNull(local.header)) {
			local.rv = local.header;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $initializeRequestScope() {
	if (!StructKeyExists(request, "wheels")) {
		request.wheels = {};
		request.wheels.params = {};
		request.wheels.cache = {};
		request.wheels.stacks = {};
		request.wheels.urlForCache = {};
		request.wheels.tickCountId = GetTickCount();

		// Copy HTTP request data (contains content, headers, method and protocol).
		// This makes internal testing easier since we can overwrite it temporarily from the test suite.
		request.wheels.httpRequestData = GetHttpRequestData();

		// Create a structure to track the transaction status for all adapters.
		request.wheels.transactions = {};

	}
}

/**
 * Internal function.
 */
public xml function $toXml(required any data) {
	// only instantiate the toXml object once per request
	if (!StructKeyExists(request.wheels, "toXml")) {
		request.wheels.toXml = $createObjectFromRoot(path="#application.wheels.wheelsComponentPath#.vendor.toXml", fileName="toXML", method="init");
	}
	return request.wheels.toXml.toXml(arguments.data);
}

/**
 * Internal function.
 */
public string function $convertToString(required any value, string type="") {
	if (!Len(arguments.type)) {
		if (IsArray(arguments.value)) {
			arguments.type = "array";
		} else if (IsStruct(arguments.value)) {
			arguments.type = "struct";
		} else if (IsBinary(arguments.value)) {
			arguments.type = "binary";
		} else if (IsNumeric(arguments.value)) {
			arguments.type = "integer";
		} else if (IsDate(arguments.value)) {
			arguments.type = "datetime";
		}
	}
	switch (arguments.type) {
		case "array":
			arguments.value = ArrayToList(arguments.value);
			break;
		case "struct":
			local.str = "";
			local.keyList = ListSort(StructKeyList(arguments.value), "textnocase", "asc");
			local.iEnd = ListLen(local.keyList);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.key = ListGetAt(local.keyList, local.i);
				local.str = ListAppend(local.str, local.key & "=" & arguments.value[local.key]);
			}
			arguments.value = local.str;
			break;
		case "binary":
			arguments.value = ToString(arguments.value);
			break;
		case "float": case "integer":
			if (!Len(arguments.value)) {
				return "";
			}
			if (arguments.value == "true") {
				return 1;
			}
			arguments.value = Val(arguments.value);
			break;
		case "boolean":
			if (Len(arguments.value)) {
				arguments.value = (arguments.value IS true);
			}
			break;
		case "datetime":
			// createdatetime will throw an error
			if (IsDate(arguments.value)) {
				arguments.value = CreateDateTime(Year(arguments.value), Month(arguments.value), Day(arguments.value), Hour(arguments.value), Minute(arguments.value), Second(arguments.value));
			}
			break;
	}
	return arguments.value;
}

/**
 * Internal function.
 */
public any function $cleanInlist(required string where) {
	local.rv = arguments.where;
	local.regex = "IN\s?\(.*?,\s.*?\)";
	local.in = REFind(local.regex, local.rv, 1, true);
	while (local.in.len[1]) {
		local.str = Mid(local.rv, local.in.pos[1], local.in.len[1]);
		local.rv = RemoveChars(local.rv, local.in.pos[1], local.in.len[1]);
		local.cleaned = $listClean(local.str);
		local.rv = Insert(local.cleaned, local.rv, local.in.pos[1]-1);
		local.in = REFind(local.regex, local.rv, local.in.pos[1] + Len(local.cleaned), true);
	}
	return local.rv;
}

/**
 * Removes whitespace between list elements.
 * Optional argument to return the list as an array.
 */
public any function $listClean(
	required string list,
	string delim=",",
	string returnAs="string"
) {
	local.rv = ListToArray(arguments.list, arguments.delim);
	local.iEnd = ArrayLen(local.rv);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.rv[local.i] = Trim(local.rv[local.i]);
	}
	if (arguments.returnAs != "array") {
		local.rv = ArrayToList(local.rv, arguments.delim);
	}
	return local.rv;
}

/**
 * Creates a unique string based on any arguments passed in (used as a key for caching mostly).
 */
public string function $hashedKey() {
	local.rv = "";

	// make all cache keys domain specific (do not use request scope below since it may not always be initialized)
	StructInsert(arguments, ListLen(StructKeyList(arguments)) + 1, cgi.http_host, true);

	// we need to make sure we are looping through the passed in arguments in the same order everytime
	local.values = [];
	local.keyList = ListSort(StructKeyList(arguments), "textnocase", "asc");
	local.iEnd = ListLen(local.keyList);
	for (local.i = 1; local.i <= local.iEnd; local.i++)
	{
		ArrayAppend(local.values, arguments[ListGetAt(local.keyList, local.i)]);
	}

	if (!ArrayIsEmpty(local.values)) {
		// this might fail if a query contains binary data so in those rare cases we fall back on using cfwddx (which is a little bit slower which is why we don't use it all the time)
		try {
			local.rv = SerializeJSON(local.values);

			// remove the characters that indicate array or struct so that we can sort it as a list below
			local.rv = ReplaceList(local.rv, "{,},[,],/", ",,,,");
			local.rv = ListSort(local.rv, "text");
		} catch (any e) {
			local.rv = $wddx(input=local.values);
		}
	}
	return Hash(local.rv);
}

/**
 * Internal function.
 */
public any function $timeSpanForCache(
	required any cache,
	numeric defaultCacheTime=application.wheels.defaultCacheTime,
	string cacheDatePart=application.wheels.cacheDatePart
) {
	local.cache = arguments.defaultCacheTime;
	if (IsNumeric(arguments.cache)) {
		local.cache = arguments.cache;
	}
	local.list = "0,0,0,0";
	local.dateParts = "d,h,n,s";
	local.iEnd = ListLen(local.dateParts);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		if (arguments.cacheDatePart == ListGetAt(local.dateParts, local.i)) {
			local.list = ListSetAt(local.list, local.i, local.cache);
		}
	}
	local.rv = CreateTimeSpan(ListGetAt(local.list, 1), ListGetAt(local.list, 2), ListGetAt(local.list, 3), ListGetAt(local.list, 4));
	return local.rv;
}

/**
 * Internal function.
 */
public void function $combineArguments(
	required struct args,
	required string combine,
	required boolean required=false,
	string extendedInfo=""
) {
	local.first = ListGetAt(arguments.combine, 1);
	local.second = ListGetAt(arguments.combine, 2);
	if (StructKeyExists(arguments.args, local.second)) {
		arguments.args[local.first] = arguments.args[local.second];
		StructDelete(arguments.args, local.second);
	}
	if (arguments.required && application.wheels.showErrorInformation) {
		if (!StructKeyExists(arguments.args, local.first) || !Len(arguments.args[local.first])) {
			Throw(type="Wheels.IncorrectArguments", message="The `#local.second#` or `#local.first#` argument is required but was not passed in.", extendedInfo="#arguments.extendedInfo#");
		}
	}
}


/**
 * Check to see if all keys in the list exist for the structure and have length.
 */
public boolean function $structKeysExist(required struct struct, string keys="") {
	local.rv = true;
	local.iEnd = ListLen(arguments.keys);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		if (!StructKeyExists(arguments.struct, ListGetAt(arguments.keys, local.i)) || (IsSimpleValue(arguments.struct[ListGetAt(arguments.keys, local.i)]) && !Len(arguments.struct[ListGetAt(arguments.keys, local.i)]))) {
			local.rv = false;
			break;
		}
	}
	return local.rv;
}

/**
 * This copies all the variables CFWheels needs from the CGI scope to the request scope.
 */
public struct function $cgiScope(
	string keys="request_method,http_x_requested_with,http_referer,server_name,path_info,script_name,query_string,remote_addr,server_port,server_port_secure,server_protocol,http_host,http_accept,content_type,http_x_rewrite_url,http_x_original_url,request_uri,redirect_url",
	struct scope=cgi
) {
	local.rv = {};
	local.iEnd = ListLen(arguments.keys);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.keys, local.i);
		local.rv[local.item] = arguments.scope[local.item];
	}

	// fix path_info if it contains any characters that are not ascii (see issue 138)
	if (StructKeyExists(arguments.scope, "unencoded_url") && Len(arguments.scope.unencoded_url)) {
		local.requestUrl = URLDecode(arguments.scope.unencoded_url);
	} else if (IsSimpleValue(getPageContext().getRequest().getRequestURL())) {
		// remove protocol, domain, port etc from the url
		local.requestUrl = "/" & ListDeleteAt(ListDeleteAt(URLDecode(getPageContext().getRequest().getRequestURL()), 1, "/"), 1, "/");
	}
	if (StructKeyExists(local, "requestUrl") && REFind("[^\0-\x80]", local.requestUrl)) {
		// strip out the script_name and query_string leaving us with only the part of the string that should go in path_info
		local.rv.path_info = Replace(Replace(local.requestUrl, arguments.scope.script_name, ""), "?" & URLDecode(arguments.scope.query_string), "");
	}

	// fixes IIS issue that returns a blank cgi.path_info
	if (!Len(local.rv.path_info) && Right(local.rv.script_name, 12) == "/rewrite.cfm") {
		if (Len(local.rv.http_x_rewrite_url)) {
			// IIS6 1/ IIRF (Ionics Isapi Rewrite Filter)
			local.rv.path_info = ListFirst(local.rv.http_x_rewrite_url, "?");
		} else if (Len(local.rv.http_x_original_url)) {
			// IIS7 rewrite default
			local.rv.path_info = ListFirst(local.rv.http_x_original_url, "?");
		} else if (Len(local.rv.request_uri)) {
			// Apache default
			local.rv.path_info = ListFirst(local.rv.request_uri, "?");
		} else if (Len(local.rv.redirect_url)) {
			// Apache fallback
			local.rv.path_info = ListFirst(local.rv.redirect_url, "?");
		}

		// finally lets remove the index.cfm because some of the custom cgi variables don't bring it back
		// like this it means at the root we are working with / instead of /index.cfm
		if (Len(local.rv.path_info) >= 10 && Right(local.rv.path_info, 10) == "/index.cfm") {
			// this will remove the index.cfm and the trailing slash
			local.rv.path_info = Replace(local.rv.path_info, "/index.cfm", "");
			if (!Len(local.rv.path_info)) {
				// add back the forward slash if path_info was "/index.cfm"
				local.rv.path_info = "/";
			}
		}
	}

	// some web servers incorrectly place rewrite.cfm in the path_info but since that should never be there we can safely remove it
	if (Find("rewrite.cfm/", local.rv.path_info)) {
		Replace(local.rv.path_info, "rewrite.cfm/", "");
	}
	return local.rv;
}

/**
 * Creates a struct of the named arguments passed in to a function (i.e. the ones not explicitly defined in the arguments list).
 *
 * @defined List of already defined arguments that should not be added.
 */
public struct function $namedArguments(required string $defined) {
	local.rv = {};
	for (local.key in arguments) {
		if (!ListFindNoCase(arguments.$defined, local.key) && Left(local.key, 1) != "$") {
			local.rv[local.key] = arguments[local.key];
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public struct function $dollarify(required struct input, required string on) {
	for (local.key in arguments.input) {
		if (ListFindNoCase(arguments.on, local.key)) {
			arguments.input["$" & local.key] = arguments.input[local.key];
			StructDelete(arguments.input, local.key);
		}
	}
	return arguments.input;
}

/**
 * Internal function.
 */
public void function $abortInvalidRequest() {
	local.applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
	local.callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
	if (ListLen(local.callingPath, "/") > ListLen(local.applicationPath, "/") || GetFileFromPath(local.callingPath) == "root.cfm") {
		if (StructKeyExists(application, "wheels")) {
			if (StructKeyExists(application.wheels, "showErrorInformation") && !application.wheels.showErrorInformation) {
				$header(statusCode=404, statustext="Not Found");
			}
			if (StructKeyExists(application.wheels, "eventPath")) {
				$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
			}
		}
		abort;
	}
}

/**
 * Internal function.
 */
public string function $routeVariables() {
	return $findRoute(argumentCollection=arguments).variables;
}

/**
 * Internal function.
 */
public struct function $findRoute() {

	// Throw error if no route was found.
	if (!StructKeyExists(application.wheels.namedRoutePositions, arguments.route)) {
		$throwErrorOrShow404Page(
			type="Wheels.RouteNotFound",
			message="Could not find the `#arguments.route#` route.",
			extendedInfo="Make sure there is a route configured in your `config/routes.cfm` file named `#arguments.route#`."
		);
	}

	local.routePos = application.wheels.namedRoutePositions[arguments.route];
	if (Find(",", local.routePos)) {
		// there are several routes with this name so we need to figure out which one to use by checking the passed in arguments
		local.iEnd = ListLen(local.routePos);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.rv = application.wheels.routes[ListGetAt(local.routePos, local.i)];
			local.foundRoute = true;
			local.jEnd = ListLen(local.rv.variables);
			for (local.j = 1; local.j <= local.jEnd; local.j++) {
				local.variable = ListGetAt(local.rv.variables, local.j);
				if (!StructKeyExists(arguments, local.variable) || !Len(arguments[local.variable])) {
					local.foundRoute = false;
				}
			}
			if (local.foundRoute) {
				break;
			}
		}
	} else {
		local.rv = application.wheels.routes[local.routePos];
	}
	return local.rv;
}

/**
 * Internal function.
 */
public any function $cachedModelClassExists(required string name) {
	local.rv = false;
	if (StructKeyExists(application.wheels.models, arguments.name)) {
		local.rv = application.wheels.models[arguments.name];
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $constructParams(required string params, boolean encode=true, boolean $encodeForHtmlAttribute=false, string $URLRewriting=application.wheels.URLRewriting) {

	// When rewriting is off we will already have "?controller=" etc in the url so we have to continue with an ampersand.
	if (arguments.$URLRewriting == "Off") {
		local.delim = "&";
	} else {
		local.delim = "?";
	}

	local.rv = "";
	local.iEnd = ListLen(arguments.params, "&");
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.params = listToArray(ListGetAt(arguments.params, local.i, "&"), "=");
		local.name = local.params[1];
		if (arguments.encode && $get("encodeURLs")) {
			local.name = EncodeForURL($canonicalize(local.name));
			if (arguments.$encodeForHtmlAttribute) {
				local.name = EncodeForHtmlAttribute(local.name);
			}
		}
		local.rv &= local.delim & local.name & "=";
		local.delim = "&";
		if (ArrayLen(local.params) == 2) {
			local.value = local.params[2];
			if (arguments.encode && $get("encodeURLs")) {
				local.value = EncodeForURL($canonicalize(local.value));
				if (arguments.$encodeForHtmlAttribute) {
					local.value = EncodeForHtmlAttribute(local.value);
				}
			}

			// Obfuscate the param if set globally and we're not processing cfid or cftoken (can't touch those).
			// Wrap in double quotes because in Lucee we have to pass it in as a string otherwise leading zeros are stripped.
			if (application.wheels.obfuscateUrls && !ListFindNoCase("cfid,cftoken", local.name)) {
				local.value = obfuscateParam("#local.value#");
			}

			local.rv &= local.value;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $args(
	required struct args,
	required string name,
	string reserved="",
	string combine="",
	string required=""
) {
	if (Len(arguments.combine)) {
		local.iEnd = ListLen(arguments.combine);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(arguments.combine, local.i);
			local.first = ListGetAt(local.item, 1, "/");
			local.second = ListGetAt(local.item, 2, "/");
			local.required = false;
			if (ListLen(local.item, "/") > 2 || ListFindNoCase(local.first, arguments.required)) {
				local.required = true;
			}
			$combineArguments(args=arguments.args, combine="#local.first#,#local.second#", required=local.required);
		}
	}
	if (application.wheels.showErrorInformation) {
		if (ListLen(arguments.reserved)) {
			local.iEnd = ListLen(arguments.reserved);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.item = ListGetAt(arguments.reserved, local.i);
				if (StructKeyExists(arguments.args, local.item)) {
					Throw(
						type="Wheels.IncorrectArguments",
						message="The `#local.item#` argument cannot be passed in since it will be set automatically by Wheels."
					);
				}
			}
		}
	}
	if (StructKeyExists(application.wheels.functions, arguments.name)) {
		StructAppend(arguments.args, application.wheels.functions[arguments.name], false);
	}

	// make sure that the arguments marked as required exist
	if (Len(arguments.required)) {
		local.iEnd = ListLen(arguments.required);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.arg = ListGetAt(arguments.required, local.i);
			if (!StructKeyExists(arguments.args, local.arg)) {
				Throw(type="Wheels.IncorrectArguments", message="The `#local.arg#` argument is required but not passed in.");
			}
		}
	}
}

/**
 * Internal function.
 */
public any function $createObjectFromRoot(
	required string path,
	required string fileName,
	required string method
) {
	local.returnVariable = "local.rv";
	local.method = arguments.method;
	local.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
	local.argumentCollection = arguments;
	include "../../root.cfm";
	return local.rv;
}

/**
 * Internal function.
 */
public void function $debugPoint(required string name) {
	if (!StructKeyExists(request.wheels, "execution")) {
		request.wheels.execution = {};
	}
	local.iEnd = ListLen(arguments.name);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.item = ListGetAt(arguments.name, local.i);
		if (StructKeyExists(request.wheels.execution, local.item)) {
			request.wheels.execution[local.item] = GetTickCount() - request.wheels.execution[local.item];
		} else {
			request.wheels.execution[local.item] = GetTickCount();
		}
	}
}

/**
 * Internal function.
 */
public any function $cachedControllerClassExists(required string name) {
	local.rv = false;
	if (StructKeyExists(application.wheels.controllers, arguments.name)) {
		local.rv = application.wheels.controllers[arguments.name];
	}
	return local.rv;
}

/**
 * Internal function.
 */
public any function $fileExistsNoCase(required string absolutePath) {
	// return false by default when the file does not exist in the directory
	local.rv = false;

	// break up the full path string in the path name only and the file name only
	local.path = GetDirectoryFromPath(arguments.absolutePath);
	local.file = Replace(arguments.absolutePath, local.path, "");

	// get all existing files in the directory and place them in a list
	local.dirInfo = $directory(directory=local.path);
	local.fileList = ValueList(local.dirInfo.name);

	// loop through the file list and return the file name if exists regardless of case (the == operator is case insensitive)
	local.iEnd = ListLen(local.fileList);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.foundFile = ListGetAt(local.fileList, local.i);
		if (local.foundFile == local.file) {
			local.rv = local.foundFile;
			break;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $objectFileName(
	required string name,
	required string objectPath,
	required string type
) {
	// by default we return Model or Controller so that the base component gets loaded
	local.rv = capitalize(arguments.type);

	// we are going to store the full controller / model path in the
	// existing / non-existing lists so we can have controllers / models
	// in multiple places
	//
	// The name coming into $objectFileName could have dot notation due to
	// nested controllers so we need to change delims here on the name
	local.fullObjectPath = arguments.objectPath & "/" & ListChangeDelims(arguments.name, '/', '.');

	if (!ListFindNoCase(application.wheels.existingObjectFiles, local.fullObjectPath) && !ListFindNoCase(application.wheels.nonExistingObjectFiles, local.fullObjectPath)) {

		// we have not yet checked if this file exists or not so let's do that
		// here (the function below will return the file name with the correct
		// case if it exists, false if not)
		local.file = $fileExistsNoCase(Expandpath(local.fullObjectPath) & ".cfc");

		if (IsBoolean(local.file) && !local.file) {
			// no file exists, let's store that if caching is on so we don't have to check it again
			if (application.wheels.cacheFileChecking) {
				application.wheels.nonExistingObjectFiles = ListAppend(application.wheels.nonExistingObjectFiles, local.fullObjectPath);
			}
		} else {
			// the file exists, let's store the proper case of the file if caching is turned on
			local.file = SpanExcluding(local.file, ".");
			local.fullObjectPath = ListSetAt(local.fullObjectPath, ListLen(local.fullObjectPath, "/"), local.file, "/");
			if (application.wheels.cacheFileChecking) {
				application.wheels.existingObjectFiles = ListAppend(application.wheels.existingObjectFiles, local.fullObjectPath);
			}
		}
	}

	// if the file exists we return the file name in its proper case
	local.pos = ListFindNoCase(application.wheels.existingObjectFiles, local.fullObjectPath);
	if (local.pos) {
		local.file = ListLast(ListGetAt(application.wheels.existingObjectFiles, local.pos), "/");
	}

	// we've found a file so we'll need to send back the corrected name
	// argument as it could have dot notation in it from the mapper
	if (structKeyExists(local, "file") and !IsBoolean(local.file)) {
		local.rv = ListSetAt(arguments.name, ListLen(arguments.name, "."), local.file, ".");
	}

	return local.rv;
}

/**
 * Internal function.
 */
public any function $createControllerClass(
	required string name,
	string controllerPaths=$get("controllerPath"),
	string type="controller"
) {
	// let's allow for multiple controller paths so that plugins can contain controllers
	// the last path is the one we will instantiate the base controller on if the controller is not found on any of the paths
	local.iEnd = ListLen(arguments.controllerPaths);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.controllerPath = ListGetAt(arguments.controllerPaths, local.i);
		local.fileName = $objectFileName(name=arguments.name, objectPath=local.controllerPath, type=arguments.type);
		if (local.fileName != "Controller" || local.i == ListLen(arguments.controllerPaths)) {
			application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=local.controllerPath, fileName=local.fileName, method="$initControllerClass", name=arguments.name);
			local.rv = application.wheels.controllers[arguments.name];
			break;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $addToCache(
	required string key,
	required any value,
	numeric time=application.wheels.defaultCacheTime,
	string category="main"
) {
	if (application.wheels.cacheCullPercentage > 0 && application.wheels.cacheLastCulledAt < DateAdd("n", -application.wheels.cacheCullInterval, Now()) && $cacheCount() >= application.wheels.maximumItemsToCache) {
		// cache is full so flush out expired items from this cache to make more room if possible
		local.deletedItems = 0;
		local.cacheCount = $cacheCount();
		for (local.key in application.wheels.cache[arguments.category]) {
			if (Now() > application.wheels.cache[arguments.category][local.key].expiresAt) {
				$removeFromCache(key=local.key, category=arguments.category);
				if (application.wheels.cacheCullPercentage < 100) {
					local.deletedItems++;
					local.percentageDeleted = (local.deletedItems / local.cacheCount) * 100;
					if (local.percentageDeleted >= application.wheels.cacheCullPercentage) {
						break;
					}
				}
			}
		}
		application.wheels.cacheLastCulledAt = Now();
	}
	if ($cacheCount() < application.wheels.maximumItemsToCache) {
		local.cacheItem = {};
		local.cacheItem.expiresAt = DateAdd(application.wheels.cacheDatePart, arguments.time, Now());
		if (IsSimpleValue(arguments.value)) {
			local.cacheItem.value = arguments.value;
		} else {
			local.cacheItem.value = Duplicate(arguments.value);
		}
		application.wheels.cache[arguments.category][arguments.key] = local.cacheItem;
	}
}

/**
 * Internal function.
 */
public any function $getFromCache(required string key, string category="main") {
	local.rv = false;
	try {
		if (StructKeyExists(application.wheels.cache[arguments.category], arguments.key)) {
			if (Now() > application.wheels.cache[arguments.category][arguments.key].expiresAt) {
				$removeFromCache(key=arguments.key, category=arguments.category);
			} else {
				if (IsSimpleValue(application.wheels.cache[arguments.category][arguments.key].value)) {
					local.rv = application.wheels.cache[arguments.category][arguments.key].value;
				} else {
					local.rv = Duplicate(application.wheels.cache[arguments.category][arguments.key].value);
				}
			}
		}
	} catch (any e) {}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $removeFromCache(required string key, string category="main") {
	StructDelete(application.wheels.cache[arguments.category], arguments.key);
}

/**
 * Internal function.
 */
public numeric function $cacheCount(string category="") {
	if (Len(arguments.category)) {
		local.rv = StructCount(application.wheels.cache[arguments.category]);
	} else {
		local.rv = 0;
		for (local.key in application.wheels.cache) {
			local.rv += StructCount(application.wheels.cache[local.key]);
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $clearCache(string category="") {
	if (Len(arguments.category)){
		StructClear(application.wheels.cache[arguments.category]);
	} else {
		StructClear(application.wheels.cache);
	}
}

/**
 * Internal function.
 */
public any function $createModelClass(
	required string name,
	string modelPaths=application.wheels.modelPath,
	string type="model"
) {
	// let's allow for multiple model paths so that plugins can contain models
	// the last path is the one we will instantiate the base model on if the model is not found on any of the paths
	local.iEnd = ListLen(arguments.modelPaths);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.modelPath = ListGetAt(arguments.modelPaths, local.i);
		local.fileName = $objectFileName(name=arguments.name, objectPath=local.modelPath, type=arguments.type);
		if (local.fileName != arguments.type || local.i == ListLen(arguments.modelPaths)) {
			application.wheels.models[arguments.name] = $createObjectFromRoot(path=local.modelPath, fileName=local.fileName, method="$initModelClass", name=arguments.name);
			local.rv = application.wheels.models[arguments.name];
			break;
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $loadRoutes() {
	$simpleLock(name="$mapperLoadRoutes", type="exclusive", timeout=5, execute="$lockedLoadRoutes");
}

/**
 * Internal function.
 */
public void function $lockedLoadRoutes() {
	local.appKey = $appKey();

	// clear out the route info
	ArrayClear(application[local.appKey].routes);
	StructClear(application[local.appKey].namedRoutePositions);

	// load developer routes first
	$include(template="config/routes.cfm");

	// set lookup info for the named routes
	$setNamedRoutePositions();
}

/**
 * Internal function.
 */
public void function $setNamedRoutePositions() {
	local.appKey = $appKey();
	local.iEnd = ArrayLen(application[local.appKey].routes);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.route = application[local.appKey].routes[local.i];
		if (StructKeyExists(local.route, "name") && len(local.route.name)) {
			if (!StructKeyExists(application[local.appKey].namedRoutePositions, local.route.name)) {
				application[local.appKey].namedRoutePositions[local.route.name] = "";
			}
			application[local.appKey].namedRoutePositions[local.route.name] = ListAppend(application[local.appKey].namedRoutePositions[local.route.name], local.i);
		}
	}
}

/**
 * Internal function.
 */
public void function $clearModelInitializationCache() {
	StructClear(application.wheels.models);
}

/**
 * Internal function.
 */
public void function $clearControllerInitializationCache() {
	StructClear(application.wheels.controllers);
}

private string function $checkMinimumVersion(required string engine, required string version) {
	local.rv = "";
	local.version = Replace(arguments.version, ".", ",", "all");
	local.major = Val(ListGetAt(local.version, 1));
	local.minor = 0;
	local.patch = 0;
	local.build = 0;
	if (ListLen(local.version) > 1) {
		local.minor = Val(ListGetAt(local.version, 2));
	}
	if (ListLen(local.version) > 2) {
		local.patch = Val(ListGetAt(local.version, 3));
	}
	if (ListLen(local.version) > 3) {
		local.build = Val(ListGetAt(local.version, 4));
	}
	if (arguments.engine == "Lucee") {
		local.minimumMajor = "4";
		local.minimumMinor = "5";
		local.minimumPatch = "5";
		local.minimumBuild = "6";
		local.5 = {minimumMinor=2, minimumPatch=1, minimumBuild=9};
	} else if (arguments.engine == "Adobe ColdFusion") {
		local.minimumMajor = "10";
		local.minimumMinor = "0";
		local.minimumPatch = "23";
		local.minimumBuild = "302580";
		local.11 = {minimumMinor=0, minimumPatch=12, minimumBuild=302575};
		local.2016 = {minimumMinor=0, minimumPatch=4, minimumBuild=302561};
	} else {
		local.rv = false;
	}
	if (StructKeyExists(local, "minimumMajor")) {
		if (local.major < local.minimumMajor || (local.major == local.minimumMajor && local.minor < local.minimumMinor) || (local.major == local.minimumMajor && local.minor == local.minimumMinor && local.patch < local.minimumPatch) || (local.major == local.minimumMajor && local.minor == local.minimumMinor && local.patch == local.minimumPatch && Len(local.minimumBuild) && local.build < local.minimumBuild)) {
			local.rv = local.minimumMajor & "." & local.minimumMinor & "." & local.minimumPatch;
			if (Len(local.minimumBuild)) {
				local.rv &= "." & local.minimumBuild;
			}
		}
		if (StructKeyExists(local, local.major)) {
			// special requirements for having a specific minor or patch version within a major release exists
			if (local.minor < local[local.major].minimumMinor || (local.minor == local[local.major].minimumMinor && local.patch < local[local.major].minimumPatch)) {
				local.rv = local.major & "." & local[local.major].minimumMinor & "." & local[local.major].minimumPatch;
			}
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public void function $loadPlugins() {
	local.appKey = $appKey();
	local.pluginPath = application[local.appKey].webPath & application[local.appKey].pluginPath;
	application[local.appKey].PluginObj = $createObjectFromRoot(path="wheels", fileName="Plugins", method="init", pluginPath=local.pluginPath, deletePluginDirectories=application[local.appKey].deletePluginDirectories, overwritePlugins=application[local.appKey].overwritePlugins, loadIncompatiblePlugins=application[local.appKey].loadIncompatiblePlugins, wheelsEnvironment=application[local.appKey].environment, wheelsVersion=application[local.appKey].version);
	application[local.appKey].plugins = application[local.appKey].PluginObj.getPlugins();
	application[local.appKey].pluginMeta = application[local.appKey].PluginObj.getPluginMeta();
	application[local.appKey].incompatiblePlugins = application[local.appKey].PluginObj.getIncompatiblePlugins();
	application[local.appKey].dependantPlugins = application[local.appKey].PluginObj.getDependantPlugins();
	application[local.appKey].mixins = application[local.appKey].PluginObj.getMixins();
}

/**
 * Internal function.
 */
public string function $appKey() {
	local.rv = "wheels";
	if (StructKeyExists(application, "$wheels")) {
		local.rv = "$wheels";
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $singularizeOrPluralize(
	required string text,
	required string which,
	numeric count=-1,
	boolean returnCount=true
) {
	// by default we pluralize/singularize the entire string
	local.text = arguments.text;

	// keep track of the success of any rule matches
	local.ruleMatched = false;

	// when count is 1 we don't need to pluralize at all so just set the return value to the input string
	local.rv = local.text;

	if (arguments.count != 1) {
		if (REFind("[A-Z]", local.text)) {
			// only pluralize/singularize the last part of a camelCased variable (e.g. in "websiteStatusUpdate" we only change the "update" part)
			// also set a variable with the unchanged part of the string (to be prepended before returning final result)
			local.upperCasePos = REFind("[A-Z]", Reverse(local.text));
			local.prepend = Mid(local.text, 1, Len(local.text)-local.upperCasePos);
			local.text = Reverse(Mid(Reverse(local.text), 1, local.upperCasePos));
		}

		// Get global settings for uncountable and irregular words.
		// For the irregular ones we need to convert them from a struct to a list.
		local.uncountables = $listClean($get("uncountables"));
		local.irregulars = "";
		local.words = $get("irregulars");
		for (local.word in local.words) {
			local.irregulars = ListAppend(local.irregulars, LCase(local.word));
			local.irregulars = ListAppend(local.irregulars, local.words[local.word]);
		}

		if (ListFindNoCase(local.uncountables, local.text)) {
			local.rv = local.text;
			local.ruleMatched = true;
		} else if (ListFindNoCase(local.irregulars, local.text)) {
			local.pos = ListFindNoCase(local.irregulars, local.text);
			if (arguments.which == "singularize" && local.pos % 2 == 0) {
				local.rv = ListGetAt(local.irregulars, local.pos-1);
			} else if (arguments.which == "pluralize" && local.pos % 2 != 0) {
				local.rv = ListGetAt(local.irregulars, local.pos+1);
			} else {
				local.rv = local.text;
			}
			local.ruleMatched = true;
		} else {
			if (arguments.which == "pluralize") {
				local.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status)$,\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
			} else if (arguments.which == "singularize") {
				local.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,(.*)?ss$,\1ss,s$,#Chr(7)#";
			}
			local.rules = ArrayNew(2);
			local.count = 1;
			local.iEnd = ListLen(local.ruleList);
			for (local.i = 1; local.i <= local.iEnd; local.i=local.i+2) {
				local.rules[local.count][1] = ListGetAt(local.ruleList, local.i);
				local.rules[local.count][2] = ListGetAt(local.ruleList, local.i+1);
				local.count = local.count + 1;
			}
			local.iEnd = ArrayLen(local.rules);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				if (REFindNoCase(local.rules[local.i][1], local.text)) {
					local.rv = REReplaceNoCase(local.text, local.rules[local.i][1], local.rules[local.i][2]);
					local.ruleMatched = true;
					break;
				}
			}
			local.rv = Replace(local.rv, Chr(7), "", "all");
		}

		// this was a camelCased string and we need to prepend the unchanged part to the result
		if (StructKeyExists(local, "prepend") && local.ruleMatched) {
			local.rv = local.prepend & local.rv;
		}
	}

	// return the count number in the string (e.g. "5 sites" instead of just "sites")
	if (arguments.returnCount && arguments.count != -1) {
		local.rv = LSNumberFormat(arguments.count) & " " & local.rv;
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $prependUrl(required string path) {
	local.rv = arguments.path;
	if (arguments.port != 0) {
		// use the port that was passed in by the developer
		local.rv = ":" & arguments.port & local.rv;
	} else if (request.cgi.server_port != 80 && request.cgi.server_port != 443) {
		// if the port currently in use is not 80 or 443 we set it explicitly in the URL
		local.rv = ":" & request.cgi.server_port & local.rv;
	}
	if (Len(arguments.host)) {
		local.rv = arguments.host & local.rv;
	} else {
		local.rv = request.cgi.server_name & local.rv;
	}
	if (Len(arguments.protocol)) {
		local.rv = arguments.protocol & "://" & local.rv;
	} else if (request.cgi.server_port_secure) {
		local.rv = "https://" & local.rv;
	} else {
		local.rv = "http://" & local.rv;
	}
	return local.rv;
}

/**
 * NB: url rewriting files need to be removed from here.
 */
public string function $buildReleaseZip(string version=application.wheels.version, string directory=Expandpath("/")) {
	local.name = "cfwheels-" & LCase(Replace(arguments.version, " ", "-", "all"));
	local.name = Replace(local.name, "alpha-", "alpha.");
	local.name = Replace(local.name, "beta-", "beta.");
	local.name = Replace(local.name, "rc-", "rc.");
	local.path = arguments.directory & local.name & ".zip";

	// directories & files to add to the zip
	local.include = [
		"config",
		"controllers",
		"events",
		"files",
		"global",
		"images",
		"javascripts",
		"miscellaneous",
		"models",
		"plugins",
		"stylesheets",
		"tests",
		"views",
		"wheels",
		"Application.cfc",
		"box.json",
		"index.cfm",
		"rewrite.cfm",
		"root.cfm"
	];

	// directories & files to be removed
	local.exclude = [
		"wheels/tests",
		"wheels/public/build.cfm"
	];

	// filter out these bad boys
	local.filter = "*.settings, *.classpath, *.project, *.DS_Store";

	// The change log and license are copied to the wheels directory only for the build.
	FileCopy(ExpandPath("CHANGELOG.md"), ExpandPath("wheels/CHANGELOG.md"));
	FileCopy(ExpandPath("LICENSE"), ExpandPath("wheels/LICENSE"));

	for (local.i in local.include) {
		if (FileExists(ExpandPath(local.i))) {
			$zip(file=local.path, source=ExpandPath(local.i));
		} else if (DirectoryExists(ExpandPath(local.i))) {
			$zip(file=local.path, source=ExpandPath(local.i), prefix=local.i);
		} else {
			throw(
				type="Wheels.Build",
				message="#ExpandPath(local.i)# not found",
				detail="All paths specified in local.include must exist"
			);
		}
	};

	for (local.i in local.exclude) {
		$zip(file=local.path, action="delete", entrypath=local.i);
	};
	$zip(file=local.path, action="delete", filter=local.filter, recurse=true);

	// Clean up.
	FileDelete(ExpandPath("wheels/CHANGELOG.md"));
	FileDelete(ExpandPath("wheels/LICENSE"));

	return local.path;
}

/**
 * Throw a developer friendly CFWheels error if set (typically in development mode).
 * Otherwise show the 404 page for end users (typically in production mode).
 */
public void function $throwErrorOrShow404Page(required string type, required string message, string extendedInfo="") {
	if ($get("showErrorInformation")) {
		Throw(type=arguments.type, message=arguments.message, extendedInfo=arguments.extendedInfo);
	} else {
		$header(statusCode=404, statustext="Not Found");
		local.template = $get("eventPath") & "/onmissingtemplate.cfm";
		$includeAndOutput(template=local.template);
		abort;
	}
}

</cfscript>
