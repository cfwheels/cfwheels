<cfscript>

/**
 * Instructs the controller which view template and layout to render when it's finished processing the action.
 * Note that when passing values for controller and / or action, this function does not execute the actual action but rather just loads the corresponding view template.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 *
 * @controller Controller to include the view page for.
 * @action Action to include the view page for.
 * @template A specific template to render. Prefix with a leading slash (`/`) if you need to build a path from the root `views` folder.
 * @layout The layout to wrap the content in. Prefix with a leading slash (`/`) if you need to build a path from the root `views` folder. Pass `false` to not load a layout at all.
 * @cache Number of minutes to cache the content for.
 * @returnAs Set to `string` to return the result instead of automatically sending it to the client.
 * @hideDebugInformation Set to `true` to hide the debug information at the end of the output. This is useful, for example, when you're testing XML output in an environment where the global setting for `showDebugInformation` is `true`.
 */
public any function renderView(
	string controller=variables.params.controller,
	string action=variables.params.action,
	string template="",
	any layout,
	any cache="",
	string returnAs="",
	boolean hideDebugInformation=false
) {
	$args(name="renderView", args=arguments);
	$dollarify(arguments, "controller,action,template,layout,cache,returnAs,hideDebugInformation");
	if ($get("showDebugInformation")) {
		$debugPoint("view");
	}

	// If no layout specific arguments were passed in use the this instance's layout.
	if (!Len(arguments.$layout)) {
		arguments.$layout = $useLayout(arguments.$action);
	}

	// Never show debugging out in AJAX requests.
	if (isAjax()) {
		arguments.$hideDebugInformation = true;
	}

	// If renderView was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request.
	if (!arguments.$hideDebugInformation) {
		request.wheels.showDebugInformation = true;
	}

	if ($get("cachePages") && (IsNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache))) {
		local.category = "action";
		local.key = $hashedKey(arguments, variables.params);
		local.lockName = local.category & local.key & application.applicationName;
		local.conditionArgs = {};
		local.conditionArgs.category = local.category;
		local.conditionArgs.key = local.key;
		local.executeArgs = arguments;
		local.executeArgs.category = local.category;
		local.executeArgs.key = local.key;
		local.page = $doubleCheckedLock(
			condition="$getFromCache",
			conditionArgs=local.conditionArgs,
			execute="$renderViewAndAddToCache",
			executeArgs=local.executeArgs,
			name=local.lockName
		);
	} else {
		local.page = $renderView(argumentCollection=arguments);
	}
	if (arguments.$returnAs == "string") {
		local.rv = local.page;
	} else {
		variables.$instance.response = local.page;
	}
	if ($get("showDebugInformation")) {
		$debugPoint("view");
	}
	if (StructKeyExists(local, "rv")) {
		return local.rv;
	}
}

/**
 * Instructs the controller to render an empty string when it's finished processing the action.
 * This is very similar to calling `cfabort` with the advantage that any after filters you have set on the action will still be run.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 */
public void function renderNothing() {
	variables.$instance.response = "";
}

/**
 * Instructs the controller to render specified text when it's finished processing the action.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 *
 * @text The text to render.
 */
public void function renderText(required any text) {
	variables.$instance.response = arguments.text;
}

/**
 * Instructs the controller to render a partial when it's finished processing the action.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 *
 * @partial The name of the partial file to be used. Prefix with a leading slash (`/`) if you need to build a path from the root `views` folder. Do not include the partial filename's underscore and file extension.
 * @cache [see:renderView].
 * @layout [see:renderView].
 * @returnAs [see:renderView].
 * @dataFunction Name of a controller function to load data from.
 */
public any function renderPartial(
	required string partial,
	any cache="",
	string layout,
	string returnAs="",
	any dataFunction
) {
	$args(name="renderPartial", args=arguments);
	local.partial = $includeOrRenderPartial(argumentCollection=$dollarify(arguments, "partial,cache,layout,returnAs,dataFunction"));
	if (arguments.$returnAs == "string") {
		local.rv = local.partial;
	} else {
		variables.$instance.response = local.partial;
	}
	if (StructKeyExists(local, "rv")) {
		return local.rv;
	}
}

