<cfscript>

/**
 * Returns an associated MIME type based on a file extension.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @extension The extension to get the MIME type for.
 * @fallback The fallback MIME type to return.
 */
public string function mimeTypes(required string extension, string fallback="application/octet-stream") {
	local.rv = arguments.fallback;
	if (StructKeyExists(application.wheels.mimetypes, arguments.extension)) {
		local.rv = application.wheels.mimetypes[arguments.extension];
	}
	return local.rv;
}

/**
 * Truncates text to the specified length and replaces the last characters with the specified truncate string (which defaults to "...").
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @text The text to truncate.
 * @length Length to truncate the text to.
 * @truncateString String to replace the last characters with.
 */
public string function truncate(required string text, numeric length, string truncateString) {
	$args(name="truncate", args=arguments);
	if (Len(arguments.text) > arguments.length) {
		local.rv = Left(arguments.text, arguments.length - Len(arguments.truncateString)) & arguments.truncateString;
	} else {
		local.rv = arguments.text;
	}
	return local.rv;
}

/**
 * Truncates text to the specified length of words and replaces the remaining characters with the specified truncate string (which defaults to "...").
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @text The text to truncate.
 * @length Number of words to truncate the text to.
 * @truncateString String to replace the last characters with.
 */
public string function wordTruncate(required string text, numeric length, string truncateString) {
	$args(name="wordTruncate", args=arguments);
	local.words = ListToArray(arguments.text, " ", false);

	// When there are fewer (or same) words in the string than the number to be truncated we can just return it unchanged.
	if (ArrayLen(local.words) <= arguments.length) {
		return arguments.text;
	}

	local.rv = "";
	local.iEnd = arguments.length;
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.rv = ListAppend(local.rv, local.words[local.i], " ");
	}
	local.rv &= arguments.truncateString;
	return local.rv;
}

/**
 * Extracts an excerpt from text that matches the first instance of a given phrase.
 *
 * [section: Global Helpers]
 * [category: String Functions]
 *
 * @text The text to extract an excerpt from.
 * @phrase The phrase to extract.
 * @radius Number of characters to extract surrounding the phrase.
 * @excerptString String to replace first and / or last characters with.
 */
public string function excerpt(required string text, required string phrase, numeric radius, string excerptString) {
	$args(name="excerpt", args=arguments);
	local.pos = FindNoCase(arguments.phrase, arguments.text, 1);

	// Return an empty value if the text wasn't found at all.
	if (!local.pos) {
		return "";
	}

	// Set start info based on whether the excerpt text found, including its radius, comes before the start of the string.
	if ((local.pos - arguments.radius) <= 1) {
		local.startPos = 1;
		local.truncateStart = "";
	} else {
		local.startPos = local.pos - arguments.radius;
		local.truncateStart = arguments.excerptString;
	}

	// Set end info based on whether the excerpt text found, including its radius, comes after the end of the string.
	if ((local.pos + Len(arguments.phrase) + arguments.radius) > Len(arguments.text)) {
		local.endPos = Len(arguments.text);
		local.truncateEnd = "";
	} else {
		local.endPos = local.pos + arguments.radius;
		local.truncateEnd = arguments.excerptString;
	}

	local.len = (local.endPos + Len(arguments.phrase)) - local.startPos;
	local.mid = Mid(arguments.text, local.startPos, local.len);
	local.rv = local.truncateStart & local.mid & local.truncateEnd;
	return local.rv;
}

/**
 * Pass in two dates to this method, and it will return a string describing the difference between them.
 *
 * [section: Global Helpers]
 * [category: Date Functions]
 *
 * @fromTime Date to compare from.
 * @toTime Date to compare to.
 * @includeSeconds Whether or not to include the number of seconds in the returned string.
 */
