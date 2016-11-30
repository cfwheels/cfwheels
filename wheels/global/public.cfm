<cfscript>
	/*
	* PUBLIC CONFIGURATION FUNCTIONS
	*/

	public void function addFormat(required string extension, required string mimeType) {
		local.appKey = $appKey();
		application[local.appKey].formats[arguments.extension] = arguments.mimeType;
	}

	public Mapper function drawRoutes(
		boolean restful=true, boolean methods=arguments.restful) {
		return application[$appKey()].mapper.draw(argumentCollection=arguments);
	}

	public void function addRoute() {
		throw(
				type="Wheels.DeprecatedMethod"
			, message="Please use `drawRoutes()` in your `/config/routes.cfm` configuration file."
		);
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

		local.coreVariables = "controller,action,key,format";

		local.params = {};
		if (StructKeyExists(variables, "params"))
			StructAppend(local.params, variables.params);

		// error if host or protocol are passed with onlyPath=true
		if (application.wheels.showErrorInformation
				&& arguments.onlyPath
				&& (Len(arguments.host) OR Len(arguments.protocol))) {
			$throw(
					type="Wheels.IncorrectArguments"
				, message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`."
				, extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link."
			);
		}

		// Look up actual route paths instead of providing default Wheels path generation
		if (arguments.route == "" && arguments.action != "") {

			if (arguments.controller == "")
				arguments.controller = local.params.controller;

			// determine key and look up cache structure
			local.key = arguments.controller & "##" & arguments.action;
			local.cache = request.wheels.urlForCache;

			if (!structKeyExists(local.cache, local.key)) {

				// loop over routes to find matching one
				for (local.i = 1; local.i <= ArrayLen(application.wheels.routes); local.i++) {
					local.route = application.wheels.routes[local.i];

					// if found, cache the route name, set up arguments, and break from loop
					if (StructKeyExists(local.route, "controller")
							&& local.route.controller == arguments.controller
							&& StructKeyExists(local.route, "action")
							&& local.route.action == arguments.action) {
						arguments.route = local.route.name;
						local.cache[local.key] = arguments.route;
						break;
					}
				}
			}

			arguments.route = local.cache[local.key];
		}

		// look up route pattern to use
		if (arguments.route NEQ "") {

			local.route = $findRoute(argumentCollection=arguments);
			local.variables = local.route.variables;
			local.rv = local.route.pattern;

		// use default route pattern
		} else {
			local.route = {};
			local.variables = local.coreVariables;
			local.rv = "/[controller]/[action]/[key].[format]";

			// set controller and action based on controller params
			if (StructKeyExists(local, "params")) {
				if (arguments.action == ""
						&& StructKeyExists(local.params, "action")
						&& (arguments.controller != ""
								|| arguments.key != ""
								|| StructKeyExists(arguments, "format")))
					arguments.action = local.params.action;
				if (arguments.controller == ""
						&& StructKeyExists(local.params, "controller"))
					arguments.controller = local.params.controller;
			}
		}

		// replace pattern if there is no rewriting enabled
		if (arguments.$URLRewriting == "Off") {
			local.variables = ListPrepend(local.variables, local.coreVariables);
			local.rv = "?controller=[controller]&action=[action]&key=[key]&format=[format]";
		}

		// replace each params variable with the correct value
		for (local.i = 1; local.i <= ListLen(local.variables); local.i++) {
			local.property = ListGetAt(local.variables, local.i);
			local.reg = "\[\*?#local.property#\]";

			// read necessary variables from different sources
			if (StructKeyExists(arguments, local.property)
					&& Len(arguments[local.property]))
				local.value = arguments[local.property];
			else if (StructKeyExists(local.route, local.property))
				local.value = local.route[local.property];
			else if (arguments.route != "" && arguments.$URLRewriting != "Off")
				$throw(
						type="Wheels.IncorrectRoutingArguments"
					, message="Incorrect Arguments"
					, extendedInfo="The route chosen by Wheels `#local.route.name#` requires the argument `#local.property#`. Pass the argument `#local.property#` or change your routes to reflect the proper variables needed.");
			else
				continue;

			// if value is a model object, get its key value
			if (IsObject(local.value))
				local.value = local.value.toParam();

			// any value we find from above, URL encode it here
			local.value = $URLEncode(local.value);

			// if property is not in pattern, store it in the params argument
			if (!REFind(local.reg, local.rv)) {
				if (!ListFindNoCase(local.coreVariables, local.property))
					arguments.params = ListAppend(
							arguments.params
						, "#local.property#=#local.value#"
						, "&"
					);
				continue;
			}

			// transform value before setting it in pattern
			if (local.property == "controller" || local.property == "action")
				local.value = hyphenize(local.value);
			else if (application.wheels.obfuscateUrls)
				local.value = obfuscateParam(local.value);

			local.rv = REReplace(local.rv, local.reg, local.value);
		}

		// clean up unused keys in pattern
		local.rv = REReplace(local.rv, "((&|\?)\w+=|\/|\.)\[\*?\w+\]", "", "ALL");

		// apply anchor and additional parameters
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
