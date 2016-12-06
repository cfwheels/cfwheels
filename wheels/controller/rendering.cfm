<cfscript>
	/**
	*  PUBLIC CONTROLLER REQUEST FUNCTIONS
	*/
	public any function renderPage(
		string controller=variables.params.controller,
		string action=variables.params.action,
		string template="",
		any layout,
		any cache="",
		string returnAs="",
		boolean hideDebugInformation=false
	) {
		$args(name="renderPage", args=arguments);
		$dollarify(arguments, "controller,action,template,layout,cache,returnAs,hideDebugInformation");
		if (get("showDebugInformation"))
		{
			$debugPoint("view");
		}

		// if no layout specific arguments were passed in use the this instance's layout
		if (!Len(arguments.$layout))
		{
			arguments.$layout = $useLayout(arguments.$action);
		}

		// never show debugging out in ajax requests
		if (isAjax())
		{
			arguments.$hideDebugInformation = true;
		}

		// if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request
		if (!arguments.$hideDebugInformation)
		{
			request.wheels.showDebugInformation = true;
		}

		if (get("cachePages") && (IsNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache)))
		{
			local.category = "action";
			local.key = $hashedKey(arguments, variables.params);
			local.lockName = local.category & local.key & application.applicationName;
			local.conditionArgs = {};
			local.conditionArgs.category = local.category;
			local.conditionArgs.key = local.key;
			local.executeArgs = arguments;
			local.executeArgs.category = local.category;
			local.executeArgs.key = local.key;
			local.page = $doubleCheckedLock(name=local.lockName, condition="$getFromCache", execute="$renderPageAndAddToCache", conditionArgs=local.conditionArgs, executeArgs=local.executeArgs);
		}
		else
		{
			local.page = $renderPage(argumentCollection=arguments);
		}
		if (arguments.$returnAs == "string")
		{
			local.rv = local.page;
		}
		else
		{
			variables.$instance.response = local.page;
		}
		if (get("showDebugInformation"))
		{
			$debugPoint("view");
		}
		if(StructKeyExists(local, "rv")){
			return local.rv;
		}
	}

	public void function renderNothing() {
		variables.$instance.response = "";
	}

	public void function renderText(required any text) {
		variables.$instance.response = arguments.text;
	}

	public any function renderPartial(
		required string partial,
		any cache="",
		string layout,
		string returnAs="",
		any dataFunction
	) {
		$args(name="renderPartial", args=arguments);
		local.partial = $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,cache,layout,returnAs,dataFunction"));
		if (arguments.$returnAs == "string")
		{
			local.rv = local.partial;
		}
		else
		{
			variables.$instance.response = local.partial;
		}
		if(structKeyExists(local, "rv")){
			return local.rv;
		}
	}

	public string function response() {
		if ($performedRender()) {
			local.rv = Trim(variables.$instance.response);
		} else {
			local.rv = "";
		}
		return local.rv;
	}

	public void function setResponse(required string content) {
		variables.$instance.response = arguments.content;
	}

	public struct function getRedirect() {
		if ($performedRedirect()) {
			local.rv = variables.$instance.redirect;
		} else {
			local.rv = {};
		}
		return local.rv;
	}

	/**
	*  PRIVATE FUNCTIONS
	*/

	public string function $renderPageAndAddToCache() {
		local.rv = $renderPage(argumentCollection=arguments);
		if (!IsNumeric(arguments.$cache))
		{
			arguments.$cache = get("defaultCacheTime");
		}
		$addToCache(key=arguments.key, value=local.rv, time=arguments.$cache, category=arguments.category);
		return local.rv;
	}

	public string function $renderPage() {
		if (!Len(arguments.$template))
		{
			arguments.$template = "/" & ListChangeDelims(arguments.$controller, '/', '.') & "/" & arguments.$action;
		}
		arguments.$type = "page";
		arguments.$name = arguments.$template;
		arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
		local.content = $includeFile(argumentCollection=arguments);
		local.rv = $renderLayout($content=local.content, $layout=arguments.$layout, $type=arguments.$type);
		return local.rv;
	}

	public string function $renderPartialAndAddToCache() {
		local.rv = $renderPartial(argumentCollection=arguments);
		if (!IsNumeric(arguments.$cache))
		{
			arguments.$cache = get("defaultCacheTime");
		}
		$addToCache(key=arguments.key, value=local.rv, time=arguments.$cache, category=arguments.category);
		return local.rv;
	}

	public struct function $argumentsForPartial() {
		local.rv = {};
		if (StructKeyExists(arguments, "$dataFunction") && arguments.$dataFunction != false)
		{
			if (IsBoolean(arguments.$dataFunction))
			{
				local.dataFunction = SpanExcluding(ListLast(arguments.$name, "/"), ".");
				if (StructKeyExists(variables, local.dataFunction))
				{
					local.metaData = GetMetaData(variables[local.dataFunction]);
					if (IsStruct(local.metaData) && StructKeyExists(local.metaData, "returnType") && local.metaData.returnType == "struct" && StructKeyExists(local.metaData, "access") && local.metaData.access == "private")
					{
						local.rv = $invoke(method=local.dataFunction, invokeArgs=arguments);
					}
				}
			}
			else
			{
				local.rv = $invoke(method=arguments.$dataFunction, invokeArgs=arguments);
			}
		}
		return local.rv;
	}

	public string function $renderPartial() {
		local.rv = "";
		if (IsQuery(arguments.$partial) && arguments.$partial.recordCount)
		{
			arguments.$name = request.wheels[$hashedKey(arguments.$partial)];
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
			arguments.$type = "partial";
			arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
			StructAppend(arguments, $argumentsForPartial(argumentCollection=arguments), false);
			local.content = $includeFile(argumentCollection=arguments);
			local.rv = $renderLayout($content=local.content, $layout=arguments.$layout, $type=arguments.$type);
		}
		return local.rv;
	}

	public string function $includeOrRenderPartial() {
		if (get("cachePartials") && (isNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache)))
		{
			local.category = "partial";
			local.key = $hashedKey(arguments);
			local.lockName = local.category & local.key & application.applicationName;
			local.conditionArgs = {};
			local.conditionArgs.category = local.category;
			local.conditionArgs.key = local.key;
			local.executeArgs = arguments;
			local.executeArgs.category = local.category;
			local.executeArgs.key = local.key;
			local.rv = $doubleCheckedLock(name=local.lockName, condition="$getFromCache", execute="$renderPartialAndAddToCache", conditionArgs=local.conditionArgs, executeArgs=local.executeArgs);
		}
		else
		{
			local.rv = $renderPartial(argumentCollection=arguments);
		}
		return local.rv;
	}

	public string function $generateIncludeTemplatePath(
		required any $name,
		required any $type,
		string $controllerName=variables.params.controller,
		string $baseTemplatePath=get('viewPath'),
		boolean $prependWithUnderscore=true
	) {
		local.rv = arguments.$baseTemplatePath;

		// handle dot notation in the controller name
		arguments.$controllerName = ListChangeDelims(arguments.$controllerName, '/', '.');

		// extracts the file part of the path and replace ending ".cfm"
		local.fileName = ReplaceNoCase(Reverse(ListFirst(Reverse(arguments.$name), "/")), ".cfm", "", "all") & ".cfm";

		if (arguments.$type == "partial" && arguments.$prependWithUnderscore)
		{
			// replace leading "_" when the file is a partial
			local.fileName = Replace("_" & local.fileName, "__", "_", "one");
		}
		local.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));
		if (Left(arguments.$name, 1) == "/")
		{
			// include a file in a sub folder to views
			local.rv &= local.folderName & "/" & local.fileName;
		}
		else if (Find("/", arguments.$name))
		{
			// include a file in a sub folder of the current controller
			local.rv &= "/" & arguments.$controllerName & "/" & local.folderName & "/" & local.fileName;
		}
		else
		{
			// include a file in the current controller's view folder
			local.rv &= "/" & arguments.$controllerName & "/" & local.fileName;
		}
		local.rv = LCase(local.rv);
		return local.rv;
	}

	public string function $includeFile(
		required any $name,
		required any $template,
		required any $type
	) {
		if (arguments.$type == "partial")
		{
			if (StructKeyExists(arguments, "query") && IsQuery(arguments.query))
			{
				local.query = arguments.query;
				StructDelete(arguments, "query");
				local.rv = "";
				local.iEnd = local.query.recordCount;
				if (Len(arguments.$group))
				{
					// we want to group based on a column so loop through the rows until we find, this will break if the query is not ordered by the grouped column
					local.tempSpacer = "}|{";
					local.groupValue = "";
					local.groupQueryCount = 1;
					arguments.group = QueryNew(local.query.columnList);
					if (get("showErrorInformation") && !ListFindNoCase(local.query.columnList, arguments.$group))
					{
						$throw(type="Wheels.GroupColumnNotFound", message="CFWheels couldn't find a query column with the name of `#arguments.$group#`.", extendedInfo="Make sure your finder method has the column `#arguments.$group#` specified in the `select` argument. If the column does not exist, create it.");
					}
					for (local.i=1; local.i <= local.iEnd; local.i++)
					{
						if (local.i == 1)
						{
							local.groupValue = local.query[arguments.$group][local.i];
						}
						else if (local.groupValue != local.query[arguments.$group][local.i])
						{
							// we have a different group for this row so output what we have
							local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
							if (StructKeyExists(arguments, "$spacer"))
							{
								local.rv &= local.tempSpacer;
							}
							local.groupValue = local.query[arguments.$group][local.i];
							arguments.group = QueryNew(local.query.columnList);
							local.groupQueryCount = 1;
						}
						QueryAddRow(arguments.group);
						local.jEnd = ListLen(local.query.columnList);
						for (local.j=1; local.j <= local.jEnd; local.j++)
						{
							local.property = ListGetAt(local.query.columnList, local.j);
							arguments[local.property] = local.query[local.property][local.i];
							QuerySetCell(arguments.group, local.property, local.query[local.property][local.i], local.groupQueryCount);
						}
						arguments.current = local.i + 1 - arguments.group.recordCount;
						local.groupQueryCount++;
					}

					// if we have anything left at the end we need to render it too
					if (arguments.group.recordCount)
					{
						local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd)
						{
							local.rv &= local.tempSpacer;
						}
					}

					// now remove the last temp spacer and replace the tempSpacer with $spacer
					if (Right(local.rv, 3) == local.tempSpacer)
					{
						local.rv = Left(local.rv, Len(local.rv) - 3);
					}
					local.rv = Replace(local.rv, local.tempSpacer, arguments.$spacer, "all");
				}
				else
				{
					for (local.i=1; local.i <= local.iEnd; local.i++)
					{
						arguments.current = local.i;
						arguments.totalCount = local.iEnd;
						local.jEnd = ListLen(local.query.columnList);
						for (local.j=1; local.j <= local.jEnd; local.j++)
						{
							local.property = ListGetAt(local.query.columnList, local.j);
							try
							{
								arguments[local.property] = local.query[local.property][local.i];
							}
							catch (any e)
							{
								arguments[local.property] = "";
							}
						}
						local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd)
						{
							local.rv &= arguments.$spacer;
						}
					}
				}
			}
			else if (StructKeyExists(arguments, "object") && IsObject(arguments.object))
			{
				local.modelName = arguments.object.$classData().modelName;
				arguments[local.modelName] = arguments.object;
				StructDelete(arguments, "object");
				StructAppend(arguments, arguments[local.modelName].properties(), false);
			}
			else if (StructKeyExists(arguments, "objects") && IsArray(arguments.objects))
			{
				local.array = arguments.objects;
				StructDelete(arguments, "objects");
				local.originalArguments = Duplicate(arguments);
				local.modelName = local.array[1].$classData().modelName;
				local.rv = "";
				local.iEnd = ArrayLen(local.array);
				for (local.i=1; local.i <= local.iEnd; local.i++)
				{
					StructClear(arguments);
					StructAppend(arguments, local.originalArguments);
					arguments.current = local.i;
					arguments.totalCount = local.iEnd;
					arguments[local.modelName] = local.array[local.i];
					local.properties = local.array[local.i].properties();
					StructAppend(arguments, local.properties, true);
					local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
					if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd)
					{
						local.rv &= arguments.$spacer;
					}
				}
			}
		}
		if (!StructKeyExists(local, "rv"))
		{
			local.rv = $includeAndReturnOutput(argumentCollection=arguments);
		}
		return local.rv;
	}

	public boolean function $performedRenderOrRedirect() {
		if ($performedRender() || $performedRedirect())	{
			local.rv = true;
		} else {
			local.rv = false;
		}
		return local.rv;
	}

	public boolean function $performedRender() {
		return StructKeyExists(variables.$instance, "response");
	}

	public boolean function $performedRedirect() {
		return StructKeyExists(variables.$instance, "redirect");
	}

	public boolean function $abortIssued() {
		return StructKeyExists(variables.$instance, "abort");
	}

	public boolean function $reCacheRequired() {
		return StructKeyExists(variables.$instance, "reCache") && variables.$instance.reCache;
	}
</cfscript>