public string function distanceOfTimeInWords(required date fromTime, required date toTime, boolean includeSeconds) {
	$args(name="distanceOfTimeInWords", args=arguments);
	local.minuteDiff = DateDiff("n", arguments.fromTime, arguments.toTime);
	local.secondDiff = DateDiff("s", arguments.fromTime, arguments.toTime);
	local.hours = 0;
	local.days = 0;
	local.rv = "";
	if (local.minuteDiff <= 1) {
		if (local.secondDiff < 60) {
			local.rv = "less than a minute";
		} else {
			local.rv = "1 minute";
		}
		if (arguments.includeSeconds) {
			if (local.secondDiff < 5) {
				local.rv = "less than 5 seconds";
			} else if (local.secondDiff < 10) {
				local.rv = "less than 10 seconds";
			} else if (local.secondDiff < 20) {
				local.rv = "less than 20 seconds";
			} else if (local.secondDiff < 40) {
				local.rv = "half a minute";
			}
		}
	} else if (local.minuteDiff < 45) {
		local.rv = local.minuteDiff & " minutes";
	} else if (local.minuteDiff < 90) {
		local.rv = "about 1 hour";
	} else if (local.minuteDiff < 1440) {
		local.hours = Ceiling(local.minuteDiff / 60);
		local.rv = "about " & local.hours & " hours";
	} else if (local.minuteDiff < 2880) {
		local.rv = "1 day";
	} else if (local.minuteDiff < 43200) {
		local.days = Int(local.minuteDiff/1440);
		local.rv = local.days & " days";
	} else if (local.minuteDiff < 86400) {
		local.rv = "about 1 month";
	} else if (local.minuteDiff < 525600) {
		local.months = Int(local.minuteDiff / 43200);
		local.rv = local.months & " months";
	} else if (local.minuteDiff < 657000) {
		local.rv = "about 1 year";
	} else if (local.minuteDiff < 919800) {
		local.rv = "over 1 year";
	} else if (local.minuteDiff < 1051200) {
		local.rv = "almost 2 years";
	} else if (local.minuteDiff >= 1051200) {
		local.years = Int(local.minuteDiff / 525600);
		local.rv = "over " & local.years & " years";
	}
	return local.rv;
}

/**
 * Returns a string describing the approximate time difference between the date passed in and the current date.
 *
 * [section: Global Helpers]
 * [category: Date Functions]
 *
 * @fromTime Date to compare from.
 * @includeSeconds Whether or not to include the number of seconds in the returned string.
 * @toTime Date to compare to.
 */
public any function timeAgoInWords(required date fromTime, boolean includeSeconds, date toTime=Now()) {
	$args(name="timeAgoInWords", args=arguments);
	return distanceOfTimeInWords(argumentCollection=arguments);
}

/**
 * Returns a string describing the approximate time difference between the current date and the date passed in.
 *
 * [section: Global Helpers]
 * [category: Date Functions]
 *
 * @toTime Date to compare to.
 * @includeSeconds Whether or not to include the number of seconds in the returned string.
 * @fromTime Date to compare from.
 */
public string function timeUntilInWords(required date toTime, boolean includeSeconds, date fromTime=Now()) {
	$args(name="timeUntilInWords", args=arguments);
	return distanceOfTimeInWords(argumentCollection=arguments);
}

/**
 * Returns the current setting for the supplied CFWheels setting or the current default for the supplied CFWheels function argument.
 *
 * [section: Configuration]
 * [category: Miscellaneous Functions]
 *
 * @name Variable name to get setting for.
 * @functionName Function name to get setting for.
 */
public any function get(required string name, string functionName="") {
	return $get(argumentCollection=arguments);
}

/**
 * Use to configure a global setting or set a default for a function.
 *
 * [section: Configuration]
 * [category: Miscellaneous Functions]
 */
public void function set() {
	$set(argumentCollection=arguments);
}

/**
 * Adds a new MIME type to your CFWheels application for use with responding to multiple formats.
 *
 * [section: Configuration]
 * [category: Miscellaneous Functions]
 *
 * @extension File extension to add.
 * @mimeType Matching MIME type to associate with the file extension.
 */
public void function addFormat(required string extension, required string mimeType) {
	local.appKey = $appKey();
	application[local.appKey].formats[arguments.extension] = arguments.mimeType;
}

/**
 * Returns the mapper object used to configure your application's routes. Usually you will use this method in `config/routes.cfm` to start chaining route mapping methods like `resources`, `namespace`, etc.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function mapper(boolean restful=true, boolean methods=arguments.restful) {
	return application[$appKey()].mapper.$draw(argumentCollection=arguments);
}

/**
 * Creates a controller and calls an action on it.
 * Which controller and action that's called is determined by the params passed in.
 * Returns the result of the request either as a string or in a struct with `body`, `emails`, `files`, `flash`, `redirect`, `status`, and `type`.
 * Primarily used for testing purposes.
 *
 * [section: Controller]
 * [category: Miscellaneous Functions]
 *
 * @params The params struct to use in the request (make sure that at least `controller` and `action` are set).
 * @method The HTTP method to use in the request (`get`, `post` etc).
 * @returnAs Pass in `struct` to return all information about the request instead of just the final output (`body`).
 * @rollback Pass in `true` to roll back all database transactions made during the request.
 */
