<cffunction name="renderPageToString" returntype="string" access="public" output="false" hint="Controller, Request, Includes the view page for the specified controller and action and returns it as a string.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="See documentation for renderPage (Wheels)">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="See documentation for renderPage (Wheels)">
	<cfargument name="layout" type="any" required="false" default="true" hint="See documentation for renderPage (Wheels)">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for renderPage (Wheels)">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<!---
		EXAMPLES:
		<cfset response = renderPageToString(layout=false)>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPage renderPage()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderText renderText()] (function)
		 * [renderPartial renderPartial()] (function)
	--->
	<cfscript>
		var returnValue = "";
		renderPage(argumentCollection=arguments);
		returnValue = request.wheels.response;
		StructDelete(request.wheels, "response");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$renderPageAndAddToCache" returntype="string" access="public" output="false">
	<cfset $renderPage(argumentCollection=arguments)>
	<cfif NOT IsNumeric(arguments.cache)>
		<cfset arguments.cache = application.settings.defaultCacheTime>
	</cfif>
	<cfset $addToCache(arguments.key, request.wheels.response, arguments.cache, arguments.category)>
	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="$pageIsInCache" returntype="any" access="public" output="false">
	<cfreturn $getFromCache(arguments.key, arguments.category)>
</cffunction>

<cffunction name="renderPage" returntype="void" access="public" output="false" hint="Controller, Request, Renders content to the browser by including the view page for the specified controller and action.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for">
	<cfargument name="layout" type="any" required="false" default="true" hint="The layout to wrap the content in">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<!---
		EXAMPLES:
		<cfset renderPage(action="someOtherAction")>

		<cfset renderPage(layout=false, cache=60)>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderText renderText()] (function)
		 * [renderPartial renderPartial()] (function)
	--->
	<cfscript>
		var loc = {};
		if (application.settings.showDebugInformation)
			$debugPoint("view");
		// if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request
		if ((!IsBoolean(arguments.layout) || arguments.layout) && arguments.$showDebugInformation)
			request.wheels.showDebugInformation = true;
		if (application.settings.cachePages && (IsNumeric(arguments.cache) || (IsBoolean(arguments.cache) && arguments.cache)))
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
			$doubleCheckLock(name=loc.lockName, condition="$pageIsInCache", execute="$renderPageAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
		}
		else
		{
			$renderPage(argumentCollection=arguments);
		}
		if (application.settings.showDebugInformation)
			$debugPoint("view");
	</cfscript>
</cffunction>

<cffunction name="renderNothing" returntype="void" access="public" output="false" hint="Controller, Request, Renders a blank string to the browser.">
	<!---
		EXAMPLES:
		<cfset renderNothing()>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderPage renderPage()] (function)
		 * [renderText renderText()] (function)
		 * [renderPartial renderPartial()] (function)
	--->
	<cfscript>
		request.wheels.response = "";
	</cfscript>
</cffunction>

<cffunction name="renderText" returntype="void" access="public" output="false" hint="Controller, Request, Renders the specified text to the browser.">
	<cfargument name="text" type="any" required="true" hint="The text to be rendered">
	<!---
		EXAMPLES:
		<cfset renderText("Done!")>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderPage renderPage()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderPartial renderPartial()] (function)
	--->
	<cfscript>
		request.wheels.response = arguments.text;
	</cfscript>
</cffunction>

<cffunction name="renderPartial" returntype="void" access="public" output="false" hint="Controller, Request, Renders content to the browser by including a partial.">
	<cfargument name="name" type="string" required="true" hint="Name of partial to include">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$type" type="string" required="false" default="render">
	<!---
		EXAMPLES:
		<cfset renderPartial("comment")>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderPage renderPage()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderText renderText()] (function)
	--->
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="$renderPage" returntype="void" access="public" output="false">
	<cfscript>
		request.wheels.response = $includeAndReturnOutput("#application.wheels.viewPath#/#arguments.controller#/#arguments.action#.cfm");
		$renderLayout(layout=arguments.layout);
	</cfscript>
</cffunction>

<cffunction name="$includeOrRenderPartial" returntype="any" access="public" output="false">
	<cfset var loc = {}>

	<cfset arguments.type = "partial">
	<!--- double-checked lock --->
	<cfif application.settings.cachePartials AND (isNumeric(arguments.cache) OR (IsBoolean(arguments.cache) AND arguments.cache))>
		<cfset loc.category = "partial">
		<cfset loc.key = "#arguments.name##$hashStruct(variables.params)##$hashStruct(arguments)#">
		<cfset loc.lockName = loc.category & loc.key>
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset loc.result = $getFromCache(loc.key, loc.category)>
		</cflock>
		<cfif IsBoolean(loc.result) AND NOT loc.result>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset loc.result = $getFromCache(loc.key, loc.category)>
				<cfif IsBoolean(loc.result) AND NOT loc.result>
					<cfset loc.result = $includeFile(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset $addToCache(loc.key, loc.result, arguments.cache, loc.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset loc.result = $includeFile(argumentCollection=arguments)>
	</cfif>

	<cfif arguments.$type IS "include">
		<cfreturn loc.result>
	<cfelseif arguments.$type IS "render">
		<cfset request.wheels.response = loc.result>
	</cfif>

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
		if (Left(arguments.name, 1) IS "/")
			loc.include = loc.include & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder to views
		else if (arguments.name  Contains "/")
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.folderName & "/" & loc.fileName; // Include a file in a sub folder of the current controller
		else
			loc.include = loc.include & "/" & variables.params.controller & "/" & loc.fileName; // Include a file in the current controller's view folder
		loc.returnValue = $includeAndReturnOutput(loc.include);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$renderLayout" returntype="void" access="public" output="false">
	<cfargument name="layout" type="any" required="true">
	<cfscript>
		var loc = {};
		if (!IsBoolean(arguments.layout) || arguments.layout)
		{
			loc.include = application.wheels.viewPath;
			if (IsBoolean(arguments.layout))
			{
				if (!application.settings.cacheFileChecking || (!ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller) && !ListFindNoCase(application.wheels.nonExistingLayoutFiles, variables.params.controller)))
				{
					if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.params.controller)#/layout.cfm")))
						application.wheels.existingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
					else
						application.wheels.nonExistingLayoutFiles = ListAppend(application.wheels.existingLayoutFiles, variables.params.controller);
				}
				if (ListFindNoCase(application.wheels.existingLayoutFiles, variables.params.controller))
					loc.include = loc.include & "/" & variables.params.controller & "/" & "layout.cfm";
				else
					loc.include = loc.include & "/" & "layout.cfm";
				loc.response = $includeAndReturnOutput(loc.include);
			}
			else
			{
				loc.response = $includeFile(name=arguments.layout, type="layout");
			}
			request.wheels.response = loc.response;
		}
	</cfscript>
</cffunction>

<cffunction name="$renderPlugin" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		request.wheels.showDebugInformation = false;
		request.wheels.response = $includeAndReturnOutput("#application.wheels.pluginPath#/#arguments.name#/index.cfm");
		request.wheels.response = $includeAndReturnOutput("wheels/styles/layout.cfm");
	</cfscript>
</cffunction>