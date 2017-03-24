<cfscript>

/**
 * Returns the current setting for the supplied Wheels setting or the current default for the supplied Wheels function argument.
 *
 * [section: Configuration]
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
 */
public void function set() {
	$set(argumentCollection=arguments);
}

/**
 * Adds a new MIME format to your Wheels application for use with responding to multiple formats.
 *
 * [section: Configuration]
 *
 * @extension File extension to add.
 * @mimeType Matching MIME type to associate with the file extension.
 */
public void function addFormat(required string extension, required string mimeType) {
	local.appKey = $appKey();
	application[local.appKey].formats[arguments.extension] = arguments.mimeType;
}

/**
 * Use to configure your application's routes.
 *
 * [section: Configuration]
 * [category: Routing]
 */
public struct function drawRoutes(boolean restful=true, boolean methods=arguments.restful) {
	return application[$appKey()].mapper.$draw(argumentCollection=arguments);
}

/**
 * Creates a controller and calls an action on it.
 * Which controller and action that's called is determined by the params passed in.
 * Returns the result of the request either as a string or in a struct with body, status and type.
 * Primarily used for testing purposes.
 *
 * [section: Controller]
 * [category: Miscellaneous Functions]
 *
 * @params The params struct with controller and action set
 * @returnAs Return format
 */
public any function processRequest(required struct params, string returnAs) {
	$args(name="processRequest", args=arguments);
	local.controller = controller(name=arguments.params.controller, params=arguments.params);
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
			redirect = local.redirect,
			status = local.status,
			type = $contentType()
		};
	} else {
		local.rv = local.body;
	}

	// Set back the status code to 200 so the test suite does not use the same code that the action that was tested did.
	// If the test suite fails it will set the status code to 500 later.
	$header(statusCode=200, statusText="OK");

	// Set the Content-Type header in case it was set to something else (e.g. application/json) during processing.
	// It's fine to do this because we always want to return the test page as text/html.
	$header(name="Content-Type", value="text/html", charset="UTF-8");

	return local.rv;
}

/**
 * Returns a struct with information about the specificed paginated query. The keys that will be included in the struct are currentPage, totalPages and totalRecords.
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
 * Allows you to set a pagination handle for a custom query so you can perform pagination on it in your view with paginationLinks.
 *
 * [section: Controller]
 * [category: Pagination Functions]
 *
 * @totalRecords Total count of records that should be represented by the paginated links.
 * @currentPage Page number that should be represented by the data being fetched and the paginated links.
 * @perPage Number of records that should be represented on each page of data.
 * @handle Name of handle to reference in paginationLinks.
 */
public void function setPagination(
	required numeric totalRecords,
	numeric currentPage=1,
	numeric perPage=25,
	string handle="query"
) {
	// should be documented as a controller function but needs to be placed here because the findAll() method calls it

	// all numeric values must be integers
	arguments.totalRecords = Fix(arguments.totalRecords);
	arguments.currentPage = Fix(arguments.currentPage);
	arguments.perPage = Fix(arguments.perPage);

	// totalRecords cannot be negative
	if (arguments.totalRecords < 0) {
		arguments.totalRecords = 0;
	}

	// perPage less then zero
	if (arguments.perPage <= 0) {
		arguments.perPage = 25;
	}

	// calculate the total pages the query will have
	arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);

	// currentPage shouldn't be less then 1 or greater then the number of pages
	if (arguments.currentPage >= arguments.totalPages) {
		arguments.currentPage = arguments.totalPages;
	}
	if (arguments.currentPage < 1) {
		arguments.currentPage = 1;
	}

	// as a convinence for cfquery and cfloop when doing oldschool type pagination
	// startrow for cfquery and cfloop
	arguments.startRow = (arguments.currentPage * arguments.perPage) - arguments.perPage + 1;

	// maxrows for cfquery
	arguments.maxRows = arguments.perPage;

	// endrow for cfloop
	arguments.endRow = (arguments.startRow - 1) + arguments.perPage;

	// endRow shouldn't be greater then the totalRecords or less than startRow
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
 * Creates and returns a controller object with your own custom name and params. Used primarily for testing purposes.
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
	local.rv = $doubleCheckedLock(name="controllerLock#application.applicationName#", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=local.args, executeArgs=local.args);
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
	return $doubleCheckedLock(name="modelLock#application.applicationName#", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=arguments, executeArgs=arguments);
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
 * Returns a list of all installed plugins' names.
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
 * @params Any additional parameters to be set in the query string (example: `wheels=cool&x=y`). Please note that CFWheels uses the `&` and `=` characters to split the parameters and encode them properly for you (using `URLEncodedFormat()` internally). However, if you need to pass in `&` or `=` as part of the value, then you need to encode them (and only them), example: `a=cats%26dogs%3Dtrouble!&b=1`.
 * @anchor Sets an anchor name to be appended to the path.
 * @onlyPath If `true`, returns only the relative URL (no protocol, host name or port).
 * @host Set this to override the current host.
 * @protocol Set this to override the current protocol.
 * @port Set this to override the current port number.
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
			if (!Len(arguments.action) && StructKeyExists(local.params, "action") && (Len(arguments.controller) || Len(arguments.key) || StructKeyExists(arguments, "format"))) {
				arguments.action = local.params.action;
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
		local.value = $URLEncode(local.value);

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
		local.rv &= $constructParams(params=arguments.params, $URLRewriting=arguments.$URLRewriting);
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
