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
	<cfargument name="type" type="string" required="false" default="text/css" hint="The `type` attribute for the `link` tag">
	<cfargument name="media" type="string" required="false" default="all" hint="The `media` attribute for the `link` tag">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "sources">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif application.settings.environment IS NOT "production">
		<cfif StructKeyExists(arguments, "href")>
			<cfset $throw(type="Wheels.IncorrectArguments", message="The 'href' argument is not allowed.", extendedInfo="You can't pass in the 'href' argument since it will be determined by Wheels.")>
		<cfelseif StructKeyExists(arguments, "rel")>
			<cfset $throw(type="Wheels.IncorrectArguments", message="The 'rel' argument is not allowed.", extendedInfo="You can't pass in the 'rel' argument since it will be determined by Wheels.")>
		</cfif>
	</cfif>

	<cfset loc.result = "">
	<cfloop list="#arguments.sources#" index="loc.i">
		<cfset loc.href = "#application.wheels.webPath##application.wheels.stylesheetPath#/#Trim(loc.i)#">
		<cfif loc.i Does Not Contain ".">
			<cfset loc.href = loc.href & ".css">
		</cfif>
		<cfset loc.result = loc.result & '<link rel="stylesheet" href="#loc.href#"#loc.attributes# />'>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="javaScriptIncludeTag" returntype="string" access="public" output="false" hint="Returns a `script` tag based on the supplied arguments.">
	<cfargument name="sources" type="string" required="true" hint="The name of a JavaScript file in the `javascripts` folder">
	<cfargument name="type" type="string" required="false" default="text/javascript" hint="The `type` attribute for the `script` tag">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "sources">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif application.settings.environment IS NOT "production">
		<cfif StructKeyExists(arguments, "src")>
			<cfset $throw(type="Wheels.IncorrectArguments", message="The 'src' argument is not allowed.", extendedInfo="You can't pass in the 'src' argument since it will be determined by Wheels.")>
		</cfif>
	</cfif>

	<cfset loc.result = "">
	<cfloop list="#arguments.sources#" index="loc.i">
		<cfset loc.src = "#application.wheels.webPath##application.wheels.javascriptPath#/#Trim(loc.i)#">
		<cfif loc.i Does Not Contain ".">
			<cfset loc.src = loc.src & ".js">
		</cfif>
		<cfset loc.result = loc.result & '<script src="#loc.src#"#loc.attributes#></script>'>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="imageTag" returntype="string" access="public" output="false" hint="">
	<cfargument name="source" type="string" required="true" hint="">
	<cfset var loc = {}>
	<cfif application.settings.environment IS NOT "production">
		<cfif Left(arguments.source, 7) IS NOT "http://" AND NOT FileExists(ExpandPath("#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#"))>
			<cfset $throw(type="Wheels.ImageFileNotFound", message="Wheels could not find '#expandPath('#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#')#' on the local file system.", extendedInfo="Pass in a correct relative path from '#expandPath('#application.wheels.webPath##application.wheels.imagePath#\')#' to an image.")>
		<cfelseif Left(arguments.source, 7) IS NOT "http://" AND arguments.source Does Not Contain ".jpg" AND arguments.source Does Not Contain ".gif" AND arguments.source Does Not Contain ".png">
			<cfset $throw(type="Wheels.ImageFormatNotSupported", message="Wheels can't read image files with that format.", extendedInfo="Use a GIF, JPG or PNG image instead.")>
		</cfif>
	</cfif>

	<cfset loc.category = "image">
	<cfset loc.key = $hashStruct(arguments)>
	<cfset loc.lockName = loc.category & loc.key>
	<!--- double-checked lock --->
	<cflock name="#loc.lockName#" type="readonly" timeout="30">
		<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
	</cflock>
	<cfif IsBoolean(loc.result) AND NOT loc.result>
   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
			<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
			<cfif IsBoolean(loc.result) AND NOT loc.result>
				<cfset arguments.$namedArguments = "source">
				<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
				<cfif Left(arguments.source, 7) IS "http://">
					<cfset loc.src = arguments.source>
				<cfelse>
					<cfset loc.src = "#application.wheels.webPath##application.wheels.imagePath#/#arguments.source#">
					<cfif NOT StructKeyExists(arguments, "width") OR NOT StructKeyExists(arguments, "height")>
						<cfimage action="info" source="#expandPath(loc.src)#" structname="loc.image">
						<cfif loc.image.width GT 0 AND loc.image.height GT 0>
							<cfset loc.attributes = loc.attributes & " width=""#loc.image.width#"" height=""#loc.image.height#""">
						</cfif>
					</cfif>
				</cfif>
				<cfif NOT StructKeyExists(arguments, "alt")>
					<cfset loc.attributes = loc.attributes & " alt=""#titleize(replaceList(spanExcluding(Reverse(spanExcluding(Reverse(loc.src), "/")), "."), "-,_", " , "))#""">
				</cfif>
				<cfset loc.result = "<img src=""#loc.src#""#loc.attributes# />">
				<cfif application.settings.cacheImages>
					<cfset $addToCache(loc.key, loc.result, 86400, loc.category, "internal")>
				</cfif>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn loc.result>
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