public any function processRequest(required struct params, string method, string returnAs, string rollback) {
	$args(name="processRequest", args=arguments);

	// Set the global transaction mode to rollback when specified.
	// Also save the current state so we can set it back after the tests have run.
	if (arguments.rollback) {
		local.transactionMode = $get("transactionMode");
		$set(transactionMode="rollback");
	}

	// Before proceeding we set the request method to our internal CGI scope if passed in.
	// This way it's possible to mock a POST request so that an isPost() call in the action works as expected for example.
	if (arguments.method != "get") {
		request.cgi.request_method = arguments.method;
	}

	// Never deliver email or send files during test.
	local.deliverEmail = $get(functionName="sendEmail", name="deliver");
	$set(functionName="sendEmail", deliver=false);
	local.deliverFile = $get(functionName="sendFile", name="deliver");
	$set(functionName="sendFile", deliver=false);

	local.controller = controller(name=arguments.params.controller, params=arguments.params);

	// Set to ignore CSRF errors during testing.
	local.controller.protectsFromForgery(with="ignore");

	local.controller.processAction();
	local.response = local.controller.response();

	// Get redirect info.
	// If a delayed redirect was made we use the status code for that and set the body to a blank string.
	// If not we use the current status code and response and set the redirect info to a blank string.
	local.redirectDetails = local.controller.getRedirect();
	if (StructCount(local.redirectDetails)) {
		local.body = "";
		local.redirect = local.redirectDetails.url;
		local.status = local.redirectDetails.statusCode;
	} else {
		local.status = $statusCode();
		local.body = local.response;
		local.redirect = "";
	}

	if (arguments.returnAs == "struct") {
		local.rv = {
			body = local.body,
			emails = local.controller.getEmails(),
			files = local.controller.getFiles(),
			flash = local.controller.flash(),
			redirect = local.redirect,
			status = local.status,
			type = $contentType()
		};
	} else {
		local.rv = local.body;
	}

	// Clear the Flash so we can run several processAction calls without the Flash sticking around.
	local.controller.$flashClear();

	// Set back the global transaction mode to the previous value if it has been changed.
	if (arguments.rollback) {
		$set(transactionMode=local.transactionMode);
	}

	// Set back the request method to GET (this is fine since the test suite is always run using GET).
	request.cgi.request_method = "get";

	// Set back email delivery setting to previous value.
	$set(functionName="sendEmail", deliver=local.deliverEmail);
	$set(functionName="sendFile", deliver=local.deliverFile);

	// Set back the status code to 200 so the test suite does not use the same code that the action that was tested did.
	// If the test suite fails it will set the status code to 500 later.
	$header(statusCode=200, statusText="OK");

	// Set the Content-Type header in case it was set to something else (e.g. application/json) during processing.
	// It's fine to do this because we always want to return the test page as text/html.
	$header(name="Content-Type", value="text/html", charset="UTF-8");

	return local.rv;
}

/**
 * Returns a struct with information about the specificed paginated query.
 * The keys that will be included in the struct are `currentPage`, `totalPages` and `totalRecords`.
 *
 * [section: Controller]
 * [category: Pagination Functions]
 *
 * @handle The handle given to the query to return pagination information for.
 */
public struct function pagination(string handle="query") {
	if ($get("showErrorInformation")) {
		if (!StructKeyExists(request.wheels, arguments.handle)) {
			Throw(
				type="Wheels.QueryHandleNotFound",
				message="CFWheels couldn't find a query with the handle of `#arguments.handle#`.",
				extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified."
			);
		}
	}
	return request.wheels[arguments.handle];
}

/**
 * Allows you to set a pagination handle for a custom query so you can perform pagination on it in your view with `paginationLinks`.
 *
 * [section: Controller]
 * [category: Pagination Functions]
 *
 * @totalRecords Total count of records that should be represented by the paginated links.
 * @currentPage Page number that should be represented by the data being fetched and the paginated links.
 * @perPage Number of records that should be represented on each page of data.
 * @handle Name of handle to reference in `paginationLinks`.
 */
