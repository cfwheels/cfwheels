<cffunction name="renderPageToString" returntype="any" access="public" output="false">
	<cfset var locals = structNew()>

	<cfset renderPage(argumentCollection=arguments)>
	<cfset locals.result = request.wheels.response>
	<cfset request.wheels.response = "">

	<cfreturn locals.result>
</cffunction>

<cffunction name="renderPage" returntype="any" access="public" output="false">
	<cfargument name="controller" type="any" required="false" default="#variables.params.controller#">
	<cfargument name="action" type="any" required="false" default="#variables.params.action#">
	<cfargument name="layout" type="any" required="false" default="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="_showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<cfset var locals = structNew()>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.view = getTickCount()>
	</cfif>

	<!--- if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request --->
	<cfif (NOT isBoolean(arguments.layout) OR arguments.layout) AND arguments._showDebugInformation>
		<cfset request.wheels.showDebugInformation = true>
	</cfif>

	<!--- double-checked lock --->
	<cfif application.settings.cachePages AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset locals.category = "action">
		<cfset locals.key = "#arguments.action#_#$hashStruct(variables.params)#_#$hashStruct(arguments)#">
		<cfset locals.lockName = locals.category & locals.key>
		<cflock name="#locals.lockName#" type="readonly" timeout="30">
			<cfset request.wheels.response = $getFromCache(locals.key, locals.category)>
		</cflock>
		<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
				<cfset request.wheels.response = $getFromCache(locals.key, locals.category)>
				<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset _renderPage(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset $addToCache(locals.key, request.wheels.response, arguments.cache, locals.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset _renderPage(argumentCollection=arguments)>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.view = getTickCount() - request.wheels.execution.components.view>
	</cfif>

</cffunction>

<cffunction name="renderNothing" returntype="any" access="public" output="false">

	<cfset request.wheels.response = "">
</cffunction>

<cffunction name="renderText" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset request.wheels.response = arguments.text>
</cffunction>

<cffunction name="_renderPage" returntype="any" access="private" output="false">
	<cfset request.wheels.response = _include("../../views/#arguments.controller#/#arguments.action#.cfm")>
	<cfset _renderLayout(layout=arguments.layout)>
</cffunction>

<cffunction name="renderPartial" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="_type" type="any" required="false" default="render">
	<cfreturn _includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="_includeOrRenderPartial" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>

	<!--- double-checked lock --->
	<cfif application.settings.cachePartials AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset locals.category = "partial">
		<cfset locals.key = "#arguments.name#_#$hashStruct(variables.params)#_#$hashStruct(arguments)#">
		<cfset locals.lockName = locals.category & locals.key>
		<cflock name="#locals.lockName#" type="readonly" timeout="30">
			<cfset locals.result = $getFromCache(locals.key, locals.category)>
		</cflock>
		<cfif isBoolean(locals.result) AND NOT locals.result>
	   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
				<cfset locals.result = $getFromCache(locals.key, locals.category)>
				<cfif isBoolean(locals.result) AND NOT locals.result>
					<cfset locals.result = _includePartial(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset $addToCache(locals.key, locals.result, arguments.cache, locals.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset locals.result = _includePartial(argumentCollection=arguments)>
	</cfif>

	<cfif arguments._type IS "include">
		<cfreturn locals.result>
	<cfelseif arguments._type IS "render">
		<cfset request.wheels.response = locals.result>
	</cfif>

</cffunction>

<cffunction name="_includePartial" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>

	<cfif left(arguments.name, 1) IS "/">
		<!--- Include a file in a sub folder to view --->
		<cfset locals.result = _include("../../views#reverse(listRest(reverse(arguments.name), '/'))#/_#reverse(listFirst(reverse(arguments.name), '/'))#.cfm")>
	<cfelseif arguments.name  Contains "/">
		<!--- Include a file in a sub folder of the curent controller --->
		<cfset locals.result = _include("../../views/#variables.params.controller#/#reverse(listRest(reverse(arguments.name), '/'))#/_#reverse(listFirst(reverse(arguments.name), '/'))#.cfm")>
	<cfelse>
		<!--- Include a file in the current controller's view folder --->
		<cfset locals.result = _include("../../views/#variables.params.controller#/_#arguments.name#.cfm")>
	</cfif>

	<cfreturn locals.result>
</cffunction>

<cffunction name="_include" returntype="any" access="private" output="false">
	<cfargument name="_path" type="any" required="true">
	<cfset var locals = structNew()>
	<cfsavecontent variable="locals.result">
		<cfinclude template="#arguments._path#">
	</cfsavecontent>
	<cfreturn trim(locals.result)>
</cffunction>

<cffunction name="_renderLayout" returntype="any" access="private" output="false">
	<cfargument name="layout" type="any" required="true">

	<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT isBoolean(arguments.layout)>
			<!--- Include a designated layout --->
			<cfset request.wheels.response = _include("../../views/layouts/#replace(arguments.layout, ' ', '_', 'all')#.cfm")>
		<cfelseif fileExists(expandPath("views/layouts/#variables.params.controller#.cfm"))>
			<!--- Include the current controller's layout if one exists --->
			<cfset request.wheels.response = _include("../../views/layouts/#variables.params.controller#.cfm")>
		<cfelse>
			<!--- The application wide layout --->
			<cfset request.wheels.response = _include("../../views/layouts/default.cfm")>
		</cfif>
	</cfif>

</cffunction>