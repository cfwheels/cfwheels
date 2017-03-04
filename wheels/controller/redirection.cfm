<cfscript>

public void function redirectTo(
	boolean back=false,
	boolean addToken,
	numeric statusCode,
	string route="",
	string method="",
	string controller="",
	string action="",
	any key="",
	string params="",
	string anchor="",
	boolean onlyPath,
	string host,
	string protocol,
	numeric port,
	string url="",
	boolean delay
) {
	$args(name="redirectTo", args=arguments);

	// set flash if passed in
	local.functionInfo = GetMetaData(variables.redirectTo);
	if (StructCount(arguments) > ArrayLen(local.functionInfo.parameters)) {
		// since more than the arguments listed in the function declaration was passed in it's possible that one of them is intended for the flash

		// create a list of all the argument names that should not be set to the flash
		// this includes arguments to the function itself or ones meant for a route
		local.nonFlashArgumentNames = "";
		if (Len(arguments.route)) {
			local.nonFlashArgumentNames = ListAppend(local.nonFlashArgumentNames, $findRoute(argumentCollection=arguments).variables);
		}
		local.iEnd = ArrayLen(local.functionInfo.parameters);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.nonFlashArgumentNames = ListAppend(local.nonFlashArgumentNames, local.functionInfo.parameters[local.i].name);
		}

		// loop through arguments and when the first flash argument is found we set it
		local.argumentNames = StructKeyList(arguments);
		local.iEnd = ListLen(local.argumentNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(local.argumentNames, local.i);
			if (!ListFindNoCase(local.nonFlashArgumentNames, local.item)) {
				local.key = REReplaceNoCase(local.item, "^flash(.)", "\l\1");
				local.flashArguments = {};
				local.flashArguments[local.key] = arguments[local.item];
				flashInsert(argumentCollection=local.flashArguments);
			}
		}
	}

	// set the url that will be used in the cflocation tag
	if (arguments.back) {
		if (Len(request.cgi.http_referer) && FindNoCase(request.cgi.server_name, request.cgi.http_referer)) {
			// referrer exists and points to the same domain so it's ok to redirect to it
			local.url = request.cgi.http_referer;
			if (Len(arguments.params)) {
				// append params to the referrer url
				local.params = $constructParams(arguments.params);
				if (Find("?", request.cgi.http_referer)) {
					local.params = Replace(local.params, "?", "&");
				} else if (left(local.params, 1) == "&" && !Find(request.cgi.http_referer, "?")) {
					local.params = Replace(local.params, "&", "?", "one");
				}
				local.url &= local.params;
			}
		} else {
			// we can't redirect to the referrer so we either use a fallback route/controller/action combo or send to the root of the site
			if (Len(arguments.route) || Len(arguments.controller) || Len(arguments.action)) {
				local.url = URLFor(argumentCollection=arguments);
			} else {
				local.url = get("webPath");
			}
		}
	} else if (Len(arguments.url)) {
		local.url = arguments.url;
	} else {
		local.url = URLFor(argumentCollection=arguments);
	}

	// schedule or perform the redirect right away
	if (arguments.delay) {
		if (StructKeyExists(variables.$instance, "redirect")) {
			// throw an error if the developer has already scheduled a redirect previously in this request
			$throw(type="Wheels.RedirectToAlreadyCalled", message="`redirectTo()` was already called.");
		} else {
			// schedule a redirect that will happen after the action code has been completed
			variables.$instance.redirect = {};
			variables.$instance.redirect.url = local.url;
			variables.$instance.redirect.addToken = arguments.addToken;
			variables.$instance.redirect.statusCode = arguments.statusCode;
			variables.$instance.redirect.$args = arguments;
		}
	} else {
		// do the redirect now using cflocation
		$location(url=local.url, addToken=arguments.addToken, statusCode=arguments.statusCode);
	}
}

</cfscript>