public void function setPagination(
	required numeric totalRecords,
	numeric currentPage=1,
	numeric perPage=25,
	string handle="query"
) {
	// NOTE: this should be documented as a controller function but needs to be placed here because the findAll() method calls it.

	// All numeric values must be integers.
	arguments.totalRecords = Fix(arguments.totalRecords);
	arguments.currentPage = Fix(arguments.currentPage);
	arguments.perPage = Fix(arguments.perPage);

	// The totalRecords argument cannot be negative.
	if (arguments.totalRecords < 0) {
		arguments.totalRecords = 0;
	}

	// Default perPage to 25 if it's less then zero.
	if (arguments.perPage <= 0) {
		arguments.perPage = 25;
	}

	// Calculate the total pages the query will have.
	arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);

	// The currentPage argument shouldn't be less then 1 or greater then the number of pages.
	if (arguments.currentPage >= arguments.totalPages) {
		arguments.currentPage = arguments.totalPages;
	}
	if (arguments.currentPage < 1) {
		arguments.currentPage = 1;
	}

	// As a convenience for cfquery and cfloop when doing oldschool type pagination.
	// Set startrow for cfquery and cfloop.
	arguments.startRow = (arguments.currentPage * arguments.perPage) - arguments.perPage + 1;

	// Set maxrows for cfquery.
	arguments.maxRows = arguments.perPage;

	// Set endrow for cfloop.
	arguments.endRow = (arguments.startRow - 1) + arguments.perPage;

	// The endRow argument shouldn't be greater then the totalRecords or less than startRow.
	if (arguments.endRow >= arguments.totalRecords) {
		arguments.endRow = arguments.totalRecords;
	}
	if (arguments.endRow < arguments.startRow) {
		arguments.endRow = arguments.startRow;
	}

	local.args = Duplicate(arguments);
	StructDelete(local.args, "handle");
	request.wheels[arguments.handle] = local.args;
}

/**
 * Creates and returns a controller object with your own custom name and params.
 * Used primarily for testing purposes.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @name Name of the controller to create.
 * @params The params struct (combination of form and URL variables).
 */
public any function controller(required string name, struct params={}) {
	local.args = {};
	local.args.name = arguments.name;
	local.rv = $doubleCheckedLock(
		condition="$cachedControllerClassExists",
		conditionArgs=local.args,
		execute="$createControllerClass",
		executeArgs=local.args,
		name="controllerLock#application.applicationName#"
	);
	if (!StructIsEmpty(arguments.params)) {
		local.rv = local.rv.$createControllerObject(arguments.params);
	}
	return local.rv;
}

/**
 * Returns a reference to the requested model so that class level methods can be called on it.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @name Name of the model to get a reference to.
 */
public any function model(required string name) {
	return $doubleCheckedLock(
		condition="$cachedModelClassExists",
		conditionArgs=arguments,
		execute="$createModelClass",
		executeArgs=arguments,
		name="modelLock#application.applicationName#"
	);
}

/**
 * Obfuscates a value. Typically used for hiding primary key values when passed along in the URL.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @param The value to obfuscate.
 */
public string function obfuscateParam(required any param) {
	local.rv = arguments.param;
	if (IsValid("integer", arguments.param) && IsNumeric(arguments.param) && arguments.param > 0 && Left(arguments.param, 1) != 0) {
		local.iEnd = Len(arguments.param);
		local.a = (10^local.iEnd) + Reverse(arguments.param);
		local.b = 0;
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.b += Left(Right(arguments.param, local.i), 1);
		}
		if (IsValid("integer", local.a)) {
			local.rv = FormatBaseN(local.b+154, 16) & FormatBaseN(BitXor(local.a, 461), 16);
		}
	}
	return local.rv;
}

/**
 * Deobfuscates a value.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @param The value to deobfuscate.
 */
