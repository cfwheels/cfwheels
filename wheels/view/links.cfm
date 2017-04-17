<cfscript>

/**
 * Creates a link to another page in your application.
 * Pass in the name of a route to use your configured routes or a controller/action/key combination.
 * Note: Pass any additional arguments like class, rel, and id, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Link Functions]
 *
 * @text The text content of the link.
 * @route Name of a route that you have configured in config/routes.cfm.
 * @controller Name of the controller to include in the URL.
 * @action Name of the action to include in the URL.
 * @key Key(s) to include in the URL.
 * @params Any additional parameters to be set in the query string (example: wheels=cool&x=y). Please note that CFWheels uses the & and = characters to split the parameters and encode them properly for you (using URLEncodedFormat() internally). However, if you need to pass in & or = as part of the value, then you need to encode them (and only them), example: a=cats%26dogs%3Dtrouble!&b=1.
 * @anchor Sets an anchor name to be appended to the path.
 * @onlyPath If true, returns only the relative URL (no protocol, host name or port).
 * @host Set this to override the current host.
 * @protocol Set this to override the current protocol.
 * @port Set this to override the current port number.
 * @href Pass a link to an external site here if you want to bypass the CFWheels routing system altogether and link to an external URL.
 */
public string function linkTo(
	string text,
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
	string href
) {
	$args(name="linkTo", args=arguments);

	// look for passed in rest method
	if (StructKeyExists(arguments, "method")) {

		// if dealing with delete, keep robots from following link
		if (arguments.method == "delete") {
			if (!StructKeyExists(arguments, "rel")) {
				arguments.rel = "";
			}
			arguments.rel = ListAppend(arguments.rel, "no-follow", " ");
		}
	}

	if (!StructKeyExists(arguments, "href")) {
		arguments.href = URLFor(argumentCollection=arguments);
	}
	arguments.href = toXHTML(arguments.href);
	if (!StructKeyExists(arguments, "text")) {
		arguments.text = arguments.href;
	}
	local.skip = "text,route,controller,action,key,params,anchor,onlyPath,host,protocol,port";
	if (Len(arguments.route)) {
		// variables passed in as route arguments should not be added to the html element
		local.skip = ListAppend(local.skip, $routeVariables(argumentCollection=arguments));
	}
	return $element(name="a", skip=local.skip, content=arguments.text, attributes=arguments);
}

/**
 * Creates a form containing a single button that submits to the URL.
 * The URL is built the same way as the `linkTo` function.
 *
 * [section: View Helpers]
 * [category: Link Functions]
 *
 * @text The text content of the button.
 * @image If you want to use an image for the button pass in the link to it here (relative from the `images` folder).
 * @route See documentation for [doc:URLFor].
 * @controller See documentation for [doc:URLFor].
 * @action See documentation for [doc:URLFor].
 * @key See documentation for [doc:URLFor].
 * @params See documentation for [doc:URLFor].
 * @anchor See documentation for [doc:URLFor].
 * @onlyPath See documentation for [doc:URLFor].
 * @host See documentation for [doc:URLFor].
 * @protocol See documentation for [doc:URLFor].
 * @port See documentation for [doc:URLFor].
 */
public string function buttonTo(
	string text,
	string image,
	string route="",
	string controller="",
	string action="",
	any key="",
	string params="",
	string anchor="",
	boolean onlyPath,
	string host,
	string protocol,
	numeric port
) {
	local.method = "post";
	$args(name="buttonTo", args=arguments);
	local.content = "";
	if (StructKeyExists(arguments, "method")) {
		if (!ListFindNoCase("post,get", arguments.method)) {
			local.content &= hiddenFieldTag(name="_method", value=arguments.method);
		} else if (arguments.method == "get") {
			local.method = "get";
		}
	}
	arguments.method = local.method;
	arguments.action = URLFor(argumentCollection=arguments);
	arguments.action = toXHTML(arguments.action);

	local.args = $innerArgs(name="input", args=arguments);
	local.args.value = arguments.text;
	local.args.image = arguments.image;
	local.content &= submitTag(argumentCollection=local.args);
	local.skip = "image,text,route,controller,key,params,anchor,onlyPath,host,protocol,port";
	if (Len(arguments.route)) {
		// variables passed in as route arguments should not be added to the html element
		local.skip = ListAppend(local.skip, $routeVariables(argumentCollection=arguments));
	}
	return $element(name="form", skip=local.skip, content=local.content, attributes=arguments);
}

