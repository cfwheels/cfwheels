<cfscript>
	/*
	* PUBLIC CONFIGURATION FUNCTIONS
	*/

	public void function addFormat(required string extension, required string mimeType) {
		local.appKey = $appKey();
		application[local.appKey].formats[arguments.extension] = arguments.mimeType;
	}

	public void function addRoute(
		string name="",
		required string pattern,
		string controller="",
		string action=""
	) {
		local.appKey = $appKey();

		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && !FindNoCase("[controller]", arguments.pattern)) {
			$throw(type="Wheels.IncorrectArguments", message="The `controller` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `controller` argument to specifically tell CFWheels which controller to call or include it in the pattern to tell CFWheels to determine it dynamically on each request based on the incoming URL.");
		}
		if (!Len(arguments.action) && !FindNoCase("[action]", arguments.pattern)) {
			$throw(type="Wheels.IncorrectArguments", message="The `action` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `action` argument to specifically tell CFWheels which action to call or include it in the pattern to tell CFWheels to determine it dynamically on each request based on the incoming URL.");
		}

		local.thisRoute = Duplicate(arguments);
		local.thisRoute.variables = "";
		if (Find(".", local.thisRoute.pattern)) {
			local.thisRoute.format = ListLast(local.thisRoute.pattern, ".");
			local.thisRoute.formatVariable = ReplaceList(local.thisRoute.format, "[,]", "");
			local.thisRoute.pattern = ListFirst(local.thisRoute.pattern, ".");
		}
		local.iEnd = ListLen(local.thisRoute.pattern, "/");
		for (local.i=1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(local.thisRoute.pattern, local.i, "/");
			if (REFind("^\[", local.item)) {
				local.thisRoute.variables = ListAppend(local.thisRoute.variables, ReplaceList(local.item, "[,]", ""));
			}
		}
		ArrayAppend(application[local.appKey].routes, local.thisRoute);
	}

	public void function addDefaultRoutes() {
		addRoute(pattern="[controller]/[action]/[key]");
		addRoute(pattern="[controller]/[action]");
		addRoute(pattern="[controller]", action="index");
	}

	public void function set() {
		local.appKey = $appKey();
		if (ArrayLen(arguments) > 1) {
			for (local.key in arguments) {
				if (local.key != "functionName") {
					local.iEnd = ListLen(arguments.functionName);
					for (local.i=1; local.i <= local.iEnd; local.i++) {
						application[local.appKey].functions[Trim(ListGetAt(arguments.functionName, local.i))][local.key] = arguments[local.key];
					}
				}
			}
		} else {
			application[local.appKey][StructKeyList(arguments)] = arguments[1];
		}
	}

	/*
	* PUBLIC HELPER FUNCTIONS
	*/

	public struct function pagination(string handle="query") {
		if (get("showErrorInformation")) {
			if (!StructKeyExists(request.wheels, arguments.handle)) {
				$throw(type="Wheels.QueryHandleNotFound", message="CFWheels couldn't find a query with the handle of `#arguments.handle#`.", extendedInfo="Make sure your `findAll` call has the `page` argument specified and matching `handle` argument if specified.");
			}
		}
		return request.wheels[arguments.handle];
	}

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

	public any function controller(required string name, struct params={}) {
		local.args = {};
		local.args.name = arguments.name;
		local.rv = $doubleCheckedLock(name="controllerLock#application.applicationName#", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=local.args, executeArgs=local.args);
		if (!StructIsEmpty(arguments.params)) {
			local.rv = local.rv.$createControllerObject(arguments.params);
		}
		return local.rv;
	}

	public any function get(required string name, string functionName="") {
		local.appKey = $appKey();
		if (Len(arguments.functionName)) {
			local.rv = application[local.appKey].functions[arguments.functionName][arguments.name];
		} else {
			local.rv = application[local.appKey][arguments.name];
		}
		return local.rv;
	}

	public any function model(required string name) {
		return $doubleCheckedLock(name="modelLock#application.applicationName#", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=arguments, executeArgs=arguments);
	}

	public string function obfuscateParam(required any param) {
		local.rv = arguments.param;
		if (IsValid("integer", arguments.param) && IsNumeric(arguments.param) && arguments.param > 0 && Left(arguments.param, 1) != 0) {
			local.iEnd = Len(arguments.param);
			local.a = (10^local.iEnd) + Reverse(arguments.param);
			local.b = 0;
			for (local.i=1; local.i <= local.iEnd; local.i++) {
				local.b += Left(Right(arguments.param, local.i), 1);
			}
			if (IsValid("integer", local.a)) {
				local.rv = FormatBaseN(local.b+154, 16) & FormatBaseN(BitXor(local.a, 461), 16);
			}
		}
		return local.rv;
	}

	public string function deobfuscateParam(required string param) {
		if (Val(arguments.param) != arguments.param) {
			try {
				local.checksum = Left(arguments.param, 2);
				local.rv = Right(arguments.param, Len(arguments.param)-2);
				local.z = BitXor(InputBasen(local.rv, 16), 461);
				local.rv = "";
				local.iEnd = Len(local.z) - 1;
				for (local.i=1; local.i <= local.iEnd; local.i++) {
					local.rv &= Left(Right(local.z, local.i), 1);
				}
				local.checkSumTest = 0;
				local.iEnd = Len(local.rv);
				for (local.i=1; local.i <= local.iEnd; local.i++) {
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

	public string function pluginNames() {
		return StructKeyList(application.wheels.plugins);
	}

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
		local.params = {};
		if (StructKeyExists(variables, "params")) {
			StructAppend(local.params, variables.params);
		}
		if (application.wheels.showErrorInformation) {
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol) || arguments.port)) {
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host`, `protocol` and `port` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that absolute URLs are created, thus allowing you to set `host`, `protocol` and `port`.");
			}
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key)) {
			arguments.key = arguments.key.key();
		}

		// build the link (could use some refactoring, lots of duplication related to obfuscating for example)
		local.rv = application.wheels.webPath & ListLast(request.cgi.script_name, "/");
		if (Len(arguments.route)) {
			// link for a named route
			local.route = $findRoute(argumentCollection=arguments);
			if (arguments.$URLRewriting == "Off") {
				local.rv &= "?controller=";
				if (Len(arguments.controller)) {
					local.rv &= hyphenize(arguments.controller);
				} else {
					local.rv &= hyphenize(local.route.controller);
				}
				local.rv &= "&action=";
				if (Len(arguments.action)) {
					local.rv &= hyphenize(arguments.action);
				} else {
					local.rv &= hyphenize(local.route.action);
				}

				// add it the format if it exists
				if (StructKeyExists(local.route, "formatVariable") && StructKeyExists(arguments, local.route.formatVariable)) {
					local.rv &= "&#local.route.formatVariable#=#arguments[local.route.formatVariable]#";
				}

				local.iEnd = ListLen(local.route.variables);
				for (local.i=1; local.i <= local.iEnd; local.i++) {
					local.property = ListGetAt(local.route.variables, local.i);
					if (local.property != "controller" && local.property != "action") {
						local.param = $URLEncode(arguments[local.property]);
						if (application.wheels.obfuscateUrls) {
							local.param = obfuscateParam("#local.param#");
						}
						local.rv &= "&" & local.property & "=" & local.param;
					}
				}
			} else {
				local.iEnd = ListLen(local.route.pattern, "/");
				for (local.i=1; local.i <= local.iEnd; local.i++) {
					local.property = ListGetAt(local.route.pattern, local.i, "/");
					if (Find("[", local.property)) {
						local.property = Mid(local.property, 2, Len(local.property)-2);
						if (application.wheels.showErrorInformation && !StructKeyExists(arguments, local.property)) {
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by CFWheels `#local.route.name#` requires the argument `#local.property#`. Pass the argument `#local.property#` or change your routes to reflect the proper variables needed.");
						}
						local.param = $URLEncode(arguments[local.property]);
						if (local.property == "controller" || local.property == "action") {
							local.param = hyphenize(local.param);
						} else if (application.wheels.obfuscateUrls) {
							// wrap in double quotes because in railo we have to pass it in as a string otherwise leading zeros are stripped
							local.param = obfuscateParam("#local.param#");
						}
						local.rv &= "/" & local.param; // get param from arguments
					} else {
						local.rv &= "/" & local.property; // add hard coded param from route
					}
				}
				// add it the format if it exists
				if (StructKeyExists(local.route, "formatVariable") && StructKeyExists(arguments, local.route.formatVariable)) {
					local.rv &= ".#arguments[local.route.formatVariable]#";
				}
			}
		} else {
			// link based on controller/action/key
			// when no controller or action was passed in we link to the current page (controller/action only, not query string etc) by default
			if (!Len(arguments.controller) && !Len(arguments.action) && StructKeyExists(local.params, "action")) {
				arguments.action = local.params.action;
			}
			if (!Len(arguments.controller) && StructKeyExists(local.params, "controller")) {
				arguments.controller = local.params.controller;
			}
			if (Len(arguments.key) && !Len(arguments.action) && StructKeyExists(local.params, "action")) {
				arguments.action = local.params.action;
			}
			local.rv &= "?controller=" & hyphenize(arguments.controller);
			if (Len(arguments.action)) {
				local.rv &= "&action=" & hyphenize(arguments.action);
			}
			if (Len(arguments.key)) {
				local.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls) {
					// wrap in double quotes because in railo we have to pass it in as a string otherwise leading zeros are stripped
					local.param = obfuscateParam("#local.param#");
				}
				local.rv &= "&key=" & local.param;
			}
		}
		if (arguments.$URLRewriting != "Off") {
			local.rv = Replace(local.rv, "?controller=", "/");
			local.rv = Replace(local.rv, "&action=", "/");
			local.rv = Replace(local.rv, "&key=", "/");
		}
		if (arguments.$URLRewriting == "On") {
			local.rv = Replace(local.rv, application.wheels.rewriteFile, "");
			local.rv = Replace(local.rv, "//", "/");
		}
		if (Len(arguments.params)) {
			local.rv &= $constructParams(params=arguments.params, $URLRewriting=arguments.$URLRewriting);
		}
		if (Len(arguments.anchor)) {
			local.rv &= "##" & arguments.anchor;
		}
		if (!arguments.onlyPath) {
			local.rv = $prependUrl(path=local.rv, argumentCollection=arguments);
		}
		return local.rv;
	}

	public string function capitalize(required string text) {
		local.rv = arguments.text;
		if (Len(local.rv)) {
			local.rv = UCase(Left(local.rv, 1)) & Mid(local.rv, 2, Len(local.rv)-1);
		}
		return local.rv;
	}

	public string function humanize(required string text, string except="") {
		// add a space before every capitalized word
		local.rv = REReplace(arguments.text, "([[:upper:]])", " \1", "all");

		// fix abbreviations so they form a word again (example: aURLVariable)
		local.rv = REReplace(local.rv, "([[:upper:]]) ([[:upper:]])(?:\s|\b)", "\1\2", "all");

		if (Len(arguments.except)) {
			local.iEnd = ListLen(arguments.except, " ");
			for (local.i=1; local.i <= local.iEnd; local.i++) {
				local.item = ListGetAt(arguments.except, local.i);
				local.rv = ReReplaceNoCase(local.rv, "#local.item#(?:\b)", "#local.item#", "all");
			}
		}

		// support multiple word input by stripping out all double spaces created
		local.rv = Replace(local.rv, "  ", " ", "all");

		// capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
		local.rv = Trim(capitalize(local.rv));
		return local.rv;
	}

	public string function pluralize(
		required string word,
		numeric count="-1",
		boolean returnCount="true"
	) {
		return $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount);
	}

	public string function singularize(required string word) {
			return $singularizeOrPluralize(text=arguments.word, which="singularize");
	}

	public string function toXHTML(required string text) {
		return Replace(arguments.text, "&", "&amp;", "all");
	}

	public string function mimeTypes(required string extension, string fallback="application/octet-stream") {
		local.rv = arguments.fallback;
		if (StructKeyExists(application.wheels.mimetypes, arguments.extension)) {
			local.rv = application.wheels.mimetypes[arguments.extension];
		}
		return local.rv;
	}

	public string function hyphenize(required string string) {
		local.rv = REReplace(arguments.string, "([A-Z][a-z])", "-\l\1", "all");
		local.rv = REReplace(local.rv, "([a-z])([A-Z])", "\1-\l\2", "all");
		local.rv = REReplace(local.rv, "^-", "", "one");
		local.rv = LCase(local.rv);
		return local.rv;
	}
</cfscript>