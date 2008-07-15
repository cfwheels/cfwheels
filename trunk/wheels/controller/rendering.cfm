<cffunction name="renderPageToString" returntype="string" access="public" output="false">
	<cfset var loc = {}>

	<cfset renderPage(argumentCollection=arguments)>
	<cfset loc.result = request.wheels.response>
	<cfset request.wheels.response = "">

	<cfreturn loc.result>
</cffunction>

<cffunction name="renderPage" returntype="void" access="public" output="false">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#">
	<cfargument name="layout" type="any" required="false" default="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="$showDebugInformation" type="any" required="false" default="#application.settings.showDebugInformation#">
	<cfset var loc = {}>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.view = getTickCount()>
	</cfif>

	<!--- if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request --->
	<cfif (NOT isBoolean(arguments.layout) OR arguments.layout) AND arguments.$showDebugInformation>
		<cfset request.wheels.showDebugInformation = true>
	</cfif>

	<!--- double-checked lock --->
	<cfif application.settings.cachePages AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset loc.category = "action">
		<cfset loc.key = "#arguments.action##$hashStruct(variables.params)##$hashStruct(arguments)#">
		<cfset loc.lockName = loc.category & loc.key>
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
		</cflock>
		<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
				<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset $renderPage(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
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
		<cfset request.wheels.execution.components.view = getTickCount() - request.wheels.execution.components.view>
	</cfif>

</cffunction>

<cffunction name="renderNothing" returntype="void" access="public" output="false">

	<cfset request.wheels.response = "">
</cffunction>

<cffunction name="renderText" returntype="void" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset request.wheels.response = arguments.text>
</cffunction>

<cffunction name="$renderPage" returntype="void" access="private" output="false">
	<cfset request.wheels.response = $include("../../views/#arguments.controller#/#arguments.action#.cfm")>
	<cfset $renderLayout(layout=arguments.layout)>
</cffunction>

<cffunction name="renderPartial" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="$type" type="string" required="false" default="render">
	<cfreturn $includeOrRenderPartial(argumentCollection=arguments)>
</cffunction>

<cffunction name="$includeOrRenderPartial" returntype="void" access="private" output="false">
	<cfset var loc = {}>

	<!--- double-checked lock --->
	<cfif application.settings.cachePartials AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset loc.category = "partial">
		<cfset loc.key = "#arguments.name##$hashStruct(variables.params)##$hashStruct(arguments)#">
		<cfset loc.lockName = loc.category & loc.key>
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset loc.result = $getFromCache(loc.key, loc.category)>
		</cflock>
		<cfif isBoolean(loc.result) AND NOT loc.result>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset loc.result = $getFromCache(loc.key, loc.category)>
				<cfif isBoolean(loc.result) AND NOT loc.result>
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

<cffunction name="$includePartial" returntype="string" access="private" output="false">
	<cfset var loc = {}>

	<cfif Left(arguments.name, 1) IS "/">
		<!--- Include a file in a sub folder to view --->
		<cfset loc.result = $include("../../views#Reverse(ListRest(Reverse(arguments.name), '/'))#/_#Reverse(ListFirst(Reverse(arguments.name), '/'))#.cfm")>
	<cfelseif arguments.name  Contains "/">
		<!--- Include a file in a sub folder of the curent controller --->
		<cfset loc.result = $include("../../views/#variables.params.controller#/#Reverse(ListRest(Reverse(arguments.name), '/'))#/_#Reverse(listFirst(Reverse(arguments.name), '/'))#.cfm")>
	<cfelse>
		<!--- Include a file in the current controller's view folder --->
		<cfset loc.result = $include("../../views/#variables.params.controller#/_#arguments.name#.cfm")>
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="$include" returntype="string" access="private" output="false">
	<cfargument name="$path" type="string" required="true">
	<cfset var loc = {}>
	<cfsavecontent variable="loc.result">
		<cfinclude template="#arguments.$path#">
	</cfsavecontent>
	<cfreturn trim(loc.result)>
</cffunction>

<cffunction name="$renderLayout" returntype="void" access="private" output="false">
	<cfargument name="layout" type="any" required="true">

	<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT isBoolean(arguments.layout)>
			<!--- Include a designated layout --->
			<cfset request.wheels.response = $include("../../views/layouts/#replace(arguments.layout, ' ', '', 'all')#.cfm")>
		<cfelseif fileExists(expandPath("views/layouts/#variables.params.controller#.cfm"))>
			<!--- Include the current controller's layout if one exists --->
			<cfset request.wheels.response = $include("../../views/layouts/#variables.params.controller#.cfm")>
		<cfelse>
			<!--- The application wide layout --->
			<cfset request.wheels.response = $include("../../views/layouts/default.cfm")>
		</cfif>
	</cfif>

</cffunction>