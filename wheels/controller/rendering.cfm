<cffunction name="renderPageToString" returntype="string" access="public" output="false" hint="Controller, Request, Includes the view page for the specified controller and action and returns it as a string.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Pass-through argument; see documentation for renderPage">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Pass-through argument; see documentation for renderPage">
	<cfargument name="layout" type="any" required="false" default="true" hint="Pass-through argument; see documentation for renderPage">
	<cfargument name="cache" type="any" required="false" default="" hint="Pass-through argument; see documentation for renderPage">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<cfset var loc = {}>

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfset response = renderPageToString(layout=false)>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPage renderPage()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderText renderText()] (function)
		 * [renderPartial renderPartial()] (function)
	--->

	<cfset renderPage(argumentCollection=arguments)>
	<cfset loc.result = request.wheels.response>
	<cfset request.wheels.response = "">

	<cfreturn loc.result>
</cffunction>

<cffunction name="renderPage" returntype="void" access="public" output="false" hint="Controller, Request, Renders content to the browser by including the view page for the specified controller and action.">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="Controller to include the view page for">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="Action to include the view page for">
	<cfargument name="layout" type="any" required="false" default="true" hint="The layout to wrap the content in">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<cfset var loc = {}>

	<!---
		HISTORY:
		-

		USAGE:
		This form of rendering (including a view file based on the controller and action) is the most commonly used and is the one used by Wheels as the default when nothing is explicitly rendered.

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

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.view = GetTickCount()>
	</cfif>

	<!--- if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request --->
	<cfif (NOT IsBoolean(arguments.layout) OR arguments.layout) AND arguments.$showDebugInformation>
		<cfset request.wheels.showDebugInformation = true>
	</cfif>

	<!--- double-checked lock --->
	<cfif application.settings.cachePages AND (IsNumeric(arguments.cache) OR (IsBoolean(arguments.cache) AND arguments.cache))>
		<cfset loc.category = "action">
		<cfset loc.key = "#arguments.action##$hashStruct(variables.params)##$hashStruct(arguments)#">
		<cfset loc.lockName = loc.category & loc.key>
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
		</cflock>
		<cfif IsBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
				<cfif IsBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset $renderPage(argumentCollection=arguments)>
					<cfif NOT IsNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset $addToCache(loc.key, request.wheels.response, arguments.cache, loc.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset $renderPage(argumentCollection=arguments)>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.view = GetTickCount() - request.wheels.execution.components.view>
	</cfif>

</cffunction>

<cffunction name="renderNothing" returntype="void" access="public" output="false" hint="Controller, Request, Renders a blank string to the browser.">

	<!---
		HISTORY:
		-

		USAGE:
		This is very similar to just doing a <cfabort> with the advantage that any after filters you have set on the action will still be run.

		EXAMPLES:
		<cfset renderNothing()>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderPage renderPage()] (function)
		 * [renderText renderText()] (function)
		 * [renderPartial renderPartial()] (function)
	--->

	<cfset request.wheels.response = "">
</cffunction>

<cffunction name="renderText" returntype="void" access="public" output="false" hint="Controller, Request, Renders the specified text to the browser.">
	<cfargument name="text" type="any" required="true" hint="The text to be rendered">

	<!---
		HISTORY:
		-

		USAGE:
		-

		EXAMPLES:
		<cfset renderText("Done!")>

		RELATED:
		 * RenderingPages (chapter)
		 * [renderPageToString renderPageToString()] (function)
		 * [renderPage renderPage()] (function)
		 * [renderNothing renderNothing()] (function)
		 * [renderPartial renderPartial()] (function)
	--->

	<cfset request.wheels.response = arguments.text>
</cffunction>

<cffunction name="renderPartial" returntype="void" access="public" output="false" hint="Controller, Request, Renders content to the browser by including a partial.">
	<cfargument name="name" type="string" required="true" hint="Name of partial to include">
	<cfargument name="cache" type="any" required="false" default="" hint="Minutes to cache the content for">
	<cfargument name="$type" type="string" required="false" default="render">

	<!---
		HISTORY:
		-

		USAGE:
		-

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
	<cfset request.wheels.response = $include("../../#application.wheels.viewPath#/#arguments.controller#/#arguments.action#.cfm")>
	<cfset $renderLayout(layout=arguments.layout)>
</cffunction>

<cffunction name="$includeOrRenderPartial" returntype="any" access="public" output="false">
	<cfset var loc = {}>

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
					<cfset loc.result = $includePartial(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset $addToCache(loc.key, loc.result, arguments.cache, loc.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset loc.result = $includePartial(argumentCollection=arguments)>
	</cfif>

	<cfif arguments.$type IS "include">
		<cfreturn loc.result>
	<cfelseif arguments.$type IS "render">
		<cfset request.wheels.response = loc.result>
	</cfif>

</cffunction>

<cffunction name="$includePartial" returntype="string" access="public" output="false">
	<cfset var loc = {}>

	<cfif Left(arguments.name, 1) IS "/">
		<!--- Include a file in a sub folder to view --->
		<cfset loc.result = $include("../../#application.wheels.viewPath##Reverse(ListRest(Reverse(arguments.name), '/'))#/_#Reverse(ListFirst(Reverse(arguments.name), '/'))#.cfm")>
	<cfelseif arguments.name  Contains "/">
		<!--- Include a file in a sub folder of the curent controller --->
		<cfset loc.result = $include("../../#application.wheels.viewPath#/#variables.params.controller#/#Reverse(ListRest(Reverse(arguments.name), '/'))#/_#Reverse(listFirst(Reverse(arguments.name), '/'))#.cfm")>
	<cfelse>
		<!--- Include a file in the current controller's view folder --->
		<cfset loc.result = $include("../../#application.wheels.viewPath#/#variables.params.controller#/_#arguments.name#.cfm")>
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="$include" returntype="string" access="public" output="false">
	<cfargument name="$path" type="string" required="true">
	<cfset var loc = {}>
	<cfsavecontent variable="loc.result">
		<cfinclude template="#LCase(arguments.$path)#">
	</cfsavecontent>
	<cfreturn trim(loc.result)>
</cffunction>

<cffunction name="$renderLayout" returntype="void" access="public" output="false">
	<cfargument name="layout" type="any" required="true">

	<cfif (IsBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT IsBoolean(arguments.layout)>
			<!--- Include a designated layout --->
			<cfset request.wheels.response = $include("../../#application.wheels.viewPath#/layouts/#Replace(arguments.layout, ' ', '', 'all')#.cfm")>
		<cfelseif fileExists(expandPath("views/layouts/#variables.params.controller#.cfm"))>
			<!--- Include the current controller's layout if one exists --->
			<cfset request.wheels.response = $include("../../#application.wheels.viewPath#/layouts/#variables.params.controller#.cfm")>
		<cfelse>
			<!--- The application wide layout --->
			<cfset request.wheels.response = $include("../../#application.wheels.viewPath#/layouts/default.cfm")>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="$renderPlugin" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset request.wheels.showDebugInformation = false>
	<cfset request.wheels.response = $include("../../#application.wheels.pluginPath#/#arguments.name#/index.cfm")>
	<cfset $renderLayout(layout=false)>
</cffunction>