public string function deobfuscateParam(required string param) {
	if (Val(arguments.param) != arguments.param) {
		try {
			local.checksum = Left(arguments.param, 2);
			local.rv = Right(arguments.param, Len(arguments.param)-2);
			local.z = BitXor(InputBasen(local.rv, 16), 461);
			local.rv = "";
			local.iEnd = Len(local.z) - 1;
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.rv &= Left(Right(local.z, local.i), 1);
			}
			local.checkSumTest = 0;
			local.iEnd = Len(local.rv);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.checkSumTest += Left(Right(local.rv, local.i), 1);
			}
			local.c1 = ToString(FormatBaseN(local.checkSumTest+154, 10));
			local.c2 = InputBasen(local.checksum, 16);
			if (local.c1 != local.c2) {
				local.rv = arguments.param;
			}
		} catch (any e) {
			local.rv = arguments.param;
		}
	} else {
		local.rv = arguments.param;
	}
	return local.rv;
}

/**
 * Returns a list of the names of all installed plugins.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 */
public string function pluginNames() {
	return StructKeyList(application.wheels.plugins);
}

/**
 * Creates an internal URL based on supplied arguments.
 *
 * [section: Global Helpers]
 * [category: Miscellaneous Functions]
 *
 * @route Name of a route that you have configured in `config/routes.cfm`.
 * @controller Name of the controller to include in the URL.
 * @action Name of the action to include in the URL.
 * @key Key(s) to include in the URL.
 * @params Any additional parameters to be set in the query string (example: `wheels=cool&x=y`). Please note that CFWheels uses the `&` and `=` characters to split the parameters and encode them properly for you. However, if you need to pass in `&` or `=` as part of the value, then you need to encode them (and only them), example: `a=cats%26dogs%3Dtrouble!&b=1`.
 * @anchor Sets an anchor name to be appended to the path.
 * @onlyPath If `true`, returns only the relative URL (no protocol, host name or port).
 * @host Set this to override the current host.
 * @protocol Set this to override the current protocol.
 * @port Set this to override the current port number.
 * @encode Encode URL parameters using `EncodeForURL()`. Please note that this does not make the string safe for placement in HTML attributes, for that you need to wrap the result in `EncodeForHtmlAttribute()` or use `linkTo()`, `startFormTag()` etc instead.
 */
