<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="linkTo" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="false">
	<cfargument name="confirm" type="string" required="false" default="">
	<cfargument name="route" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="key" type="any" required="false" default="">
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="anchor" type="string" required="false" default="">
	<cfargument name="onlyPath" type="boolean" required="false">
	<cfargument name="host" type="string" required="false">
	<cfargument name="protocol" type="string" required="false">
	<cfargument name="port" type="numeric" required="false">
	<cfargument name="href" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="linkTo", args=arguments);
		if (Len(arguments.confirm))
		{
			loc.onclick = "return confirm('#JSStringFormat(arguments.confirm)#');";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
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
		loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
		{
			// variables passed in as route arguments should not be added to the html element
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments));
		}
		loc.rv = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="buttonTo" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="false">
	<cfargument name="confirm" type="string" required="false">
	<cfargument name="image" type="string" required="false">
	<cfargument name="disable" type="any" required="false">
	<cfargument name="route" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="key" type="any" required="false" default="">
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="anchor" type="string" required="false" default="">
	<cfargument name="onlyPath" type="boolean" required="false">
	<cfargument name="host" type="string" required="false">
	<cfargument name="protocol" type="string" required="false">
	<cfargument name="port" type="numeric" required="false">
	<cfscript>
		var loc = {};
		$args(name="buttonTo", reserved="method", args=arguments);
		arguments.action = URLFor(argumentCollection=arguments);
		arguments.action = toXHTML(arguments.action);
		arguments.method = "post";
		if (Len(arguments.confirm))
		{
			loc.onsubmit = "return confirm('#JSStringFormat(arguments.confirm)#');";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
		}
		loc.content = submitTag(value=arguments.text, image=arguments.image, disable=arguments.disable);
		loc.skip = "disable,image,text,confirm,route,controller,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
		{
			// variables passed in as route arguments should not be added to the html element
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments));
		}
		loc.rv = $element(name="form", skip=loc.skip, content=loc.content, attributes=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="mailTo" returntype="string" access="public" output="false">
	<cfargument name="emailAddress" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="encode" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="mailTo", reserved="href", args=arguments);
		arguments.href = "mailto:#arguments.emailAddress#";
		if (Len(arguments.name))
		{
			loc.content = arguments.name;
		}
		else
		{
			loc.content = arguments.emailAddress;
		}
		loc.rv = $element(name="a", skip="emailAddress,name,encode", content=loc.content, attributes=arguments);
		if (arguments.encode)
		{
			loc.js = "document.write('#Trim(loc.rv)#');";
			loc.encoded = "";
			loc.iEnd = Len(loc.js);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.encoded &= "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
			}
			loc.content = "eval(unescape('#loc.encoded#'))";
			loc.rv = $element(name="script", content=loc.content, type="text/javascript");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="paginationLinks" returntype="string" access="public" output="false">
	<cfargument name="windowSize" type="numeric" required="false">
	<cfargument name="alwaysShowAnchors" type="boolean" required="false">
	<cfargument name="anchorDivider" type="string" required="false">
	<cfargument name="linkToCurrentPage" type="boolean" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToPage" type="string" required="false">
	<cfargument name="prependOnFirst" type="boolean" required="false">
	<cfargument name="prependOnAnchor" type="boolean" required="false">
	<cfargument name="appendToPage" type="string" required="false">
	<cfargument name="appendOnLast" type="boolean" required="false">
	<cfargument name="appendOnAnchor" type="boolean" required="false">
	<cfargument name="classForCurrent" type="string" required="false">
	<cfargument name="handle" type="string" required="false" default="query">
	<cfargument name="name" type="string" required="false">
	<cfargument name="showSinglePage" type="boolean" required="false">
	<cfargument name="pageNumberAsParam" type="boolean" required="false">
	<cfscript>
		var loc = {};
		$args(name="paginationLinks", args=arguments);
		loc.skipArgs = "windowSize,alwaysShowAnchors,anchorDivider,linkToCurrentPage,prepend,append,prependToPage,prependOnFirst,prependOnAnchor,appendToPage,appendOnLast,appendOnAnchor,classForCurrent,handle,name,showSinglePage,pageNumberAsParam";
		loc.linkToArguments = Duplicate(arguments);
		loc.iEnd = ListLen(loc.skipArgs);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			StructDelete(loc.linkToArguments, ListGetAt(loc.skipArgs, loc.i));
		}
		loc.currentPage = pagination(arguments.handle).currentPage;
		loc.totalPages = pagination(arguments.handle).totalPages;
		loc.start = "";
		loc.middle = "";
		loc.end = "";
		if (StructKeyExists(arguments, "route"))
		{
			// when a route name is specified and the name argument is part
			// of the route variables specified, we need to force the
			// arguments.pageNumberAsParam to be false
			loc.routeConfig = $findRoute(argumentCollection=arguments);
			if (ListFindNoCase(loc.routeConfig.variables, arguments.name))
			{
				arguments.pageNumberAsParam = false;
			}
		}
		if (arguments.showSinglePage || loc.totalPages > 1)
		{
			if (Len(arguments.prepend))
			{
				loc.start &= arguments.prepend;
			}
			if (arguments.alwaysShowAnchors)
			{
				if ((loc.currentPage - arguments.windowSize) > 1)
				{
					loc.pageNumber = 1;
					if (!arguments.pageNumberAsParam)
					{
						loc.linkToArguments[arguments.name] = loc.pageNumber;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.pageNumber;
						if (StructKeyExists(arguments, "params"))
						{
							loc.linkToArguments.params &= "&" & arguments.params;
						}
					}
					loc.linkToArguments.text = loc.pageNumber;
					if (Len(arguments.prependToPage) && arguments.prependOnAnchor)
					{
						loc.start &= arguments.prependToPage;
					}
					loc.start &= linkTo(argumentCollection=loc.linkToArguments);
					if (Len(arguments.appendToPage) && arguments.appendOnAnchor)
					{
						loc.start &= arguments.appendToPage;
					}
					loc.start &= arguments.anchorDivider;
				}
			}
			loc.middle = "";
			for (loc.i=1; loc.i <= loc.totalPages; loc.i++)
			{
				if ((loc.i >= (loc.currentPage - arguments.windowSize) && loc.i <= loc.currentPage) || (loc.i <= (loc.currentPage + arguments.windowSize) && loc.i >= loc.currentPage))
				{
					if (!arguments.pageNumberAsParam)
					{
						loc.linkToArguments[arguments.name] = loc.i;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.i;
						if (StructKeyExists(arguments, "params"))
						{
							loc.linkToArguments.params &= "&" & arguments.params;
						}
					}
					loc.linkToArguments.text = loc.i;
					if (Len(arguments.classForCurrent) && loc.currentPage == loc.i)
					{
						// apply the classForCurrent class if specified and this is the current page
						loc.linkToArguments.class = arguments.classForCurrent;
					}
					else if (StructKeyExists(arguments, "class") && Len(arguments.class))
					{
						// allow the class attribute to be applied to the anchor tag if specified
						loc.linkToArguments.class = arguments.class;
					}
					else
					{
						// clear the class argument if not provided
						StructDelete(loc.linkToArguments, "class");
					}
					if (Len(arguments.prependToPage))
					{
						loc.middle &= arguments.prependToPage;
					}
					if (loc.currentPage != loc.i || arguments.linkToCurrentPage)
					{
						loc.middle &= linkTo(argumentCollection=loc.linkToArguments);
					}
					else
					{
						if (Len(arguments.classForCurrent))
						{
							loc.middle &= $element(name="span", content=loc.i, class=arguments.classForCurrent);
						}
						else
						{
							loc.middle &= loc.i;
						}
					}
					if (Len(arguments.appendToPage))
					{
						loc.middle &= arguments.appendToPage;
					}
				}
			}
			if (arguments.alwaysShowAnchors)
			{
				if (loc.totalPages > (loc.currentPage + arguments.windowSize))
				{
					if (!arguments.pageNumberAsParam)
					{
						loc.linkToArguments[arguments.name] = loc.totalPages;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.totalPages;
						if (StructKeyExists(arguments, "params"))
						{
							loc.linkToArguments.params &= "&" & arguments.params;
						}
					}
					loc.linkToArguments.text = loc.totalPages;
					loc.end &= arguments.anchorDivider;
					if (Len(arguments.prependToPage) && arguments.prependOnAnchor)
					{
						loc.end &= arguments.prependToPage;
					}
					loc.end &= linkTo(argumentCollection=loc.linkToArguments);
					if (Len(arguments.appendToPage) && arguments.appendOnAnchor)
					{
						loc.end &= arguments.appendToPage;
					}
				}
			}
			if (Len(arguments.append))
			{
				loc.end &= arguments.append;
			}
		}
		if (Len(loc.middle))
		{
			if (Len(arguments.prependToPage) && !arguments.prependOnFirst)
			{
				loc.middle = Mid(loc.middle, Len(arguments.prependToPage)+1, Len(loc.middle)-Len(arguments.prependToPage));
			}
			if (Len(arguments.appendToPage) && !arguments.appendOnLast)
			{
				loc.middle = Mid(loc.middle, 1, Len(loc.middle)-Len(arguments.appendToPage));
			}
		}
		loc.rv = loc.start & loc.middle & loc.end;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>