/**
 * Creates a `mailto` link tag to the specified email address, which is also used as the name of the link unless name is specified.
 *
 * [section: View Helpers]
 * [category: Link Functions]
 *
 * @emailAddress The email address to link to.
 * @name A string to use as the link text ("Joe" or "Support Department", for example).
 * @encode Pass `true` here to encode the email address, making it harder for bots to harvest it for example.
 */
public string function mailTo(
	required string emailAddress,
	string name="",
	boolean encode
) {
	$args(name="mailTo", reserved="href", args=arguments);
	arguments.href = "mailto:" & arguments.emailAddress;
	if (Len(arguments.name)) {
		local.content = arguments.name;
	} else {
		local.content = arguments.emailAddress;
	}
	local.rv = $element(name="a", skip="emailAddress,name,encode", content=local.content, attributes=arguments);
	if (arguments.encode) {
		local.js = "document.write('#Trim(local.rv)#');";
		local.encoded = "";
		local.iEnd = Len(local.js);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.encoded &= "%" & Right("0" & FormatBaseN(Asc(Mid(local.js,local.i,1)),16),2);
		}
		local.content = "eval(unescape('#local.encoded#'))";
		local.rv = $element(name="script", content=local.content, type="text/javascript");
	}
	return local.rv;
}

/**
 * Builds and returns a string containing links to pages based on a paginated query.
 * Uses `linkTo()` internally to build the link, so you need to pass in a route name or a controller/action/key combination.
 * All other `linkTo()` arguments can be supplied as well, in which case they are passed through directly to `linkTo()`.
 * If you have paginated more than one query in the controller, you can use the handle argument to reference them. (Don't forget to pass in a handle to the `findAll()` function in your controller first.)
 *
 * [section: View Helpers]
 * [category: Link Functions]
 *
 * @windowSize The number of page links to show around the current page.
 * @alwaysShowAnchors Whether or not links to the first and last page should always be displayed.
 * @anchorDivider String to place next to the anchors on either side of the list.
 * @linkToCurrentPage Whether or not the current page should be linked to.
 * @prepend String or HTML to be prepended before result.
 * @append String or HTML to be appended after result.
 * @prependToPage String or HTML to be prepended before each page number.
 * @prependOnFirst Whether or not to prepend the prependToPage string on the first page in the list.
 * @prependOnAnchor Whether or not to prepend the prependToPage string on the anchors.
 * @appendToPage String or HTML to be appended after each page number.
 * @appendOnLast Whether or not to append the appendToPage string on the last page in the list.
 * @appendOnAnchor Whether or not to append the appendToPage string on the anchors.
 * @classForCurrent Class name for the current page number (if linkToCurrentPage is true, the class name will go on the a element. If not, a span element will be used).
 * @handle The handle given to the query that the pagination links should be displayed for.
 * @name The name of the param that holds the current page number.
 * @showSinglePage Will show a single page when set to true. (The default behavior is to return an empty string when there is only one page in the pagination).
 * @pageNumberAsParam Decides whether to link the page number as a param or as part of a route. (The default behavior is true).
 */
