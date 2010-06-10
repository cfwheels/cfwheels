<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="renderPage" returntype="any" access="public" output="false" hint="Renders content to the browser by including the view page for the specified `controller` and `action`."
	examples=
	'
		<!--- Render a view page for a different action than the current one --->
		<cfset renderPage(action="someOtherAction")>

		<!--- Render the view page for the current action but without a layout and cache it for 60 minutes --->
		<cfset renderPage(layout=false, cache=60)>
	'
	categories="controller-request,rendering" chapters="rendering-pages" functions="renderNothing,renderText,renderPartial">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for.">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for.">
	<cfargument name="template" type="string" required="false" default="" hint="A specific template to render.">
	<cfargument name="layout" type="any" required="false" hint="The layout to wrap the content in.">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for.">
	<cfargument name="returnAs" type="string" required="false" default="" hint="Set to `string` to return the result to the controller instead of sending it to the browser immediately.">
	<cfargument name="hideDebugInformation" type="boolean" required="false" default="false" hint="Set to `true` to hide the debug information at the end of the output. This is useful when you're testing XML output in an environment where the global setting for `showDebugInformation` is `true` for example.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="renderPage", input=arguments);
		$dollarify(arguments, "controller,action,template,layout,cache,returnAs,hideDebugInformation");
		if (application.wheels.showDebugInformation)
			$debugPoint("view");
		// if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request
		if ((!IsBoolean(arguments.$layout) || arguments.$layout) && !arguments.$hideDebugInformation)
			request.wheels.showDebugInformation = true;
		if (application.wheels.cachePages && (IsNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache)))
		{
			loc.category = "action";
			loc.key = "#arguments.$action##$hashStruct(variables.params)##$hashStruct(arguments)#";
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			loc.page = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$renderPageAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			loc.page = $renderPage(argumentCollection=arguments);
		}
		if (arguments.$returnAs == "string")
			loc.returnValue = loc.page;
		else
			request.wheels.response = loc.page;
		if (application.wheels.showDebugInformation)
			$debugPoint("view");
	</cfscript>
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="renderNothing" returntype="void" access="public" output="false" hint="Renders a blank string to the browser. This is very similar to calling `cfabort` with the advantage that any after filters you have set on the action will still be run."
	examples=
	'
		<!--- Render a blank white page to the browser --->
		<cfset renderNothing()>
	'
	categories="controller-request,rendering" chapters="rendering-pages" functions="renderPage,renderText,renderPartial">
	<cfscript>
		request.wheels.response = "";
	</cfscript>
</cffunction>

<cffunction name="renderText" returntype="void" access="public" output="false" hint="Renders the specified text to the browser."
	examples=
	'
		<!--- Render just the text "Done!" to the browser --->
		<cfset renderText("Done!")>
	'
	categories="controller-request,rendering" chapters="rendering-pages" functions="renderPage,renderNothing,renderPartial">
	<cfargument name="text" type="any" required="true" hint="The text to be rendered.">
	<cfscript>
		request.wheels.response = arguments.text;
	</cfscript>
</cffunction>

