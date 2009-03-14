<cffunction name="contentForLayout" returntype="string" access="public" output="false" hint="Used inside a layout file to output the HTML created in the view.">
	<cfreturn request.wheels.contentForLayout>
</cffunction>

<cffunction name="paginationLinks" returntype="string" access="public" output="false" hint="Builds and returns a string containing links to pages based on a paginated query. Uses `linkTo` internally to build the link so you need to pass in a route name, controller or action. All other `linkTo` arguments can of course be supplied as well in which case they are passed through directly to `linkTo`. If you have paginated more than one query in the controller you can use the `handle` argument to reference them (don't forget to pass in a `handle` to the `findAll` function in your controller first though).">
	<cfargument name="windowSize" type="numeric" required="false" default="2" hint="The number of page links to show around the current page">
	<cfargument name="alwaysShowAnchors" type="boolean" required="false" default="true" hint="Whether or not links to the first and last page should always be displayed">
	<cfargument name="anchorDivider" type="string" required="false" default=" ... " hint="String to place next to the anchors on either side of the list">
	<cfargument name="linkToCurrentPage" type="boolean" required="false" default="false" hint="Whether or not the current page should be linked to">
	<cfargument name="prependToLink" type="string" required="false" default="" hint="String to be prepended before all links">
	<cfargument name="appendToLink" type="string" required="false" default="" hint="String to be appended after all links">
	<cfargument name="classForCurrent" type="string" required="false" default="" hint="Class name for the link to the current page">
	<cfargument name="handle" type="string" required="false" default="query" hint="The handle given to the query that the pagination links should be displayed for">
	<cfargument name="name" type="string" required="false" default="page" hint="The name of the param that holds the current page number">
	<cfscript>
		var loc = {};
		loc.returnValue = ""; 
		loc.namedArgs = "windowSize,alwaysShowAnchors,linkToCurrentPage,prependToLink,appendToLink,classForCurrent,handle,name";
		loc.linkToArguments = StructCopy(arguments);
		loc.iEnd = ListLen(loc.namedArgs);
		for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
		{
			StructDelete(loc.linkToArguments, ListGetAt(loc.namedArgs, loc.i));
		}
		loc.currentPage = request.wheels[arguments.handle].currentPage;
		loc.totalPages = request.wheels[arguments.handle].totalPages;
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
					loc.toAdd = arguments.name & "=" & loc.pageNumber;
					if (StructKeyExists(arguments, "params"))
						loc.linkToArguments.params = loc.linkToArguments.params & "&" & loc.toAdd;
					else
						loc.linkToArguments.params = loc.toAdd;
				}
				loc.linkToArguments.text = loc.pageNumber;
				loc.returnValue = loc.returnValue & linkTo(argumentCollection=loc.linkToArguments) & arguments.anchorDivider;
			}
		}
		for (loc.i=1; loc.i<=loc.totalPages; loc.i++)
		{
			if ((loc.i >= (loc.currentPage - arguments.windowSize) && loc.i <= loc.currentPage) || (loc.i <= (loc.currentPage + arguments.windowSize) && loc.i >= loc.currentPage))
			{
				if (StructKeyExists(arguments, "route"))
				{
					loc.linkToArguments[arguments.name] = loc.i;
				}
				else
				{
					loc.toAdd = arguments.name & "=" & loc.i;
					if (StructKeyExists(arguments, "params"))
						loc.linkToArguments.params = loc.linkToArguments.params & "&" & loc.toAdd;
					else
						loc.linkToArguments.params = loc.toAdd;
				}
				loc.linkToArguments.text = loc.i;
				if (Len(arguments.classForCurrent) && loc.currentPage == loc.i)
					loc.linkToArguments.class = arguments.classForCurrent;
				else
					StructDelete(loc.linkToArguments, "class");
				if (Len(arguments.prependToLink))
					loc.returnValue = loc.returnValue & arguments.prependToLink;
				if (loc.currentPage != loc.i || arguments.linkToCurrentPage)
				{
					loc.returnValue = loc.returnValue & linkTo(argumentCollection=loc.linkToArguments);
				}
				else
				{
					if (Len(arguments.classForCurrent))
						loc.returnValue = loc.returnValue & "<span class=""" & arguments.classForCurrent & """>" & loc.i & "</span>";
					else
						loc.returnValue = loc.returnValue & loc.i;
				}
				if (Len(arguments.appendToLink))
					loc.returnValue = loc.returnValue & arguments.appendToLink;
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
					loc.toAdd = arguments.name & "=" & loc.totalPages;
					if (StructKeyExists(arguments, "params"))
						loc.linkToArguments.params = loc.linkToArguments.params & "&" & loc.toAdd;
					else
						loc.linkToArguments.params = loc.toAdd;
				}
				loc.linkToArguments.text = loc.totalPages;
				loc.returnValue = loc.returnValue & arguments.anchorDivider & linkTo(argumentCollection=loc.linkToArguments);
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="includePartial" returntype="string" access="public" output="false" hint="Includes a specified file. Similar to using `cfinclude` but with the ability to cache the result and using Wheels specific file look-up. By default Wheels will look for the file in the current controller's view folder. To include a file relative from the `views` folder you can start the path supplied to `name` with a forward slash.">
	<cfargument name="name" type="string" required="true" hint="The name of the file to be included (starting with an optional path and with the underscore and file extension excluded)">
	<cfargument name="cache" type="any" required="false" default="" hint="Number of minutes to cache the partial for">
	<cfargument name="$type" type="string" required="false" default="include">
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="styleSheetLinkTag" returntype="string" access="public" output="false" hint="Returns a `link` tag based on the supplied arguments.">
	<cfargument name="sources" type="any" required="true" hint="The name of a CSS file in the `stylesheets` folder">
	<cfargument name="type" type="string" required="false" default="#application.wheels.styleSheetLinkTag.type#" hint="The `type` attribute for the `link` tag">
	<cfargument name="media" type="string" required="false" default="#application.wheels.styleSheetLinkTag.media#" hint="The `media` attribute for the `link` tag">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="styleSheetLinkTag", reserved="href,rel", input=arguments);
		arguments.rel = "stylesheet";
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.sources);
		for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.sources, loc.i);
			arguments.href = application.wheels.webPath & application.wheels.stylesheetPath & "/" & Trim(loc.item);
			if (loc.item Does Not Contain ".")
				arguments.href = arguments.href & ".css";
			loc.returnValue = loc.returnValue & $tag(name="link", skip="sources", close=true, attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="javaScriptIncludeTag" returntype="string" access="public" output="false" hint="Returns a `script` tag based on the supplied arguments.">
	<cfargument name="sources" type="string" required="true" hint="The name of a JavaScript file in the `javascripts` folder">
	<cfargument name="type" type="string" required="false" default="#application.wheels.javaScriptIncludeTag.type#" hint="The `type` attribute for the `script` tag">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="javaScriptIncludeTag", reserved="src", input=arguments);
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.sources);
		for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.sources, loc.i);
			arguments.src = application.wheels.webPath & application.wheels.javascriptPath & "/" & Trim(loc.item);
			if (loc.item Does Not Contain ".")
				arguments.src = arguments.src & ".js";
			loc.returnValue = loc.returnValue & $element(name="script", skip="sources", attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="imageTag" returntype="string" access="public" output="false" hint="Returns an image tag and will (if the image is stored in the local `images` folder) set the `width`, `height` and `alt` attributes automatically for you.">
	<cfargument name="source" type="string" required="true" hint="Image file name if local or full URL if remote">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="imageTag", reserved="src", input=arguments);
		if (application.wheels.cacheImages)
		{
			loc.category = "image";
			loc.key = $hashStruct(arguments);
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			loc.returnValue = $doubleCheckLock(name=loc.lockName, condition="$getFromCache", execute="$addImageTagToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			loc.returnValue = $imageTag(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$addImageTagToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $imageTag(argumentCollection=arguments);
		$addToCache(key=arguments.key, value=returnValue, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$imageTag" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (Left(arguments.source, 7) == "http://")
		{
			arguments.src = arguments.source;
		}
		else
		{
			arguments.src = application.wheels.webPath & application.wheels.imagePath & "/" & arguments.source;
			if (application.wheels.environment != "production")
			{
				if (Left(arguments.source, 7) != "http://" && !FileExists(ExpandPath(arguments.src)))
					$throw(type="Wheels.ImageFileNotFound", message="Wheels could not find '#expandPath('#arguments.src#')#' on the local file system.", extendedInfo="Pass in a correct relative path from the 'images' folder to an image.");
				else if (Left(arguments.source, 7) != "http://" && arguments.source Does Not Contain ".jpg" && arguments.source Does Not Contain ".gif" && arguments.source Does Not Contain ".png")
					$throw(type="Wheels.ImageFormatNotSupported", message="Wheels can't read image files with that format.", extendedInfo="Use a GIF, JPG or PNG image instead.");
			}
			if (!StructKeyExists(arguments, "width") || !StructKeyExists(arguments, "height"))
			{
				loc.image = $image(action="info", source=expandPath(arguments.src));
				if (loc.image.width > 0 && loc.image.height > 0)
				{
					arguments.width = loc.image.width;
					arguments.height = loc.image.height;
				}
			}
		}
		if (!StructKeyExists(arguments, "alt"))
			arguments.alt = $capitalize(ReplaceList(SpanExcluding(Reverse(SpanExcluding(Reverse(arguments.src), "/")), "."), "-,_", " , "));
		loc.returnValue = $tag(name="img", skip="source", close=true, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$trimHTML" returntype="string" access="public" output="false">
	<cfargument name="str" type="string" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>

<cffunction name="$getAttributes" returntype="string" access="public" output="false">
	<cfset var loc = {}>

	<cfset loc.attributes = "">
	<cfloop collection="#arguments#" item="loc.i">
		<cfif loc.i Does Not Contain "$" AND listFindNoCase(arguments.$namedArguments, loc.i) IS 0>
			<cfset loc.attributes = "#loc.attributes# #lCase(loc.i)#=""#arguments[loc.i]#""">
		</cfif>
	</cfloop>

	<cfreturn loc.attributes>
</cffunction>