public string function paginationLinks(
	numeric windowSize,
	boolean alwaysShowAnchors,
	string anchorDivider,
	boolean linkToCurrentPage,
	string prepend,
	string append,
	string prependToPage,
	boolean prependOnFirst,
	boolean prependOnAnchor,
	string appendToPage,
	boolean appendOnLast,
	boolean appendOnAnchor,
	string classForCurrent,
	string handle="query",
	string name,
	boolean showSinglePage,
	boolean pageNumberAsParam
) {
	$args(name="paginationLinks", args=arguments);
	local.skipArgs = "windowSize,alwaysShowAnchors,anchorDivider,linkToCurrentPage,prepend,append,prependToPage,prependOnFirst,prependOnAnchor,appendToPage,appendOnLast,appendOnAnchor,classForCurrent,handle,name,showSinglePage,pageNumberAsParam";
	local.linkToArguments = Duplicate(arguments);
	local.iEnd = ListLen(local.skipArgs);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		StructDelete(local.linkToArguments, ListGetAt(local.skipArgs, local.i));
	}
	local.currentPage = pagination(arguments.handle).currentPage;
	local.totalPages = pagination(arguments.handle).totalPages;
	local.start = "";
	local.middle = "";
	local.end = "";
	if (StructKeyExists(arguments, "route")) {
		// when a route name is specified and the name argument is part
		// of the route variables specified, we need to force the
		// arguments.pageNumberAsParam to be false
		local.routeConfig = $findRoute(argumentCollection=arguments);
		if (ListFindNoCase(local.routeConfig.variables, arguments.name)) {
			arguments.pageNumberAsParam = false;
		}
	}
	if (arguments.showSinglePage || local.totalPages > 1) {
		if (Len(arguments.prepend)) {
			local.start &= arguments.prepend;
		}
		if (arguments.alwaysShowAnchors) {
			if ((local.currentPage - arguments.windowSize) > 1) {
				local.pageNumber = 1;
				if (!arguments.pageNumberAsParam) {
					local.linkToArguments[arguments.name] = local.pageNumber;
				} else {
					local.linkToArguments.params = arguments.name & "=" & local.pageNumber;
					if (StructKeyExists(arguments, "params")) {
						local.linkToArguments.params &= "&" & arguments.params;
					}
				}
				local.linkToArguments.text = NumberFormat(local.pageNumber);
				if (Len(arguments.prependToPage) && arguments.prependOnAnchor) {
					local.start &= arguments.prependToPage;
				}
				local.start &= linkTo(argumentCollection=local.linkToArguments);
				if (Len(arguments.appendToPage) && arguments.appendOnAnchor) {
					local.start &= arguments.appendToPage;
				}
				local.start &= arguments.anchorDivider;
			}
		}
		local.middle = "";
		for (local.i = 1; local.i <= local.totalPages; local.i++) {
			if ((local.i >= (local.currentPage - arguments.windowSize) && local.i <= local.currentPage) || (local.i <= (local.currentPage + arguments.windowSize) && local.i >= local.currentPage)) {
				if (!arguments.pageNumberAsParam) {
					local.linkToArguments[arguments.name] = local.i;
				} else {
					local.linkToArguments.params = arguments.name & "=" & local.i;
					if (StructKeyExists(arguments, "params")) {
						local.linkToArguments.params &= "&" & arguments.params;
					}
				}
				local.linkToArguments.text = NumberFormat(local.i);
				if (Len(arguments.classForCurrent) && local.currentPage == local.i) {
					// apply the classForCurrent class if specified and this is the current page
					local.linkToArguments.class = arguments.classForCurrent;
				} else if (StructKeyExists(arguments, "class") && Len(arguments.class)) {
					// allow the class attribute to be applied to the anchor tag if specified
					local.linkToArguments.class = arguments.class;
				} else {
					// clear the class argument if not provided
					StructDelete(local.linkToArguments, "class");
				}
				if (Len(arguments.prependToPage)) {
					local.middle &= arguments.prependToPage;
				}
				if (local.currentPage != local.i || arguments.linkToCurrentPage) {
					local.middle &= linkTo(argumentCollection=local.linkToArguments);
				} else {
					if (Len(arguments.classForCurrent)) {
						local.middle &= $element(name="span", content=NumberFormat(local.i), class=arguments.classForCurrent);
					} else {
						local.middle &= NumberFormat(local.i);
					}
				}
				if (Len(arguments.appendToPage)) {
					local.middle &= arguments.appendToPage;
				}
			}
		}
		if (arguments.alwaysShowAnchors) {
			if (local.totalPages > (local.currentPage + arguments.windowSize)) {
				if (!arguments.pageNumberAsParam) {
					local.linkToArguments[arguments.name] = local.totalPages;
				} else {
					local.linkToArguments.params = arguments.name & "=" & local.totalPages;
					if (StructKeyExists(arguments, "params")) {
						local.linkToArguments.params &= "&" & arguments.params;
					}
				}
				local.linkToArguments.text = NumberFormat(local.totalPages);
				local.end &= arguments.anchorDivider;
				if (Len(arguments.prependToPage) && arguments.prependOnAnchor) {
					local.end &= arguments.prependToPage;
				}
				local.end &= linkTo(argumentCollection=local.linkToArguments);
				if (Len(arguments.appendToPage) && arguments.appendOnAnchor) {
					local.end &= arguments.appendToPage;
				}
			}
		}
		if (Len(arguments.append)) {
			local.end &= arguments.append;
		}
	}
	if (Len(local.middle)) {
		if (Len(arguments.prependToPage) && !arguments.prependOnFirst) {
			local.middle = Mid(local.middle, Len(arguments.prependToPage)+1, Len(local.middle)-Len(arguments.prependToPage));
		}
		if (Len(arguments.appendToPage) && !arguments.appendOnLast) {
			local.middle = Mid(local.middle, 1, Len(local.middle)-Len(arguments.appendToPage));
		}
	}
	return local.start & local.middle & local.end;
}

</cfscript>