<cffunction name="renderPartial" returntype="any" access="public" output="false" hint="Renders content to the browser by including a partial."
	examples=
	'
		<!--- Render the partial `_comment.cfm` located in the current controller''s view folder --->
		<cfset renderPartial("comment")>
	'
	categories="controller-request,rendering" chapters="rendering-pages" functions="renderPage,renderNothing,renderText">
	<cfargument name="partial" type="string" required="true" hint="The name of the file to be used (starting with an optional path and with the underscore and file extension excluded).">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @renderPage.">
	<cfargument name="layout" type="string" required="false" hint="See documentation for @renderPage.">
	<cfargument name="returnAs" type="string" required="false" default="" hint="See documentation for @renderPage.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="renderPartial", input=arguments);
		loc.partial = $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,cache,layout,returnAs"));
		if (arguments.$returnAs == "string")
			loc.returnValue = loc.partial;
		else
			request.wheels.response = loc.partial;
	</cfscript>
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$renderPageAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $renderPage(argumentCollection=arguments);
		if (!IsNumeric(arguments.$cache))
			arguments.$cache = application.wheels.defaultCacheTime;
		$addToCache(key=arguments.key, value=returnValue, time=arguments.$cache, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$renderPage" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (!Len(arguments.$template))
			arguments.$template = "/" & arguments.$controller & "/" & arguments.$action;
		arguments.$type = "page";
		arguments.$name = arguments.$template;
		arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
		loc.content = $includeFile(argumentCollection=arguments);
		loc.returnValue = $renderLayout($content=loc.content, $layout=arguments.$layout);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderPartialAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $renderPartial(argumentCollection=arguments);
		if (!IsNumeric(arguments.$cache))
			arguments.$cache = application.wheels.defaultCacheTime;
		$addToCache(key=arguments.key, value=returnValue, time=arguments.$cache, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$renderPartial" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (IsQuery(arguments.$partial) && arguments.$partial.recordCount)
		{
			arguments.$name = request.wheels[Hash(SerializeJSON(arguments.$partial))];
			arguments.query = arguments.$partial;
		}
		else if (IsObject(arguments.$partial))
		{
			arguments.$name = arguments.$partial.$classData().modelName;
			arguments.object = arguments.$partial;
		}
		else if (IsArray(arguments.$partial) && ArrayLen(arguments.$partial))
		{
			arguments.$name = arguments.$partial[1].$classData().modelName;
			arguments.objects = arguments.$partial;
		}
		else if (IsSimpleValue(arguments.$partial))
		{
			arguments.$name = arguments.$partial;
		}
		if (StructKeyExists(arguments, "$name"))
		{
			if (Len(arguments.$layout))
				arguments.$layout = Replace("_" & arguments.$layout, "__", "_", "one");
			arguments.$type = "partial";
			arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
			loc.content = $includeFile(argumentCollection=arguments);
			loc.returnValue = $renderLayout($content=loc.content, $layout=arguments.$layout);
		}
		else
		{
			// when $name has not been set (which means that it's either an empty array or query) we just return an empty string
			loc.returnValue = "";
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$includeOrRenderPartial" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		if (application.wheels.cachePartials && (isNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache)))
		{
			loc.category = "partial";
			loc.key = "#$hashStruct(arguments)#";
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			loc.returnValue = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$renderPartialAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			loc.returnValue = $renderPartial(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$generateIncludeTemplatePath" returntype="string" access="public" output="false">
	<cfargument name="$name" type="any" required="true">
	<cfargument name="$type" type="any" required="true">
	<cfargument name="$baseTemplatePath" type="string" required="false" default="#application.wheels.viewPath#" />
	<cfscript>
		var loc = {};
		loc.include = arguments.$baseTemplatePath;
		loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(arguments.$name), "/")), ".") & ".cfm"; // extracts the file part of the path and replace ending ".cfm"
		if (arguments.$type == "partial")
			loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
		loc.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));
		if (Left(arguments.$name, 1) == "/")
			loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
		else if (arguments.$name Contains "/")
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
		else
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.fileName; // Include a file in the current controller's view folder
	</cfscript>
	<cfreturn loc.include />
</cffunction>

