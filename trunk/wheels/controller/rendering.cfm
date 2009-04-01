<cffunction name="renderPageToString" returntype="string" access="public" output="false" hint="Includes the view page for the specified controller and action and returns it as a string.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="See documentation for renderPage">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="See documentation for renderPage">
	<cfargument name="layout" type="any" required="false" default="#application.wheels.renderPageToString.layout#" hint="See documentation for renderPage">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for renderPage">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.wheels.showDebugInformation#">
	<cfscript>
		var returnValue = "";
		renderPage(argumentCollection=arguments);
		returnValue = request.wheels.response;
		StructDelete(request.wheels, "response");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="renderPage" returntype="void" access="public" output="false" hint="Renders content to the browser by including the view page for the specified controller and action.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for">
	<cfargument name="layout" type="any" required="false" default="#application.wheels.renderPage.layout#" hint="The layout to wrap the content in">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.wheels.showDebugInformation#">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
			$debugPoint("view");
		// if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request
		if ((!IsBoolean(arguments.layout) || arguments.layout) && arguments.$showDebugInformation)
			request.wheels.showDebugInformation = true;
		if (application.wheels.cachePages && (IsNumeric(arguments.cache) || (IsBoolean(arguments.cache) && arguments.cache)))
		{
			loc.category = "action";
			loc.key = "#arguments.action##$hashStruct(variables.params)##$hashStruct(arguments)#";
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
		if (application.wheels.showDebugInformation)
			$debugPoint("view");
		
		// we put the response in the request scope here so that the developer does not have to specifically return anything from the controller code
		request.wheels.response = loc.page;
	</cfscript>
</cffunction>

<cffunction name="renderNothing" returntype="void" access="public" output="false" hint="Renders a blank string to the browser. This is very similar to calling 'cfabort' with the advantage that any after filters you have set on the action will still be run.">
	<cfscript>
		request.wheels.response = "";
	</cfscript>
</cffunction>

<cffunction name="renderText" returntype="void" access="public" output="false" hint="Renders the specified text to the browser.">
	<cfargument name="text" type="any" required="true" hint="The text to be rendered">
	<cfscript>
		request.wheels.response = arguments.text;
	</cfscript>
</cffunction>

<cffunction name="renderPartial" returntype="void" access="public" output="false" hint="Renders content to the browser by including a partial.">
	<cfargument name="name" type="string" required="true" hint="Name of partial to include">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$type" type="string" required="false" default="render">
	<cfscript>
		$includeOrRenderPartial(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="$renderPageAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $renderPage(argumentCollection=arguments);
		if (!IsNumeric(arguments.cache))
			arguments.cache = application.wheels.defaultCacheTime;
		$addToCache(key=arguments.key, value=returnValue, time=arguments.cache, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$renderPage" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.content = $includeAndReturnOutput("#application.wheels.viewPath#/#arguments.controller#/#arguments.action#.cfm");
		loc.returnValue = $renderLayout(content=loc.content, layout=arguments.layout);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderPartialAndAddToCache" returntype="string" access="public" output="false">
	<cfscript>
		var returnValue = "";
		returnValue = $includeFile(argumentCollection=arguments);
		if (!IsNumeric(arguments.cache))
			arguments.cache = application.wheels.defaultCacheTime;
		$addToCache(key=arguments.key, value=returnValue, time=arguments.cache, category=arguments.category);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$includeOrRenderPartial" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		arguments.type = "partial";
		if (application.wheels.cachePartials && (isNumeric(arguments.cache) || (IsBoolean(arguments.cache) && arguments.cache)))
		{
			loc.category = "partial";
			loc.key = "#arguments.name##$hashStruct(variables.params)##$hashStruct(arguments)#";
			loc.lockName = loc.category & loc.key;
			loc.conditionArgs = {};
			loc.conditionArgs.category = loc.category;
			loc.conditionArgs.key = loc.key;
			loc.executeArgs = arguments;
			loc.executeArgs.category = loc.category;
			loc.executeArgs.key = loc.key;
			loc.partial = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$renderPartialAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			loc.partial = $includeFile(argumentCollection=arguments);
		}
		if (arguments.$type == "include")
			loc.returnValue = loc.partial;
		else if (arguments.$type == "render")
			request.wheels.response = loc.partial;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$includeFile" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.include = application.wheels.viewPath;
		loc.fileName = Spanexcluding(Reverse(ListFirst(Reverse(arguments.name), "/")), ".") & ".cfm"; // extracts the file part of the path and replace ending ".cfm"
		if (type == "partial")
			loc.fileName = Replace("_" & loc.fileName, "__", "_", "one"); // replaces leading "_" when the file is a partial
		loc.folderName = Reverse(ListRest(Reverse(arguments.name), "/"));
		if (Left(arguments.name, 1) == "/")
			loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
		else if (arguments.name  Contains "/")
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
		else
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.fileName; // Include a file in the current controller's view folder
		loc.returnValue = $includeAndReturnOutput(loc.include);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderLayout" returntype="string" access="public" output="false">
	<cfargument name="content" type="string" required="true">
	<cfargument name="layout" type="any" required="true">
	<cfscript>
		var loc = {};
		if (!IsBoolean(arguments.layout) || arguments.layout)
		{
			request.wheels.contentForLayout = arguments.content; // store the content in a variable in the request scope so it can be accessed by the contentForLayout function that the developer uses in layout files (this is done so we avoid passing data to/from it since it would complicate things for the developer)
			loc.include = application.wheels.viewPath;
			if (IsBoolean(arguments.layout))
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
				loc.returnValue = $includeAndReturnOutput(loc.include);
			}
			else
			{
				loc.returnValue = $includeFile(name=arguments.layout, type="layout");
			}
		}
		else
		{
			loc.returnValue = arguments.content;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderPlugin" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		request.wheels.showDebugInformation = false;
		request.wheels.contentForLayout = $includeAndReturnOutput("#application.wheels.pluginPath#/#arguments.name#/index.cfm");
		request.wheels.response = $includeAndReturnOutput("wheels/styles/layout.cfm");
	</cfscript>
</cffunction>