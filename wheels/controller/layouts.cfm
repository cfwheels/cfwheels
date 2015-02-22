<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="usesLayout" access="public" returntype="void" output="false" hint="Used within a controller's `init()` function to specify controller- or action-specific layouts."
	examples=
	'
		<!--- Example 1: We want this layout to be used as the default throughout the entire controller, except for the myajax action --->
		<cffunction name="init">
			<cfscript>
				usesLayout(template="myLayout", except="myajax");
			</cfscript>
		</cffunction>

		<!--- Example 2: Use a custom layout for these actions but use the default layout.cfm for the rest --->
		<cffunction name="init">
			<cfscript>
				usesLayout(template="myLayout", only="termsOfService,shippingPolicy");
			</cfscript>
		</cffunction>

		<!--- Example 3: Define a custom function to decide which layout to display --->
		<cffunction name="init">
			<cfscript>
				usesLayout("setLayout");
			</cfscript>
		</cffunction>

		<cffunction name="setLayout">
			<cfscript>
				if (Month(Now()) == 12)
				{
					// Use holiday theme for the month of December
					return "holiday";
				}
				else
				{
					// Otherwise, use default layout by returning `true`
					return true;
				}
			</cfscript>
		</cffunction>
	'
	categories="controller-initialization,rendering" chapters="rendering-layout" functions="renderPage">
	<cfargument name="template" required="true" type="string" hint="Name of the layout template or function name you want to use.">
	<cfargument name="ajax" required="false" type="string" default="" hint="Name of the layout template you want to use for AJAX requests.">
	<cfargument name="except" type="string" required="false" hint="List of actions that should not get the layout.">
	<cfargument name="only" type="string" required="false" hint="List of actions that should only get the layout.">
	<cfargument name="useDefault" type="boolean" required="false" default="true" hint="When specifying conditions or a function, pass `true` to use the default `layout.cfm` if none of the conditions are met.">
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
				loc.temp = $invoke(method=variables.$class.layout[loc.layoutType], invokeArgs=loc.invokeArgs);
				if (StructKeyExists(loc, "temp"))
				{
					loc.rv = loc.temp;
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
			loc.include = application.wheels.viewPath;
			if (IsBoolean(arguments.$layout))
			{
				loc.layoutFileExists = false;
				if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
				{
					if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))
					{
						loc.layoutFileExists = true;
					}
					if (application.wheels.cacheFileChecking)
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