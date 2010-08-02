<cffunction name="usesLayout" access="public" returntype="void" output="false" hint="Used to specify a controller or action specific layout"
	examples=
	'
		<cffunction name="init">
			<!---
			We want this layout to be used as the default throughout the entire controller
			except for the index action
			 --->
			<cfset usesLayout("myLayout", except="myajax")>
		</cffunction>
		
		<cffunction name="index">
		</cffunction>
		
		<cffunction name="show">
		</cffunction>
		
		<cffunction name="create">
		</cffunction>		
		
		<cffunction name="edit">
		</cffunction>
		
		<cffunction name="myajax">
			<!---
			since this action is within the exception rule of the 
			default layout, it will not get a layout
			 --->
		</cffunction>
	'
	categories="controller-request,rendering" chapters="rendering-layout">
	<cfargument name="template" required="true" type="string" hint="the name of the layout template or method name you want to use">
	<cfargument name="except" type="string" required="false" hint="a list of actions that SHOULD NOT get the layout">
	<cfargument name="only" type="string" required="false" hint="a list of action that SHOULD ONLY get the layout">
	<cfargument name="useDefault" type="boolean" required="false" default="true" hint="when specifying conditions or a method, should we use the default layout if not satisfied">
	<cfscript>
		// when the layout is a method, the method itself should handle all the logic
		if ((StructKeyExists(this, arguments.template) && IsCustomFunction(this[arguments.template])) || IsCustomFunction(arguments.template))
		{
			StructDelete(arguments, "except", false);
			StructDelete(arguments, "only", false);
		}
		if (StructKeyExists(arguments, "except"))
			arguments.except = $listClean(arguments.except);
		if (StructKeyExists(arguments, "only"))
			arguments.only = $listClean(arguments.only);
		variables.$class.layout = arguments;
	</cfscript>
</cffunction>

<cffunction name="$useLayout" access="public" returntype="any" output="false">
	<cfargument name="$action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		if (!StructIsEmpty(variables.$class.layout))
		{
			loc.returnValue = variables.$class.layout.useDefault;
			if ((StructKeyExists(this, variables.$class.layout.template) && IsCustomFunction(this[variables.$class.layout.template])) || IsCustomFunction(variables.$class.layout.template))
			{
				// if the developer doesn't return anything from the method or if they return a blank string it should use the default layout still
				loc.temp = $invoke(method=variables.$class.layout.template, action=arguments.$action);
				if (StructKeyExists(loc, "temp"))
					loc.returnValue = loc.temp;
			}
			else if ((!StructKeyExists(variables.$class.layout, "except") || !ListFindNoCase(variables.$class.layout.except, arguments.$action)) && (!StructKeyExists(variables.$class.layout, "only") || ListFindNoCase(variables.$class.layout.only, arguments.$action)))
			{
				loc.returnValue = variables.$class.layout.template;
			}
		}
		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="$renderLayout" returntype="string" access="public" output="false">
	<cfargument name="$content" type="string" required="true">
	<cfargument name="$layout" type="any" required="true">
	<cfargument name="$overwrite" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		if ((IsBoolean(arguments.$layout) && arguments.$layout) || (!IsBoolean(arguments.$layout) && Len(arguments.$layout)))
		{
			// store the content in a variable in the request scope so it can be accessed
			// by the includeContent function that the developer uses in layout files
			// this is done so we avoid passing data to/from it since it would complicate things for the developer
			contentFor(body=arguments.$content, overwrite=arguments.$overwrite);
			loc.include = application.wheels.viewPath;
			if (IsBoolean(arguments.$layout))
			{
				loc.layoutFileExists = false;
				if (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller))
				{
					if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))
						loc.layoutFileExists = true;
					if (application.wheels.cacheFileChecking)
					{
						if (loc.layoutFileExists)
							application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
						else
							application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.nonExistingLayoutFiles, variables.params.controller);
					}
				}
				if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) || loc.layoutFileExists)
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
				arguments.$name = arguments.$layout;
				arguments.$template = $generateIncludeTemplatePath(argumentCollection=arguments);
				loc.returnValue = $includeFile(argumentCollection=arguments);
			}
		}
		else
		{
			loc.returnValue = arguments.$content;
		}
		return loc.returnValue;
	</cfscript>
</cffunction>