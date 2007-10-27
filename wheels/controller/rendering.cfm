<cffunction name="renderPageToString" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfset renderPage(argumentCollection=arguments)>
	<cfset local.result = request.wheels.response>
	<cfset request.wheels.response = "">

	<cfreturn local.result>
</cffunction>


<cffunction name="renderPage" returntype="any" access="public" output="false">
	<cfargument name="controller" type="any" required="false" default="#variables.params.controller#">
	<cfargument name="action" type="any" required="false" default="#variables.params.action#">
	<cfargument name="template" type="any" required="false" default="">
	<cfargument name="layout" type="any" required="false" default="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.rendering_view_page = getTickCount()>
	</cfif>

	<!--- set a flag here so that renderPartial knows the context it's being run in --->
	<cfset request.wheels.rendering_page = true>

	<!--- if renderPage was called with a layout set a flag to indicate that it's ok to show debug info at the end of the request --->
	<cfif arguments.layout>
		<cfset request.wheels.show_debug_information = true>
	</cfif>

	<!--- double-checked lock --->
	<cfif application.settings.cache_pages AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset local.category = "action">
		<cfset local.key = "#arguments.action#_#hashStruct(variables.params)#_#hashStruct(arguments)#">
		<cfset local.lock_name = local.category & local.key>
		<cflock name="#local.lock_name#" type="readonly" timeout="30">
			<cfset request.wheels.response = getFromCache(local.key, local.category)>
		</cflock>
		<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#local.lock_name#" type="exclusive" timeout="30">
				<cfset request.wheels.response = getFromCache(local.key, local.category)>
				<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset FL_renderPage(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.caching.pages>
					</cfif>
					<cfset addToCache(local.key, request.wheels.response, arguments.cache, local.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset FL_renderPage(argumentCollection=arguments)>
	</cfif>

	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.rendering_view_page = getTickCount() - request.wheels.execution.components.rendering_view_page>
	</cfif>

</cffunction>


<cffunction name="FL_renderPage" returntype="any" access="public" output="false">
	<cfif len(arguments.template) IS NOT 0>
		<cfset request.wheels.response = FL_include("../../views/#arguments.template#.cfm")>
	<cfelse>
		<cfset request.wheels.response = FL_include("../../views/#arguments.controller#/#arguments.action#.cfm")>
	</cfif>
	<cfset FL_renderLayout(layout=arguments.layout)>
</cffunction>


<cffunction name="renderNothing" returntype="any" access="public" output="false">
	<cfset request.wheels.response = "">
</cffunction>


<cffunction name="renderText" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset request.wheels.response = arguments.text>
</cffunction>


<cffunction name="FL_renderPartial" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<!--- Setup local variables --->
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "name" AND local.i IS NOT "cache">
			<cfset "#local.i#" = arguments[local.i]>
		</cfif>
	</cfloop>
	<cfif arguments.name Contains "/">
		<!--- Include a file in a sub folder to views --->
		<cfset local.partial = FL_include("../../views/#reverse(listRest(reverse(arguments.name), '/'))#/_#reverse(listFirst(reverse(arguments.name), '/'))#.cfm")>
	<cfelse>
		<!--- Include a file in the current controller's view folder --->
		<cfset local.partial = FL_include("../../views/#variables.params.controller#/_#arguments.name#.cfm")>
	</cfif>

	<cfreturn local.partial>
</cffunction>


<cffunction name="renderPartial" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="cache" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif application.settings.show_debug_information>
		<cfset local.partial_start_time = getTickCount()>
	</cfif>

	<!--- double-checked lock --->
	<cfif application.settings.cache_partials AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset local.category = "partial">
		<cfset local.key = "#arguments.name#_#hashStruct(variables.params)#_#hashStruct(arguments)#">
		<cfset local.lock_name = local.category & local.key>
		<cflock name="#local.lock_name#" type="readonly" timeout="30">
			<cfset local.partial = getFromCache(local.key, local.category)>
		</cflock>
		<cfif isBoolean(local.partial) AND NOT local.partial>
	   	<cflock name="#local.lock_name#" type="exclusive" timeout="30">
				<cfset local.partial = getFromCache(local.key, local.category)>
				<cfif isBoolean(local.partial) AND NOT local.partial>
					<cfset local.partial = FL_renderPartial(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.caching.partials>
					</cfif>
					<cfset addToCache(local.key, local.partial, arguments.cache, local.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset local.partial = FL_renderPartial(argumentCollection=arguments)>
	</cfif>

	<cfif application.settings.show_debug_information>
		<cfset local.partial_total_time = getTickCount() - local.partial_start_time>
		<cfset request.wheels.execution.partial_total = request.wheels.execution.partial_total + local.partial_total_time>
		<cfif structKeyExists(request.wheels.execution.partials, replace(arguments.name, "/", "_", "all"))>
			<cfset request.wheels.execution.partials[replace(arguments.name, "/", "_", "all")] = request.wheels.execution.partials[replace(arguments.name, "/", "_", "all")] + local.partial_total_time>
		<cfelse>
			<cfset "request.wheels.execution.partials.#replace(arguments.name, '/', '_', 'all')#" = local.partial_total_time>
		</cfif>
	</cfif>

	<cfif structKeyExists(request.wheels, "rendering_page")>
		<cfreturn local.partial>
	<cfelse>
		<cfset request.wheels.response = local.partial>
	</cfif>
</cffunction>


<cffunction name="FL_include" returntype="any" access="private" output="false">
	<cfargument name="FL_path" type="any" required="true">
	<cfset var FL_local = structNew()>
	<cfsavecontent variable="FL_local.output">
		<cfinclude template="#arguments.FL_path#">
	</cfsavecontent>
	<cfreturn trim(FL_local.output)>
</cffunction>


<cffunction name="FL_renderLayout" returntype="any" access="private" output="false">
	<cfargument name="layout" type="any" required="true">

	<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT isBoolean(arguments.layout)>
			<!--- Include a designated layout --->
			<cfset request.wheels.response = FL_include("../../views/layouts/#replace(arguments.layout, ' ', '_', 'all')#_layout.cfm")>
		<cfelseif fileExists(expandPath("views/layouts/#variables.params.controller#_layout.cfm"))>
			<!--- Include the current controller's layout if one exists --->
			<cfset request.wheels.response = FL_include("../../views/layouts/#variables.params.controller#_layout.cfm")>
		<cfelse>
			<!--- The application wide layout --->
			<cfset request.wheels.response = FL_include("../../views/layouts/application_layout.cfm")>
		</cfif>
	</cfif>

</cffunction>