public string function URLFor(
	string route="",
	string controller="",
	string action="",
	any key="",
	string params="",
	string anchor="",
	boolean onlyPath,
	string host,
	string protocol,
	numeric port,
	boolean encode,
	boolean $encodeForHtmlAttribute=false,
	string $URLRewriting=application.wheels.URLRewriting
) {
	$args(name="URLFor", args=arguments);
	local.coreVariables = "controller,action,key,format";
	local.params = {};
	if (StructKeyExists(variables, "params")) {
		StructAppend(local.params, variables.params);
	}

	// Throw error if host or protocol are passed with onlyPath=true.
	local.hostOrProtocolNotEmpty = Len(arguments.host) || Len(arguments.protocol);
	if (application.wheels.showErrorInformation && arguments.onlyPath && local.hostOrProtocolNotEmpty) {
		Throw(
			type="Wheels.IncorrectArguments",
			message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`.",
			extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link."
		);
	}

	// Look up actual route paths instead of providing default Wheels path generation.
	// Loop over all routes to find matching one, break the loop on first match.
	// If the route is already in the cache we get it from there instead.
	if (!Len(arguments.route) && Len(arguments.action)) {
		if (!Len(arguments.controller)) {
			arguments.controller = local.params.controller;
		}
		local.key = arguments.controller & "##" & arguments.action;
		local.cache = request.wheels.urlForCache;
		if (!StructKeyExists(local.cache, local.key)) {
			local.iEnd = ArrayLen(application.wheels.routes);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.route = application.wheels.routes[local.i];
				local.controllerMatch = StructKeyExists(local.route, "controller") && local.route.controller == arguments.controller;
				local.actionMatch = StructKeyExists(local.route, "action") && local.route.action == arguments.action;
				if (local.controllerMatch && local.actionMatch) {
					arguments.route = local.route.name;
					local.cache[local.key] = arguments.route;
					break;
				}
			}
		}
		if (StructKeyExists(local.cache, local.key)) {
			arguments.route = local.cache[local.key];
		}
	}

	// Start building the URL to return by setting the sub folder path and script name portion.
	// Script name (index.cfm or rewrite.cfm) will be removed later if applicable (e.g. when URL rewriting is on).
	local.rv = application.wheels.webPath & ListLast(request.cgi.script_name, "/");

	// Look up route pattern to use and add it to the URL to return.
	// Either from a passed in route or the Wheels default one.
	// For the Wheels default we set the controller and action arguments to what's in the params struct.
	if (Len(arguments.route)) {
		local.route = $findRoute(argumentCollection=arguments);
		local.variables = local.route.variables;
		local.rv &= local.route.pattern;
	} else {
		local.route = {};
		local.variables = local.coreVariables;
		local.rv &= "?controller=[controller]&action=[action]&key=[key]&format=[format]";
		if (StructKeyExists(local, "params")) {
			if (!Len(arguments.action)) {
				if (Len(arguments.controller)) {
					arguments.action = "index";
				} else if (StructKeyExists(local.params, "action")) {
					arguments.action = local.params.action;
				}
			}
			if (!Len(arguments.controller) && StructKeyExists(local.params, "controller")) {
				arguments.controller = local.params.controller;
			}
		}
	}

	// Replace each params variable with the correct value.
	for (local.i = 1; local.i <= ListLen(local.variables); local.i++) {
		local.property = ListGetAt(local.variables, local.i);
		local.reg = "\[\*?#local.property#\]";

		// Read necessary variables from different sources.
		if (StructKeyExists(arguments, local.property) && Len(arguments[local.property])) {
			local.value = arguments[local.property];
		} else if (StructKeyExists(local.route, local.property)) {
			local.value = local.route[local.property];
		} else if (Len(arguments.route) && arguments.$URLRewriting != "Off") {
			Throw(
				type="Wheels.IncorrectRoutingArguments",
				message="Incorrect Arguments",
				extendedInfo="The route chosen by Wheels `#local.route.name#` requires the argument `#local.property#`. Pass the argument `#local.property#` or change your routes to reflect the proper variables needed."
			);
		} else {
			continue;
		}

		// If value is a model object, get its key value.
		if (IsObject(local.value)) {
			local.value = local.value.key();
		}

		// Any value we find from above, URL encode it here.
		if (arguments.encode && $get("encodeURLs")) {
			local.value = EncodeForURL($canonicalize(local.value));
			if (arguments.$encodeForHtmlAttribute) {
				local.value = EncodeForHtmlAttribute(local.value);
			}
		}

		// If property is not in pattern, store it in the params argument.
		if (!REFind(local.reg, local.rv)) {
			if (!ListFindNoCase(local.coreVariables, local.property)) {
				arguments.params = ListAppend(arguments.params, "#local.property#=#local.value#", "&");
			}
			continue;
		}

		// Transform value before setting it in pattern.
		if (local.property == "controller" || local.property == "action") {
			local.value = hyphenize(local.value);
		} else if (application.wheels.obfuscateUrls) {
			local.value = obfuscateParam(local.value);
		}
		local.rv = REReplace(local.rv, local.reg, local.value);

	}

	// Clean up unused keys in pattern.
	local.rv = REReplace(local.rv, "((&|\?)\w+=|\/|\.)\[\*?\w+\]", "", "ALL");

	// When URL rewriting is on (or partially) we replace the "?controller="" stuff in the URL with just "/".
	if (arguments.$URLRewriting != "Off") {
		local.rv = Replace(local.rv, "?controller=", "/");
		local.rv = Replace(local.rv, "&action=", "/");
		local.rv = Replace(local.rv, "&key=", "/");
	}

	// When URL rewriting is on we remove the rewrite file name (e.g. rewrite.cfm) from the URL so it doesn't show.
	// Also get rid of the double "/" that this removal typically causes.
	if (arguments.$URLRewriting == "On") {
		local.rv = Replace(local.rv, application.wheels.rewriteFile, "");
		local.rv = Replace(local.rv, "//", "/");
	}

	// Add params to the URL when supplied.
	if (Len(arguments.params)) {
		local.rv &= $constructParams(
			params=arguments.params,
			encode=arguments.encode,
			$encodeForHtmlAttribute=arguments.$encodeForHtmlAttribute,
			$URLRewriting=arguments.$URLRewriting
		);
	}

	// Add an anchor to the the URL when supplied.
	if (Len(arguments.anchor)) {
		local.rv &= "##" & arguments.anchor;
	}

	// Prepend the full URL if directed.
	if (!arguments.onlyPath) {
		local.rv = $prependUrl(path=local.rv, argumentCollection=arguments);
	}

	return local.rv;
}

</cfscript>
