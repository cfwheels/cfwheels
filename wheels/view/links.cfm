<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
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
				if (!StructKeyExists(arguments, "rel"))
					arguments.rel = "";
				arguments.rel = ListAppend(arguments.rel, "no-follow", " ");
			}
		}

		// hyphenize any other data attributes
		for (local.key in arguments) {
			if (REFind("^data[A-Za-z]", local.key)) {
				arguments[hyphenize(local.key)] = toXHTML(arguments[local.key]);
				StructDelete(arguments, local.key);
			}
		}

		if (!StructKeyExists(arguments, "href"))
		{
			arguments.href = URLFor(argumentCollection=arguments);
		}
		arguments.href = toXHTML(arguments.href);
		if (!StructKeyExists(arguments, "text"))
		{
			arguments.text = arguments.href;
		}
		local.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
		{
			// variables passed in as route arguments should not be added to the html element
			local.skip = ListAppend(local.skip, $routeVariables(argumentCollection=arguments));
		}
		local.rv = $element(name="a", skip=local.skip, content=arguments.text, attributes=arguments);
		return local.rv;
	}

	public string function buttonTo(
		string text,
		string confirm,
		string image,
		any disable,
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
		$args(name="buttonTo", reserved="method", args=arguments);
		arguments.action = URLFor(argumentCollection=arguments);
		arguments.action = toXHTML(arguments.action);
		arguments.method = "post";
		if (Len(arguments.confirm))
		{
			local.onsubmit = "return confirm('#JSStringFormat(arguments.confirm)#');";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=local.onsubmit, attributes=arguments);
		}
		local.args = $innerArgs(name="input", args=arguments);
		local.args.value = arguments.text;
		local.args.image = arguments.image;
		local.args.disable = arguments.disable;
		local.content = submitTag(argumentCollection=local.args);
		local.skip = "disable,image,text,confirm,route,controller,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
		{
			// variables passed in as route arguments should not be added to the html element
			local.skip = ListAppend(local.skip, $routeVariables(argumentCollection=arguments));
		}
		local.rv = $element(name="form", skip=local.skip, content=local.content, attributes=arguments);
		return local.rv;
	}

	public string function mailTo(
		required string emailAddress,
		string name="",
		boolean encode
	) {
		$args(name="mailTo", reserved="href", args=arguments);
		arguments.href = "mailto:" & arguments.emailAddress;
		if (Len(arguments.name))
		{
			local.content = arguments.name;
		}
		else
		{
			local.content = arguments.emailAddress;
		}
		local.rv = $element(name="a", skip="emailAddress,name,encode", content=local.content, attributes=arguments);
		if (arguments.encode)
		{
			local.js = "document.write('#Trim(local.rv)#');";
			local.encoded = "";
			local.iEnd = Len(local.js);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.encoded &= "%" & Right("0" & FormatBaseN(Asc(Mid(local.js,local.i,1)),16),2);
			}
			local.content = "eval(unescape('#local.encoded#'))";
			local.rv = $element(name="script", content=local.content, type="text/javascript");
		}
		return local.rv;
	}

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
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			StructDelete(local.linkToArguments, ListGetAt(local.skipArgs, local.i));
		}
		local.currentPage = pagination(arguments.handle).currentPage;
		local.totalPages = pagination(arguments.handle).totalPages;
		local.start = "";
		local.middle = "";
		local.end = "";
		if (StructKeyExists(arguments, "route"))
		{
			// when a route name is specified and the name argument is part
			// of the route variables specified, we need to force the
			// arguments.pageNumberAsParam to be false
			local.routeConfig = $findRoute(argumentCollection=arguments);
			if (ListFindNoCase(local.routeConfig.variables, arguments.name))
			{
				arguments.pageNumberAsParam = false;
			}
		}
		if (arguments.showSinglePage || local.totalPages > 1)
		{
			if (Len(arguments.prepend))
			{
				local.start &= arguments.prepend;
			}
			if (arguments.alwaysShowAnchors)
			{
				if ((local.currentPage - arguments.windowSize) > 1)
				{
					local.pageNumber = 1;
					if (!arguments.pageNumberAsParam)
					{
						local.linkToArguments[arguments.name] = local.pageNumber;
					}
					else
					{
						local.linkToArguments.params = arguments.name & "=" & local.pageNumber;
						if (StructKeyExists(arguments, "params"))
						{
							local.linkToArguments.params &= "&" & arguments.params;
						}
					}
					local.linkToArguments.text = NumberFormat(local.pageNumber);
					if (Len(arguments.prependToPage) && arguments.prependOnAnchor)
					{
						local.start &= arguments.prependToPage;
					}
					local.start &= linkTo(argumentCollection=local.linkToArguments);
					if (Len(arguments.appendToPage) && arguments.appendOnAnchor)
					{
						local.start &= arguments.appendToPage;
					}
					local.start &= arguments.anchorDivider;
				}
			}
			local.middle = "";
			for (local.i=1; local.i <= local.totalPages; local.i++)
			{
				if ((local.i >= (local.currentPage - arguments.windowSize) && local.i <= local.currentPage) || (local.i <= (local.currentPage + arguments.windowSize) && local.i >= local.currentPage))
				{
					if (!arguments.pageNumberAsParam)
					{
						local.linkToArguments[arguments.name] = local.i;
					}
					else
					{
						local.linkToArguments.params = arguments.name & "=" & local.i;
						if (StructKeyExists(arguments, "params"))
						{
							local.linkToArguments.params &= "&" & arguments.params;
						}
					}
					local.linkToArguments.text = NumberFormat(local.i);
					if (Len(arguments.classForCurrent) && local.currentPage == local.i)
					{
						// apply the classForCurrent class if specified and this is the current page
						local.linkToArguments.class = arguments.classForCurrent;
					}
					else if (StructKeyExists(arguments, "class") && Len(arguments.class))
					{
						// allow the class attribute to be applied to the anchor tag if specified
						local.linkToArguments.class = arguments.class;
					}
					else
					{
						// clear the class argument if not provided
						StructDelete(local.linkToArguments, "class");
					}
					if (Len(arguments.prependToPage))
					{
						local.middle &= arguments.prependToPage;
					}
					if (local.currentPage != local.i || arguments.linkToCurrentPage)
					{
						local.middle &= linkTo(argumentCollection=local.linkToArguments);
					}
					else
					{
						if (Len(arguments.classForCurrent))
						{
							local.middle &= $element(name="span", content=NumberFormat(local.i), class=arguments.classForCurrent);
						}
						else
						{
							local.middle &= NumberFormat(local.i);
						}
					}
					if (Len(arguments.appendToPage))
					{
						local.middle &= arguments.appendToPage;
					}
				}
			}
			if (arguments.alwaysShowAnchors)
			{
				if (local.totalPages > (local.currentPage + arguments.windowSize))
				{
					if (!arguments.pageNumberAsParam)
					{
						local.linkToArguments[arguments.name] = local.totalPages;
					}
					else
					{
						local.linkToArguments.params = arguments.name & "=" & local.totalPages;
						if (StructKeyExists(arguments, "params"))
						{
							local.linkToArguments.params &= "&" & arguments.params;
						}
					}
					local.linkToArguments.text = NumberFormat(local.totalPages);
					local.end &= arguments.anchorDivider;
					if (Len(arguments.prependToPage) && arguments.prependOnAnchor)
					{
						local.end &= arguments.prependToPage;
					}
					local.end &= linkTo(argumentCollection=local.linkToArguments);
					if (Len(arguments.appendToPage) && arguments.appendOnAnchor)
					{
						local.end &= arguments.appendToPage;
					}
				}
			}
			if (Len(arguments.append))
			{
				local.end &= arguments.append;
			}
		}
		if (Len(local.middle))
		{
			if (Len(arguments.prependToPage) && !arguments.prependOnFirst)
			{
				local.middle = Mid(local.middle, Len(arguments.prependToPage)+1, Len(local.middle)-Len(arguments.prependToPage));
			}
			if (Len(arguments.appendToPage) && !arguments.appendOnLast)
			{
				local.middle = Mid(local.middle, 1, Len(local.middle)-Len(arguments.appendToPage));
			}
		}
		local.rv = local.start & local.middle & local.end;
		return local.rv;
	}
</cfscript>
