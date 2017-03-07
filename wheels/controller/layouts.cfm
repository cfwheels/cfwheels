<cfscript>

/**
 * Used within a controller's init() function to specify controller- or action-specific layouts.
 *
 * @doc.section Controller
 * @doc.category Initialization Functions
 *
 */
public void function usesLayout(
	required string template,
	string ajax="",
	string except,
	string only,
	boolean useDefault=true
) {
	if ((StructKeyExists(this, arguments.template) && IsCustomFunction(this[arguments.template])) || IsCustomFunction(arguments.template)) {
		// when the layout is a function, the function itself should handle all the logic
		StructDelete(arguments, "except");
		StructDelete(arguments, "only");
	}
	if (StructKeyExists(arguments, "except")) {
		arguments.except = $listClean(arguments.except);
	}
	if (StructKeyExists(arguments, "only")) {
		arguments.only = $listClean(arguments.only);
	}
	variables.$class.layout = arguments;
}

/**
 * Internal function.
 */
public any function $useLayout(required string $action) {
	local.rv = true;
	local.layoutType = "template";
	if (isAjax() && StructKeyExists(variables.$class.layout, "ajax") && Len(variables.$class.layout.ajax)) {
		local.layoutType = "ajax";
	}
	if (!StructIsEmpty(variables.$class.layout)) {
		local.rv = variables.$class.layout.useDefault;
		if ((StructKeyExists(this, variables.$class.layout[local.layoutType]) && IsCustomFunction(this[variables.$class.layout[local.layoutType]])) || IsCustomFunction(variables.$class.layout[local.layoutType])) {
			// if the developer doesn't return anything from the function or if they return a blank string it should use the default layout still
			local.invokeArgs = {};
			local.invokeArgs.action = arguments.$action;
			local.result = $invoke(method=variables.$class.layout[local.layoutType], invokeArgs=local.invokeArgs);
			if (StructKeyExists(local, "result")) {
				local.rv = local.result;
			}
		} else if ((!StructKeyExists(variables.$class.layout, "except") || !ListFindNoCase(variables.$class.layout.except, arguments.$action)) && (!StructKeyExists(variables.$class.layout, "only") || ListFindNoCase(variables.$class.layout.only, arguments.$action))) {
			local.rv = variables.$class.layout[local.layoutType];
		}
	}
	return local.rv;
}

/**
 * Internal function.
 */
public string function $renderLayout(required string $content, required $layout) {
	if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout))) {
		// store the content in a variable in the request scope so it can be accessed by the includeContent function that the developer uses in layout files
		// this is done so we avoid passing data to/from it since it would complicate things for the developer
		contentFor(body=arguments.$content, overwrite=true);
		local.viewPath = get("viewPath");
		local.include = local.viewPath;
		if (IsBoolean(arguments.$layout)) {
			local.layoutFileExists = false;
			if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller)) {
				local.file = local.viewPath & "/" & LCase(variables.params.controller) & "/layout.cfm";
				if (FileExists(ExpandPath(local.file))) {
					local.layoutFileExists = true;
				}
				if (get("cacheFileChecking")) {
					if (local.layoutFileExists) {
						application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
					} else {
						application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
					}
				}
			}
			if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) || local.layoutFileExists) {
				local.include &= "/" & variables.params.controller & "/" & "layout.cfm";
			} else {
				local.include &= "/" & "layout.cfm";
			}
			local.rv = $includeAndReturnOutput($template=local.include);
		} else {
			arguments.$name = arguments.$layout;
			arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
			local.rv = $includeFile(argumentCollection=arguments);
		}
	} else {
		local.rv = arguments.$content;
	}
	return local.rv;
}

</cfscript>
