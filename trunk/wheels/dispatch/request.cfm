<cffunction name="request" output="false">
	<cfset var local = structNew()>

	<cfif application.settings.environment IS NOT "production">
		<cfset request.wheels.execution.components.setting_up_request = getTickCount()>
	</cfif>

	<cfif CGI.path_info IS CGI.script_name OR CGI.path_info IS "/">
		<cfset local.route = "">
	<cfelse>
		<cfset local.route = right(CGI.path_info, len(CGI.path_info)-1)>
	</cfif>

	<!--- find the matching route --->
	<cfloop from="1" to="#arrayLen(application.wheels.routes)#" index="local.i">
		<cfset local.current_route = application.wheels.routes[local.i].pattern>
		<cfif listLen(local.route, "/") GTE listLen(local.current_route, "/")>
			<cfset local.pos = 0>
			<cfset local.match = true>
			<cfloop list="#local.current_route#" delimiters="/" index="local.j">
				<cfset local.pos = local.pos + 1>
				<cfset local.this_route = replaceList(local.j, "[,]", ",")>
				<cfset local.this_url = listGetAt(local.route, local.pos, "/")>
				<cfif left(local.j, 1) IS NOT "[" AND local.this_route IS NOT local.this_url>
					<cfset local.match = false>
				</cfif>
			</cfloop>
			<cfif local.match>
				<cfset local.found_route = application.wheels.routes[local.i]>
				<cfbreak>
			</cfif>
		</cfif>
	</cfloop>

	<!--- create the params struct and add any values that should be retrieved from the URL --->
	<cfset local.params = URL>
	<cfset local.pos = 0>
	<cfloop list="#local.found_route.pattern#" delimiters="/" index="local.i">
		<cfset local.pos = local.pos + 1>
		<cfif left(local.i, 1) IS "[">
			<cfset local.params[replaceList(local.i, "[,]", ",")] = listGetAt(local.route, local.pos, "/")>
		</cfif>
	</cfloop>

	<!--- add controller and action unless they already exist --->
	<cfif NOT structKeyExists(local.params, "controller")>
		<cfset local.params.controller = local.found_route.controller>
	</cfif>
	<cfif NOT structKeyExists(local.params, "action")>
		<cfset local.params.action = local.found_route.action>
	</cfif>

	<!--- decrypt all values except controller and action --->
	<cfif application.settings.obfuscate_urls>
		<cfloop collection="#local.params#" item="local.i">
			<cfif local.i IS NOT "controller" AND local.i IS NOT "action">
				<cftry>
					<cfset local.params[local.i] = decryptParam(local.params[local.i])>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cfif>

	<!--- add form variables to the params struct --->
	<cfloop collection="#form#" item="local.i">
		<cfset local.match = reFindNoCase("(.*?)\[(.*?)\]", local.i, 1, true)>
		<cfif arrayLen(local.match.pos) IS 3>
			<!--- Model object form field, build a struct to hold the data, named after the model object --->
			<cfset local.object_name = lCase(mid(local.i, local.match.pos[2], local.match.len[2]))>
			<cfset local.field_name = lCase(mid(local.i, local.match.pos[3], local.match.len[3]))>
			<cfif NOT structKeyExists(local.params, local.object_name)>
				<cfset local.params[local.object_name] = structNew()>
			</cfif>
			<cfset local.params[local.object_name][local.field_name] = form[local.i]>
		<cfelse>
			<!--- Normal form field --->
			<cfset local.params[local.i] = form[local.i]>
		</cfif>
	</cfloop>

	<!--- Create an empty flash unless it already exists --->
	<cfif NOT structKeyExists(session, "flash")>
		<cfset session.flash = structNew()>
	</cfif>

	<!--- Create requested controller --->
	<cfif application.settings.environment IS NOT "production">
		<cfif fileExists(expandPath("controllers/#local.params.controller#.cfc"))>
			<cfset local.controller = createObject("component", "#application.wheels.cfc_path#controllers.#local.params.controller#").FL_initController(local.params)>
		<cfelse>
			<cfthrow type="wheels.controllerMissing" message="There is no controller named '#local.params.controller#'">
		</cfif>
	<cfelse>
		<cfset local.controller = createObject("component", "#application.wheels.cfc_path#controllers.#local.params.controller#").FL_initController(local.params)>
	</cfif>

	<cfif application.settings.environment IS NOT "production">
		<cfset request.wheels.execution.components.setting_up_request = getTickCount() - request.wheels.execution.components.setting_up_request>
		<cfset request.wheels.execution.components.running_before_filters = getTickCount()>
	</cfif>

	<!--- Call before filters on controller if they exist --->
	<cfset local.before_filters = local.controller.getBeforeFilters()>
	<cfif arrayLen(local.before_filters) IS NOT 0>
		<cfloop from="1" to="#arraylen(local.before_filters)#" index="local.i">
			<cfif	(len(local.before_filters[local.i].only) IS 0 AND len(local.before_filters[local.i].except) IS 0) OR (len(local.before_filters[local.i].only) IS NOT 0 AND listFindNoCase(local.before_filters[local.i].only, local.params.action)) OR (len(local.before_filters[local.i].except) IS NOT 0 AND NOT listFindNoCase(local.before_filters[local.i].except, local.params.action))>
				<cfinvoke component="#local.controller#" method="#local.before_filters[local.i].filter#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.environment IS NOT "production">
		<cfset request.wheels.execution.components.running_before_filters = getTickCount() - request.wheels.execution.components.running_before_filters>
		<cfset request.wheels.execution.components.running_controller_action = getTickCount()>
	</cfif>

	<!--- Call action on controller if it exists --->
	<cfset local.action_is_cachable = false>
	<cfif application.settings.perform_caching AND structIsEmpty(session.flash) AND structIsEmpty(form)>
		<cfset local.cachable_actions = local.controller.getCachableActions()>
		<cfloop from="1" to="#arrayLen(local.cachable_actions)#" index="local.i">
			<cfif local.cachable_actions[local.i].action IS local.params.action>
				<cfset local.action_is_cachable = true>
				<cfset local.time_to_cache = local.cachable_actions[local.i].time>
			</cfif>
		</cfloop>
	</cfif>

	<cfif local.action_is_cachable>
		<cfset local.category = "action">
		<cfset local.key = "#CGI.path_info#_#local.query_string#">
		<cfset local.lock_name = local.category & local.key>
		<cflock name="#local.lock_name#" type="readonly" timeout="10">
			<cfset request.wheels.response = getFromCache(local.key, local.category)>
		</cflock>
		<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#local.lock_name#" type="exclusive" timeout="10">
				<cfset request.wheels.response = getFromCache(local.key, local.category)>
				<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset FL_callAction(local.controller, local.params.controller, local.params.action)>
					<cfset addToCache(local.key, request.wheels.response, local.time_to_cache, local.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset FL_callAction(local.controller, local.params.controller, local.params.action)>
	</cfif>

	<cfif application.settings.environment IS NOT "production">
		<cfset request.wheels.execution.components.running_controller_action = getTickCount() - request.wheels.execution.components.running_controller_action>
		<cfif structKeyExists(request.wheels.execution.components, "rendering_view_page")>
			<cfset request.wheels.execution.components.running_controller_action = request.wheels.execution.components.running_controller_action - request.wheels.execution.components.rendering_view_page>
		</cfif>
		<cfset request.wheels.execution.components.running_after_filters = getTickCount()>
	</cfif>

	<cfset local.after_filters = local.controller.getAfterFilters()>
	<cfif arrayLen(local.after_filters) IS NOT 0>
		<cfloop from="1" to="#arraylen(local.after_filters)#" index="local.i">
			<cfif	(len(local.after_filters[local.i].only) IS 0 AND len(local.after_filters[local.i].except) IS 0) OR (len(local.after_filters[local.i].only) IS NOT 0 AND listFindNoCase(local.after_filters[local.i].only, local.params.action)) OR (len(local.after_filters[local.i].except) IS NOT 0 AND NOT listFindNoCase(local.after_filters[local.i].except, local.params.action))>
				<cfinvoke component="#local.controller#" method="#local.after_filters[local.i].filter#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.environment IS NOT "production">
		<cfset request.wheels.execution.components.running_after_filters = getTickCount() - request.wheels.execution.components.running_after_filters>
	</cfif>

	<!--- Clear the flash (note that this is not done for redirectTo since the processing does not get here) --->
	<cfset structClear(session.flash)>

	<cfreturn request.wheels.response>
</cffunction>


<cffunction name="FL_callAction" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controller_name" type="any" required="true">
	<cfargument name="action_name" type="any" required="true">

	<cfif structKeyExists(arguments.controller, arguments.action_name)>
		<cfinvoke component="#arguments.controller#" method="#arguments.action_name#">
	</cfif>
	<cfif NOT structKeyExists(request.wheels, "response") OR (isBoolean(request.wheels.response) AND NOT request.wheels.response)>
		<!--- A render function has not been called yet so call it here --->
		<cfif application.settings.environment IS NOT "production">
			<cfif fileExists(expandPath("views/#arguments.controller_name#/#arguments.action_name#.cfm"))>
				<cfset arguments.controller.renderPage()>
			<cfelse>
				<cfthrow type="wheels.actionMissing" message="There is no action named '#arguments.action_name#'">
			</cfif>
		<cfelse>
			<cfset arguments.controller.renderPage()>
		</cfif>
	</cfif>
</cffunction>