<cffunction name="$includeFile" returntype="string" access="public" output="false">
	<cfargument name="$name" type="any" required="true">
	<cfargument name="$template" type="any" required="true">
	<cfargument name="$type" type="string" required="true">
	<cfscript>
		var loc = {};
		if (arguments.$type == "partial")
		{
			if (StructKeyExists(arguments, "query") && IsQuery(arguments.query))
			{
				loc.query = arguments.query;
				loc.returnValue = "";
				loc.iEnd = loc.query.recordCount;
				if (Len(arguments.$group))
				{
					// we want to group based on a column so loop through the rows until we find, this will break if the query is not ordered by the grouped column
					loc.tempSpacer = "}|{";
					loc.groupValue = "";
					loc.groupQueryCount = 1;
					arguments.group = QueryNew(loc.query.columnList);
					if (application.wheels.showErrorInformation && !ListFindNoCase(loc.query.columnList, arguments.$group))
						$throw(type="Wheels.GroupColumnNotFound", message="Wheels couldn't find a query column with the name of `#arguments.$group#`.", extendedInfo="Make sure your finder method has the column `#arguments.$group#` specified in the `select` argument. If the column does not exist, create it.");
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						if (loc.i == 1)
						{
							loc.groupValue = loc.query[arguments.$group][loc.i];
						}
						else if (loc.groupValue != loc.query[arguments.$group][loc.i])
						{
							// we have a different group for this row so output what we have
							loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
							if (StructKeyExists(arguments, "$spacer"))
								loc.returnValue = loc.returnValue & loc.tempSpacer;
							loc.groupValue = loc.query[arguments.$group][loc.i];
							arguments.group = QueryNew(loc.query.columnList);
							loc.groupQueryCount = 1;
						}
						loc.dump = QueryAddRow(arguments.group);
						loc.jEnd = ListLen(loc.query.columnList);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.property = ListGetAt(loc.query.columnList, loc.j);
							arguments[loc.property] = loc.query[loc.property][loc.i];
							loc.dump = QuerySetCell(arguments.group, loc.property, loc.query[loc.property][loc.i], loc.groupQueryCount);
						}
						arguments.current = (loc.i+1) - arguments.group.recordCount;
						loc.groupQueryCount++;
					}
					// if we have anything left at the end we need to render it too
					if (arguments.group.RecordCount > 0)
					{
						loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
							loc.returnValue = loc.returnValue & loc.tempSpacer;
					}
					// now remove the last temp spacer and replace the tempSpacer with $spacer
					if (Right(loc.returnValue, 3) == loc.tempSpacer)
						loc.returnValue = Left(loc.returnValue, Len(loc.returnValue) - 3);
					loc.returnValue = Replace(loc.returnValue, loc.tempSpacer, arguments.$spacer, "all");
				}
				else
				{
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						arguments.current = loc.i;
						loc.jEnd = ListLen(loc.query.columnList);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.property = ListGetAt(loc.query.columnList, loc.j);
							try
							{
								arguments[loc.property] = loc.query[loc.property][loc.i];
							}
							catch (Any e)
							{
								arguments[loc.property] = "";
							}
						}
						loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
							loc.returnValue = loc.returnValue & arguments.$spacer;
					}
				}
			}
			else if (StructKeyExists(arguments, "object") && IsObject(arguments.object))
			{
				loc.object = arguments.object;
				StructAppend(arguments, loc.object.properties(), false);
			}
			else if (StructKeyExists(arguments, "objects") && IsArray(arguments.objects))
			{
				loc.originalArguments = Duplicate(arguments);
				loc.array = arguments.objects;
				loc.returnValue = "";
				loc.iEnd = ArrayLen(loc.array);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					arguments.current = loc.i;
					loc.properties = loc.array[loc.i].properties();

					// we have to overwrite the values in each loop but first we remove the ones that are in the original arguments since they take precedence
					for (loc.key in loc.originalArguments)
						if (StructKeyExists(loc.properties, loc.key))
							StructDelete(loc.properties, loc.key);
					StructAppend(arguments, loc.properties, true);

					loc.returnValue = loc.returnValue & $includeAndReturnOutput(argumentCollection=arguments);
					if (StructKeyExists(arguments, "$spacer") && loc.i < loc.iEnd)
						loc.returnValue = loc.returnValue & arguments.$spacer;
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			loc.returnValue = $includeAndReturnOutput(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderLayout" returntype="string" access="public" output="false">
	<cfargument name="$content" type="string" required="true">
	<cfargument name="$layout" type="any" required="true">
	<cfscript>
		var loc = {};
		if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout)))
		{
			request.wheels.contentForLayout = arguments.$content; // store the content in a variable in the request scope so it can be accessed by the contentForLayout function that the developer uses in layout files (this is done so we avoid passing data to/from it since it would complicate things for the developer)
			loc.include = application.wheels.viewPath;
			if (IsBoolean(arguments.$layout))
			{
				if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
				{
					if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))
						application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
					else
						application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
				}
				if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller))
				{
					loc.include = loc.include & "/" & variables.params.controller & "/" & "layout.cfm";
				}
				else
				{
					loc.include = loc.include & "/" & "layout.cfm";
				}
				loc.returnValue = $includeAndReturnOutput($template=loc.include);
			}
			else
			{
				arguments.$type = "layout";
				arguments.$name = arguments.$layout;
				arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
				loc.returnValue = $includeFile(argumentCollection=arguments);
			}
		}
		else
		{
			loc.returnValue = arguments.$content;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$performedRenderOrRedirect" returntype="boolean" access="public" output="false">
	<cfreturn ($performedRender() || $performedRedirect())>
</cffunction>

<cffunction name="$performedRender" returntype="boolean" access="public" output="false">
	<cfreturn StructKeyExists(request.wheels, "response")>
</cffunction>

<cffunction name="$performedRedirect" returntype="boolean" access="public" output="false">
	<cfreturn StructKeyExists(request.wheels, "redirect")>
</cffunction>