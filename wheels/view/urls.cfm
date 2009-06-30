<cffunction name="linkTo" returntype="string" access="public" output="false" hint="Creates a link to another page in your application. Pass in a route name to use your configured routes or a controller/action/key combination.">
	<cfargument name="text" type="string" required="false" default="" hint="The text content of the link">
	<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.linkTo.onlyPath#" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="#application.wheels.linkTo.host#" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.linkTo.protocol#" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.linkTo.port#" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="linkTo", reserved="href", input=arguments);
		if (Len(arguments.confirm))
		{
			loc.onclick = "return confirm('#arguments.confirm#');";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
		}
		arguments.href = URLFor(argumentCollection=arguments);
		arguments.href = Replace(arguments.href, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		if (!Len(arguments.text))
			arguments.text = arguments.href;
		loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
		loc.returnValue = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="Creates a form containing a single button that submits to the URL. The URL is built the same way as the `linkTo` function.">
	<cfargument name="text" type="string" required="false" default="#application.wheels.buttonTo.text#" hint="See documentation for `linkTo`">
	<cfargument name="confirm" type="string" required="false" default="#application.wheels.buttonTo.confirm#" hint="See documentation for `linkTo`">
	<cfargument name="image" type="string" required="false" default="#application.wheels.buttonTo.image#" hint="If you want to use an image for the button pass in the link to it here (relative from the `images` folder)">
	<cfargument name="disable" type="any" required="false" default="#application.wheels.buttonTo.disable#" hint="Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks) or pass in a string if you want the button disabled and the text on the button updated (to 'please wait...' for example)">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.buttonTo.onlyPath#" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="#application.wheels.buttonTo.host#" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.buttonTo.protocol#" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.buttonTo.port#" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="buttonTo", reserved="method", input=arguments);
		arguments.action = URLFor(argumentCollection=arguments);
		arguments.action = Replace(arguments.action, "&", "&amp;", "all"); // make sure we return XHMTL compliant code
		arguments.method = "post";
		if (Len(arguments.confirm))
		{
			loc.onsubmit = "return confirm('#JSStringFormat(Replace(arguments.confirm, """", '&quot;', 'all'))#');";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
		}
		loc.content = submitTag(value=arguments.text, image=arguments.image, disable=arguments.disable);
		loc.skip = "disable,image,text,confirm,route,controller,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
		loc.returnValue = $element(name="form", skip=loc.skip, content=loc.content, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="mailTo" returntype="string" access="public" output="false" hint="Creates a mailto link tag to the specified email address, which is also used as the name of the link unless name is specified.">
	<cfargument name="emailAddress" type="string" required="true" hint="The email address to link to">
	<cfargument name="name" type="string" required="false" default="" hint="A string to use as the link text ('Joe' or 'Support Department' for example)">
	<cfargument name="encode" type="boolean" required="false" default="#application.wheels.mailTo.encode#" hint="Pass true here to encode the email address, making it harder for bots to harvest it">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="mailTo", reserved="href", input=arguments);
		arguments.href = "mailto:#arguments.emailAddress#";
		if (Len(arguments.name))
			loc.content = arguments.name;
		else
			loc.content = arguments.emailAddress;
		loc.returnValue = $element(name="a", skip="emailAddress,name,encode", content=loc.content, attributes=arguments);
		if (arguments.encode)
		{
			loc.js = "document.write('#Trim(loc.returnValue)#');";
			loc.encoded = "";
			loc.iEnd = Len(loc.js);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				loc.encoded = loc.encoded & "%" & Right("0" & FormatBaseN(Asc(Mid(loc.js,loc.i,1)),16),2);
			}
			loc.content = "eval(unescape('#loc.encoded#'))";
			loc.returnValue = $element(name="script", content=loc.content, type="text/javascript");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="autoLink" returntype="string" access="public" output="false" hint="Turns all URLs and e-mail addresses into clickable links.">
	<cfargument name="text" type="string" required="true" hint="The text to create links in">
	<cfargument name="link" type="string" required="false" default="all" hint="Whether to link URLs, email addresses or both. Possible values are: `all` (default), `URLs` and `emailAddresses`">
	<cfscript>
		var loc = {};
		loc.urlRegex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)";
		loc.mailRegex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))";
		loc.returnValue = arguments.text;
		if (arguments.link != "emailAddresses")
			loc.returnValue = loc.returnValue.ReplaceAll(loc.urlRegex, "$1<a href=""$2"">$2</a>");
		if (arguments.link != "URLs")
			loc.returnValue = REReplaceNoCase(loc.returnValue, loc.mailRegex, "<a href=""mailto:\1"">\1</a>", "all");
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="pagination" returntype="struct" access="public" output="false" hint="Returns a struct with information about the specificed paginated query. The available variables are `currentPage`, `totalPages` and `totalRecords`.">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query to return pagination information for">
	<cfreturn request.wheels[arguments.handle]>
</cffunction>

<cffunction name="paginationLinks" returntype="string" access="public" output="false" hint="Builds and returns a string containing links to pages based on a paginated query. Uses `linkTo` internally to build the link so you need to pass in a route name, controller or action. All other `linkTo` arguments can of course be supplied as well in which case they are passed through directly to `linkTo`. If you have paginated more than one query in the controller you can use the `handle` argument to reference them (don't forget to pass in a `handle` to the `findAll` function in your controller first though).">
	<cfargument name="windowSize" type="numeric" required="false" default="#application.wheels.paginationLinks.windowSize#" hint="The number of page links to show around the current page">
	<cfargument name="alwaysShowAnchors" type="boolean" required="false" default="#application.wheels.paginationLinks.alwaysShowAnchors#" hint="Whether or not links to the first and last page should always be displayed">
	<cfargument name="anchorDivider" type="string" required="false" default="#application.wheels.paginationLinks.anchorDivider#" hint="String to place next to the anchors on either side of the list">
	<cfargument name="linkToCurrentPage" type="boolean" required="false" default="#application.wheels.paginationLinks.linkToCurrentPage#" hint="Whether or not the current page should be linked to">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.paginationLinks.prepend#" hint="String or HTML to be prepended before result">
	<cfargument name="append" type="string" required="false" default="#application.wheels.paginationLinks.append#" hint="String or HTML to be appended after result">
	<cfargument name="prependToPage" type="string" required="false" default="#application.wheels.paginationLinks.prependToPage#" hint="String or HTML to be prepended before each page number">
	<cfargument name="prependOnFirst" type="boolean" required="false" default="#application.wheels.paginationLinks.prependOnFirst#" hint="Whether or not to prepend the `prependToPage` string on the first page in the list">
	<cfargument name="appendToPage" type="string" required="false" default="#application.wheels.paginationLinks.appendToPage#" hint="String or HTML to be appended after each page number">
	<cfargument name="appendOnLast" type="boolean" required="false" default="#application.wheels.paginationLinks.appendOnLast#" hint="Whether or not to append the `appendToPage` string on the last page in the list">
	<cfargument name="classForCurrent" type="string" required="false" default="#application.wheels.paginationLinks.classForCurrent#" hint="Class name for the current page number (if `linkToCurrentPage` is `true` the class name will go on the `a` element, if not, a `span` element will be used)">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">
	<cfargument name="name" type="string" required="false" default="#application.wheels.paginationLinks.name#" hint="The name of the param that holds the current page number">
	<cfargument name="showSinglePage" type="boolean" required="false" default="#application.wheels.paginationLinks.showSinglePage#" hint="Will show a single page when set to `true` (the default behavior is to return an empty string when there is only one page in the pagination)">
	
	<cfscript>
		var loc = {};

		// deprecating because the name of the arguments are not appropriate since the prepend/append can sometimes go on elements that are not links 
		if (StructKeyExists(arguments, "prependToLink"))
		{
			$deprecated("The `prependToLink` argument to `paginationLinks` will be deprecated in a future version of Wheels, please use `prependToPage` instead.");
			arguments.prependToPage = arguments.prependToLink;
			StructDelete(arguments, "prependToLink");
		}
		if (StructKeyExists(arguments, "appendToLink"))
		{
			$deprecated("The `appendToLink` argument to `paginationLinks` will be deprecated in a future version of Wheels, please use `appendToPage` instead.");
			arguments.appendToPage = arguments.appendToLink;
			StructDelete(arguments, "appendToLink");
		}

		arguments = $insertDefaults(name="paginationLinks", input=arguments);
		loc.skipArgs = "windowSize,alwaysShowAnchors,anchorDivider,linkToCurrentPage,prepend,append,prependToPage,prependOnFirst,appendToPage,appendOnLast,classForCurrent,handle,name,showSinglePage";
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
		if (arguments.showSinglePage || loc.totalPages > 1)
		{
			if (Len(arguments.prepend))
				loc.start = loc.start & arguments.prepend;
			if (arguments.alwaysShowAnchors)
			{
				if ((loc.currentPage - arguments.windowSize) > 1)
				{
					loc.pageNumber = 1;
					if (StructKeyExists(arguments, "route"))
					{
						loc.linkToArguments[arguments.name] = loc.pageNumber;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.pageNumber;
						if (StructKeyExists(arguments, "params"))
							loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params;
					}
					loc.linkToArguments.text = loc.pageNumber;
					loc.start = loc.start & linkTo(argumentCollection=loc.linkToArguments) & arguments.anchorDivider;
				}
			}
			loc.middle = "";
			for (loc.i=1; loc.i <= loc.totalPages; loc.i++)
			{
				if ((loc.i >= (loc.currentPage - arguments.windowSize) && loc.i <= loc.currentPage) || (loc.i <= (loc.currentPage + arguments.windowSize) && loc.i >= loc.currentPage))
				{
					if (StructKeyExists(arguments, "route"))
					{
						loc.linkToArguments[arguments.name] = loc.i;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.i;
						if (StructKeyExists(arguments, "params"))
							loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params;
					}
					loc.linkToArguments.text = loc.i;
					if (Len(arguments.classForCurrent) && loc.currentPage == loc.i)
						loc.linkToArguments.class = arguments.classForCurrent;
					else
						StructDelete(loc.linkToArguments, "class");
					if (Len(arguments.prependToPage))
						loc.middle = loc.middle & arguments.prependToPage;
					if (loc.currentPage != loc.i || arguments.linkToCurrentPage)
					{
						loc.middle = loc.middle & linkTo(argumentCollection=loc.linkToArguments);
					}
					else
					{
						if (Len(arguments.classForCurrent))
							loc.middle = loc.middle & $element(name="span", content=loc.i, class=arguments.classForCurrent);
						else
							loc.middle = loc.middle & loc.i;
					}
					if (Len(arguments.appendToPage))
						loc.middle = loc.middle & arguments.appendToPage;
				}
			}
			if (arguments.alwaysShowAnchors)
			{
				if (loc.totalPages > (loc.currentPage + arguments.windowSize))
				{
					if (StructKeyExists(arguments, "route"))
					{
						loc.linkToArguments[arguments.name] = loc.totalPages;
					}
					else
					{
						loc.linkToArguments.params = arguments.name & "=" & loc.totalPages;
						if (StructKeyExists(arguments, "params"))
							loc.linkToArguments.params = loc.linkToArguments.params & "&" & arguments.params;
					}
					loc.linkToArguments.text = loc.totalPages;
					loc.end = loc.end & arguments.anchorDivider & linkTo(argumentCollection=loc.linkToArguments);
				}
			}
			if (Len(arguments.append))
				loc.end = loc.end & arguments.append;
		}
		if (Len(arguments.prependToPage) && !arguments.prependOnFirst)
			loc.middle = Mid(loc.middle, Len(arguments.prependToPage)+1, Len(loc.middle)-Len(arguments.prependToPage)) ;
		if (Len(arguments.appendToPage) && !arguments.appendOnLast)
			loc.middle = Mid(loc.middle, 1, Len(loc.middle)-Len(arguments.appendToPage)) ;
		loc.returnValue = loc.start & loc.middle & loc.end;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>