/**
 * Returns content that CFWheels will send to the client in response to the request.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 */
public string function response() {
	if ($performedRender()) {
		return Trim(variables.$instance.response);
	} else {
		return "";
	}
}

/**
 * Sets content that CFWheels will send to the client in response to the request.
 *
 * [section: Controller]
 * [category: Rendering Functions]
 *
 * @content The content to send to the client.
 */
public void function setResponse(required string content) {
	variables.$instance.response = arguments.content;
}

/**
 * Primarily used for testing to establish whether the current request has performed a redirect.
 *
 * [section: Controller]
 * [category: Miscellaneous Functions]
 */
public struct function getRedirect() {
	if ($performedRedirect()) {
		return variables.$instance.redirect;
	} else {
		return {};
	}
}

/**
 * Primarily used for testing to get information about emails sent during the request.
 *
 * [section: Controller]
 * [category: Miscellaneous Functions]
 */
public array function getEmails() {
	if ($sentEmails()) {
		return variables.$instance.emails;
	} else {
		return [];
	}
}

/**
 * Primarily used for testing to get information about files sent during the request.
 *
 * [section: Controller]
 * [category: Miscellaneous Functions]
 */
public array function getFiles() {
	if ($sentFiles()) {
		return variables.$instance.files;
	} else {
		return [];
	}
}

/**
 * Internal function.
 */
public string function $renderViewAndAddToCache() {
	local.rv = $renderView(argumentCollection=arguments);
	if (!IsNumeric(arguments.$cache)) {
		arguments.$cache = $get("defaultCacheTime");
	}
	$addToCache(key=arguments.key, value=local.rv, time=arguments.$cache, category=arguments.category);
	return local.rv;
}

/**
 * Internal function.
 */
public string function $renderView() {
	if (!Len(arguments.$template)) {
		arguments.$template = "/" & ListChangeDelims(arguments.$controller, '/', '.') & "/" & arguments.$action;
	}
	arguments.$type = "page";
	arguments.$name = arguments.$template;
	arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
	local.content = $includeFile(argumentCollection=arguments);
	return $renderLayout($content=local.content, $layout=arguments.$layout, $type=arguments.$type);
}

/**
 * Internal function.
 */
public string function $renderPartialAndAddToCache() {
	local.rv = $renderPartial(argumentCollection=arguments);
	if (!IsNumeric(arguments.$cache)) {
		arguments.$cache = $get("defaultCacheTime");
	}
	$addToCache(key=arguments.key, value=local.rv, time=arguments.$cache, category=arguments.category);
	return local.rv;
}

/**
 * Internal function.
 */
