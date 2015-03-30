<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="usesLayout" access="public" returntype="void" output="false">
	<cfargument name="template" required="true" type="string">
	<cfargument name="ajax" required="false" type="string" default="">
	<cfargument name="except" type="string" required="false">
	<cfargument name="only" type="string" required="false">
	<cfargument name="useDefault" type="boolean" required="false" default="true">
	<cfscript>
		if ((StructKeyExists(this, arguments.template) && IsCustomFunction(this[arguments.template])) || IsCustomFunction(arguments.template))
		{
			// when the layout is a function, the function itself should handle all the logic
			StructDelete(arguments, "except");
			StructDelete(arguments, "only");
		}
		if (StructKeyExists(arguments, "except"))
		{
			arguments.except = $listClean(arguments.except);
		}
		if (StructKeyExists(arguments, "only"))
		{
			arguments.only = $listClean(arguments.only);
		}
		variables.$class.layout = arguments;
	</cfscript>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$useLayout" access="public" returntype="any" output="false">
	<cfargument name="$action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = true;
		loc.layoutType = "template";
		if (isAjax() && StructKeyExists(variables.$class.layout, "ajax") && Len(variables.$class.layout.ajax))
		{
			loc.layoutType = "ajax";
		}
		if (!StructIsEmpty(variables.$class.layout))
		{
			loc.rv = variables.$class.layout.useDefault;
			if ((StructKeyExists(this, variables.$class.layout[loc.layoutType]) && IsCustomFunction(this[variables.$class.layout[loc.layoutType]])) || IsCustomFunction(variables.$class.layout[loc.layoutType]))
			{
				// if the developer doesn't return anything from the function or if they return a blank string it should use the default layout still
				loc.invokeArgs = {};
				loc.invokeArgs.action = arguments.$action;
				loc.result = $invoke(method=variables.$class.layout[loc.layoutType], invokeArgs=loc.invokeArgs);
				if (StructKeyExists(loc, "result"))
				{
					loc.rv = loc.result;
				}
			}
			else if ((!StructKeyExists(variables.$class.layout, "except") || !ListFindNoCase(variables.$class.layout.except, arguments.$action)) && (!StructKeyExists(variables.$class.layout, "only") || ListFindNoCase(variables.$class.layout.only, arguments.$action)))
			{
				loc.rv = variables.$class.layout[loc.layoutType];
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$renderLayout" returntype="string" access="public" output="false">
	<cfargument name="$content" type="string" required="true">
	<cfargument name="$layout" type="any" required="true">
	<cfscript>
		var loc = {};
		if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout)))
		{
			// store the content in a variable in the request scope so it can be accessed by the includeContent function that the developer uses in layout files
			// this is done so we avoid passing data to/from it since it would complicate things for the developer
			contentFor(body=arguments.$content, overwrite=true);
			loc.viewPath = get("viewPath");
			loc.include = loc.viewPath;
			if (IsBoolean(arguments.$layout))
			{
				loc.layoutFileExists = false;
				if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
				{
					loc.file = loc.viewPath & "/" & LCase(variables.params.controller) & "/layout.cfm";
					if (FileExists(ExpandPath(loc.file)))
					{
						loc.layoutFileExists = true;
					}
					if (get("cacheFileChecking"))
					{
						if (loc.layoutFileExists)
						{
							application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
						}
						else
						{
							application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
						}
					}
				}
				if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) || loc.layoutFileExists)
				{
					loc.include &= "/" & variables.params.controller & "/" & "layout.cfm";
				}
				else
				{
					loc.include &= "/" & "layout.cfm";
				}
				loc.rv = $includeAndReturnOutput($template=loc.include);
			}
			else
			{
				arguments.$name = arguments.$layout;
				arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
				loc.rv = $includeFile(argumentCollection=arguments);
			}
		}
		else
		{
			loc.rv = arguments.$content;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>