public struct function $argumentsForPartial() {
	local.rv = {};
	if (StructKeyExists(arguments, "$dataFunction") && arguments.$dataFunction != false) {
		if (IsBoolean(arguments.$dataFunction)) {
			local.dataFunction = SpanExcluding(ListLast(arguments.$name, "/"), ".");
			if (StructKeyExists(variables, local.dataFunction)) {
				local.metaData = GetMetaData(variables[local.dataFunction]);
				if (IsStruct(local.metaData) && StructKeyExists(local.metaData, "returnType") && local.metaData.returnType == "struct" && StructKeyExists(local.metaData, "access") && local.metaData.access == "private") {
					local.rv = $invoke(method=local.dataFunction, invokeArgs=arguments);
				}
			}
		} else {
			local.rv = $invoke(method=arguments.$dataFunction, invokeArgs=arguments);
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $renderPartial() {
	local.rv = "";
	if (IsQuery(arguments.$partial)) {
		Throw(
			type="Wheels.InvalidPartialArguments",
			message="To use a query with a partial, you must specify both `partial` and `query` arguments",
			extendedInfo="E.g. ##includePartial(partial=""user"", query=""users"")##"
		);
	} else if (IsObject(arguments.$partial)) {
		arguments.$name = arguments.$partial.$classData().modelName;
		arguments.object = arguments.$partial;
	} else if (IsArray(arguments.$partial) && ArrayLen(arguments.$partial)) {
		arguments.$name = arguments.$partial[1].$classData().modelName;
		arguments.objects = arguments.$partial;
	} else if (IsSimpleValue(arguments.$partial)) {
		arguments.$name = arguments.$partial;
	}
	if (StructKeyExists(arguments, "$name")) {
		arguments.$type = "partial";
		arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
		StructAppend(arguments, $argumentsForPartial(argumentCollection=arguments), false);
		local.content = $includeFile(argumentCollection=arguments);
		local.rv = $renderLayout($content=local.content, $layout=arguments.$layout, $type=arguments.$type);
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $includeOrRenderPartial() {
	if ($get("cachePartials") && (isNumeric(arguments.$cache) || (IsBoolean(arguments.$cache) && arguments.$cache))) {
		local.category = "partial";
		local.key = $hashedKey(arguments);
		local.lockName = local.category & local.key & application.applicationName;
		local.conditionArgs = {};
		local.conditionArgs.category = local.category;
		local.conditionArgs.key = local.key;
		local.executeArgs = arguments;
		local.executeArgs.category = local.category;
		local.executeArgs.key = local.key;
		local.rv = $doubleCheckedLock(
			condition="$getFromCache",
			conditionArgs=local.conditionArgs,
			execute="$renderPartialAndAddToCache",
			executeArgs=local.executeArgs,
			name=local.lockName
		);
	} else {
		local.rv = $renderPartial(argumentCollection=arguments);
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $generateIncludeTemplatePath(
	required any $name,
	required any $type,
	string $controllerName=variables.params.controller,
	string $baseTemplatePath=$get("viewPath"),
	boolean $prependWithUnderscore=true
) {
	local.rv = arguments.$baseTemplatePath;

	// Handle dot notation in the controller name.
	arguments.$controllerName = ListChangeDelims(arguments.$controllerName, '/', '.');

	// Extracts the file part of the path and replace ending ".cfm".
	local.fileName = ReplaceNoCase(Reverse(ListFirst(Reverse(arguments.$name), "/")), ".cfm", "", "all") & ".cfm";

	// Replace leading "_" when the file is a partial.
	if (arguments.$type == "partial" && arguments.$prependWithUnderscore) {
		local.fileName = Replace("_" & local.fileName, "__", "_", "one");
	}

	local.folderName = Reverse(ListRest(Reverse(arguments.$name), "/"));

	if (Left(arguments.$name, 1) == "/") {

		// Include a file in a sub folder to views.
		local.rv &= local.folderName & "/" & local.fileName;

	} else if (Find("/", arguments.$name)) {

		// Include a file in a sub folder of the current controller.
		local.rv &= "/" & arguments.$controllerName & "/" & local.folderName & "/" & local.fileName;

	} else {

		// Include a file in the current controller's view folder.
		local.rv &= "/" & arguments.$controllerName & "/" & local.fileName;

	}
	return LCase(local.rv);
}

/**
 * Internal function.
 */
public string function $includeFile(required any $name, required any $template, required any $type) {
	if (arguments.$type == "partial") {
		if (StructKeyExists(arguments, "query") && IsQuery(arguments.query)) {
			local.query = arguments.query;
			StructDelete(arguments, "query");
			local.rv = "";
			local.iEnd = local.query.recordCount;
			if (Len(arguments.$group)) {

				// We want to group based on a column so loop through the rows until we find, this will break if the query is not ordered by the grouped column.
				local.tempSpacer = "}|{";
				local.groupValue = "";
				local.groupQueryCount = 1;
				arguments.group = QueryNew(local.query.columnList);
				if ($get("showErrorInformation") && !ListFindNoCase(local.query.columnList, arguments.$group)) {
					Throw(
						type="Wheels.GroupColumnNotFound",
						message="CFWheels couldn't find a query column with the name of `#arguments.$group#`.",
						extendedInfo="Make sure your finder method has the column `#arguments.$group#` specified in the `select` argument. If the column does not exist, create it."
					);
				}
				for (local.i = 1; local.i <= local.iEnd; local.i++) {
					if (local.i == 1) {
						local.groupValue = local.query[arguments.$group][local.i];
					} else if (local.groupValue != local.query[arguments.$group][local.i]) {

						// We have a different group for this row so output what we have.
						local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
						if (StructKeyExists(arguments, "$spacer")) {
							local.rv &= local.tempSpacer;
						}
						local.groupValue = local.query[arguments.$group][local.i];
						arguments.group = QueryNew(local.query.columnList);
						local.groupQueryCount = 1;

					}
					QueryAddRow(arguments.group);
					local.jEnd = ListLen(local.query.columnList);
					for (local.j = 1; local.j <= local.jEnd; local.j++) {
						local.property = ListGetAt(local.query.columnList, local.j);
						arguments[local.property] = local.query[local.property][local.i];
						QuerySetCell(arguments.group, local.property, local.query[local.property][local.i], local.groupQueryCount);
					}
					arguments.current = local.i + 1 - arguments.group.recordCount;
					local.groupQueryCount++;
				}

				// If we have anything left at the end we need to render it too.
				if (arguments.group.recordCount) {
					local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
					if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd) {
						local.rv &= local.tempSpacer;
					}
				}

				// Now remove the last temp spacer and replace the tempSpacer with $spacer.
				if (Right(local.rv, 3) == local.tempSpacer) {
					local.rv = Left(local.rv, Len(local.rv) - 3);
				}
				local.rv = Replace(local.rv, local.tempSpacer, arguments.$spacer, "all");

			} else {
				for (local.i = 1; local.i <= local.iEnd; local.i++) {
					arguments.current = local.i;
					arguments.totalCount = local.iEnd;
					local.jEnd = ListLen(local.query.columnList);
					for (local.j = 1; local.j <= local.jEnd; local.j++) {
						local.property = ListGetAt(local.query.columnList, local.j);
						try {
							arguments[local.property] = local.query[local.property][local.i];
						} catch (any e) {
							arguments[local.property] = "";
						}
					}
					local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
					if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd) {
						local.rv &= arguments.$spacer;
					}
				}
			}
		} else if (StructKeyExists(arguments, "object") && IsObject(arguments.object)) {
			local.modelName = arguments.object.$classData().modelName;
			arguments[local.modelName] = arguments.object;
			StructDelete(arguments, "object");
			StructAppend(arguments, arguments[local.modelName].properties(), false);
		} else if (StructKeyExists(arguments, "objects") && IsArray(arguments.objects)) {
			local.array = arguments.objects;
			StructDelete(arguments, "objects");
			local.originalArguments = Duplicate(arguments);
			local.modelName = local.array[1].$classData().modelName;
			local.rv = "";
			local.iEnd = ArrayLen(local.array);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				StructClear(arguments);
				StructAppend(arguments, local.originalArguments);
				arguments.current = local.i;
				arguments.totalCount = local.iEnd;
				arguments[local.modelName] = local.array[local.i];
				local.properties = local.array[local.i].properties();
				StructAppend(arguments, local.properties, true);
				local.rv &= $includeAndReturnOutput(argumentCollection=arguments);
				if (StructKeyExists(arguments, "$spacer") && local.i < local.iEnd) {
					local.rv &= arguments.$spacer;
				}
			}
		}
	}
	if (!StructKeyExists(local, "rv")) {
		local.rv = $includeAndReturnOutput(argumentCollection=arguments);
	}
	return local.rv;
}

/**
 * Internal function.
 */
public boolean function $performedRenderOrRedirect() {
	if ($performedRender() || $performedRedirect())	{
		return true;
	} else {
		return false;
	}
}

/**
 * Internal function.
 */
public boolean function $performedRender() {
	return StructKeyExists(variables.$instance, "response");
}

/**
 * Internal function.
 */
public boolean function $performedRedirect() {
	return StructKeyExists(variables.$instance, "redirect");
}

/**
 * Internal function.
 */
public boolean function $sentEmails() {
	return StructKeyExists(variables.$instance, "emails");
}

/**
 * Internal function.
 */
public boolean function $sentFiles() {
	return StructKeyExists(variables.$instance, "files");
}

/**
 * Internal function.
 */
public boolean function $abortIssued() {
	return StructKeyExists(variables.$instance, "abort");
}

/**
 * Internal function.
 */
public boolean function $reCacheRequired() {
	return StructKeyExists(variables.$instance, "reCache") && variables.$instance.reCache;
}

</cfscript>
