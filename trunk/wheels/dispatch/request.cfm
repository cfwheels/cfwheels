<cffunction name="request" output="false">
	<cfset var loc = {}>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.setup = getTickCount()>
	</cfif>

	<!--- find the matching route --->
	<cfif cgi.path_info IS cgi.script_name OR cgi.path_info IS "/" OR cgi.path_info IS "">
		<cfset loc.route = "">
	<cfelse>
		<cfset loc.route = Right(cgi.path_info, Len(cgi.path_info)-1)>
	</cfif>
	<cfloop from="1" to="#arrayLen(application.wheels.routes)#" index="loc.i">
		<cfset loc.currentRoute = application.wheels.routes[loc.i].pattern>
		<cfif loc.route IS "" AND loc.currentRoute IS "">
			<cfset loc.foundRoute = application.wheels.routes[loc.i]>
			<cfbreak>
		<cfelse>
			<cfif listLen(loc.route, "/") GTE listLen(loc.currentRoute, "/") AND loc.currentRoute IS NOT "">
				<cfset loc.pos = 0>
				<cfset loc.match = true>
				<cfloop list="#loc.currentRoute#" delimiters="/" index="loc.j">
					<cfset loc.pos = loc.pos + 1>
					<cfset loc.thisRoute = replaceList(loc.j, "[,]", ",")>
					<cfset loc.thisURL = listGetAt(loc.route, loc.pos, "/")>
					<cfif Left(loc.j, 1) IS NOT "[" AND loc.thisRoute IS NOT loc.thisURL>
						<cfset loc.match = false>
					</cfif>
				</cfloop>
				<cfif loc.match>
					<cfset loc.foundRoute = application.wheels.routes[loc.i]>
					<cfbreak>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfif NOT StructKeyExists(loc, "foundRoute")>
		<cfthrow type="Wheels" message="Route Not Found" extendedInfo="Make sure there is a route setup in your <tt>config/routes.cfm</tt> file that matches the <tt>#loc.route#</tt>request">
	</cfif>

	<!--- create the params struct and add any values that should be retrieved from the URL --->
	<cfset loc.params = URL>
	<cfset loc.pos = 0>
	<cfloop list="#loc.foundRoute.pattern#" delimiters="/" index="loc.i">
		<cfset loc.pos = loc.pos + 1>
		<cfif Left(loc.i, 1) IS "[">
			<cfset loc.params[replaceList(loc.i, "[,]", ",")] = listGetAt(loc.route, loc.pos, "/")>
		</cfif>
	</cfloop>

	<!--- add controller and action unless they already exist --->
	<cfif NOT StructKeyExists(loc.params, "controller")>
		<cfset loc.params.controller = loc.foundRoute.controller>
	</cfif>
	<cfif NOT StructKeyExists(loc.params, "action")>
		<cfset loc.params.action = loc.foundRoute.action>
	</cfif>

	<!--- decrypt all values except controller and action --->
	<cfif application.settings.obfuscateURLs>
		<cfloop collection="#loc.params#" item="loc.i">
			<cfif loc.i IS NOT "controller" AND loc.i IS NOT "action">
				<cftry>
					<cfset loc.params[loc.i] = deobfuscateParam(loc.params[loc.i])>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cfif>

	<cfif structCount(form) IS NOT 0>

		<!--- loop through form variables and merge any date variables into one --->
		<cfset loc.dates = StructNew()>
		<cfloop collection="#form#" item="loc.i">
			<cfif REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.i) IS NOT 0>
				<cfset loc.temp = listToArray(loc.i, "(")>
				<cfset loc.firstKey = loc.temp[1]>
				<cfset loc.secondKey = spanExcluding(loc.temp[2], ")")>
				<cfif NOT StructKeyExists(loc.dates, loc.firstKey)>
					<cfset loc.dates[loc.firstKey] = StructNew()>
				</cfif>
				<cfset loc.dates[loc.firstKey][ReplaceNoCase(loc.secondKey, "$", "")] = form[loc.i]>
			</cfif>
		</cfloop>
		<cfloop collection="#loc.dates#" item="loc.i">
			<cfif NOT StructKeyExists(loc.dates[loc.i], "year")>
				<cfset loc.dates[loc.i].year = 1899>
			</cfif>
			<cfif NOT StructKeyExists(loc.dates[loc.i], "month")>
				<cfset loc.dates[loc.i].month = 12>
			</cfif>
			<cfif NOT StructKeyExists(loc.dates[loc.i], "day")>
				<cfset loc.dates[loc.i].day = 30>
			</cfif>
			<cfif NOT StructKeyExists(loc.dates[loc.i], "hour")>
				<cfset loc.dates[loc.i].hour = 0>
			</cfif>
			<cfif NOT StructKeyExists(loc.dates[loc.i], "minute")>
				<cfset loc.dates[loc.i].minute = 0>
			</cfif>
			<cfif NOT StructKeyExists(loc.dates[loc.i], "second")>
				<cfset loc.dates[loc.i].second = 0>
			</cfif>
			<cftry>
				<cfset form[loc.i] = createDateTime(loc.dates[loc.i].year, loc.dates[loc.i].month, loc.dates[loc.i].day, loc.dates[loc.i].hour, loc.dates[loc.i].minute, loc.dates[loc.i].second)>
			<cfcatch>
				<cfset form[loc.i] = "">
			</cfcatch>
			</cftry>
			<cfif StructKeyExists(form, "#loc.i#($year)")>
				<cfset StructDelete(form, "#loc.i#($year)")>
			</cfif>
			<cfif StructKeyExists(form, "#loc.i#($month)")>
				<cfset StructDelete(form, "#loc.i#($month)")>
			</cfif>
			<cfif StructKeyExists(form, "#loc.i#($day)")>
				<cfset StructDelete(form, "#loc.i#($day)")>
			</cfif>
			<cfif StructKeyExists(form, "#loc.i#($hour)")>
				<cfset StructDelete(form, "#loc.i#($hour)")>
			</cfif>
			<cfif StructKeyExists(form, "#loc.i#($minute)")>
				<cfset StructDelete(form, "#loc.i#($minute)")>
			</cfif>
			<cfif StructKeyExists(form, "#loc.i#($second)")>
				<cfset StructDelete(form, "#loc.i#($second)")>
			</cfif>
		</cfloop>

		<!--- add form variables to the params struct --->
		<cfloop collection="#form#" item="loc.i">
			<cfset loc.match = reFindNoCase("(.*?)\[(.*?)\]", loc.i, 1, true)>
			<cfif arrayLen(loc.match.pos) IS 3>
				<!--- Model object form field, build a struct to hold the data, named after the model object --->
				<cfset loc.objectName = lCase(Mid(loc.i, loc.match.pos[2], loc.match.len[2]))>
				<cfset loc.fieldName = lCase(Mid(loc.i, loc.match.pos[3], loc.match.len[3]))>
				<cfif NOT StructKeyExists(loc.params, loc.objectName)>
					<cfset loc.params[loc.objectName] = StructNew()>
				</cfif>
				<cfset loc.params[loc.objectName][loc.fieldName] = form[loc.i]>
			<cfelse>
				<!--- Normal form field --->
				<cfset loc.params[loc.i] = form[loc.i]>
			</cfif>
		</cfloop>

	</cfif>

	<!--- set params in the request scope as well so we can display it in the debug info outside of the controller context --->
	<cfset request.wheels.params = loc.params>

	<!--- Create an empty flash unless it already exists --->
	<cfif NOT StructKeyExists(session, "flash")>
		<cfset session.flash = StructNew()>
	</cfif>

	<!--- Create requested controller --->
	<cftry>
		<cfset loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params)>
	<cfcatch>
		<cfif fileExists(expandPath("controllers/#loc.params.controller#.cfc"))>
			<cfrethrow>
		<cfelse>
			<cfif application.settings.showErrorInformation>
				<cfthrow type="Wheels" message="Could not find the <tt>#loc.params.controller#</tt> controller" extendedInfo="Create a file named <tt>#loc.params.controller#.cfc</tt> in the <tt>controllers</tt> directory containing this code: <pre><code>#htmlEditFormat('<cfcomponent extends="wheels.controller"></cfcomponent>')#</code></pre>">
			<cfelse>
				<cfinclude template="../../events/onmissingtemplate.cfm">
				<cfabort>
			</cfif>
		</cfif>
	</cfcatch>
	</cftry>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.setup = getTickCount() - request.wheels.execution.components.setup>
		<cfset request.wheels.execution.components.beforeFilters = getTickCount()>
	</cfif>

	<!--- confirm verifications on controller if they exist --->
	<cfset loc.verifications = loc.controller.$getVerifications()>
	<cfset loc.abort = false>
	<cfif arrayLen(loc.verifications) IS NOT 0>
		<cfloop from="1" to="#arrayLen(loc.verifications)#" index="loc.i">
			<cfset loc.verification = loc.verifications[loc.i]>
			<cfif	(Len(loc.verification.only) IS 0 AND Len(loc.verification.except) IS 0) OR (Len(loc.verification.only) IS NOT 0 AND listFindNoCase(loc.verification.only, loc.params.action)) OR (Len(loc.verification.except) IS NOT 0 AND NOT listFindNoCase(loc.verification.except, loc.params.action))>
				<cfif IsBoolean(loc.verification.post) AND ((loc.verification.post AND cgi.request_method IS NOT "post") OR (NOT loc.verification.post AND cgi.request_method IS "post"))>
					<cfset loc.abort = true>
				</cfif>
				<cfif IsBoolean(loc.verification.get) AND ((loc.verification.get AND cgi.request_method IS NOT "get") OR (NOT loc.verification.get AND cgi.request_method IS "get"))>
					<cfset loc.abort = true>
				</cfif>
				<cfif IsBoolean(loc.verification.ajax) AND ((loc.verification.ajax AND cgi.http_x_requested_with IS NOT "XMLHTTPRequest") OR (NOT loc.verification.ajax AND cgi.http_x_requested_with IS "XMLHTTPRequest"))>
					<cfset loc.abort = true>
				</cfif>
				<cfif loc.verification.params IS NOT "">
					<cfloop list="#loc.verification.params#" index="loc.j">
						<cfif NOT StructKeyExists(loc.params, loc.j)>
							<cfset loc.abort = true>
						</cfif>
					</cfloop>
				</cfif>
				<cfif loc.verification.session IS NOT "">
					<cfloop list="#loc.verification.session#" index="loc.j">
						<cfif NOT StructKeyExists(session, loc.j)>
							<cfset loc.abort = true>
						</cfif>
					</cfloop>
				</cfif>
				<cfif loc.verification.cookie IS NOT "">
					<cfloop list="#loc.verification.cookie#" index="loc.j">
						<cfif NOT StructKeyExists(cookie, loc.j)>
							<cfset loc.abort = true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfif loc.abort>
				<cfif loc.verification.handler IS NOT "">
					<cfinvoke component="#loc.controller#" method="#loc.verification.handler#">
					<cflocation url="#cgi.http_referer#" addtoken="false">
				<cfelse>
					<cfset request.wheels.response = "">
					<cfreturn request.wheels.response>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<!--- Call before filters on controller if they exist --->
	<cfset loc.beforeFilters = loc.controller.$getBeforeFilters()>
	<cfif arrayLen(loc.beforeFilters) IS NOT 0>
		<cfloop from="1" to="#arrayLen(loc.beforeFilters)#" index="loc.i">
			<cfif	(Len(loc.beforeFilters[loc.i].only) IS 0 AND Len(loc.beforeFilters[loc.i].except) IS 0) OR (Len(loc.beforeFilters[loc.i].only) IS NOT 0 AND listFindNoCase(loc.beforeFilters[loc.i].only, loc.params.action)) OR (Len(loc.beforeFilters[loc.i].except) IS NOT 0 AND NOT listFindNoCase(loc.beforeFilters[loc.i].except, loc.params.action))>
				<cfinvoke component="#loc.controller#" method="#loc.beforeFilters[loc.i].through#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.beforeFilters = getTickCount() - request.wheels.execution.components.beforeFilters>
		<cfset request.wheels.execution.components.action = getTickCount()>
	</cfif>

	<!--- Call action on controller if it exists --->
	<cfset loc.actionIsCachable = false>
	<cfif application.settings.cacheActions AND structIsEmpty(session.flash) AND structIsEmpty(form)>
		<cfset loc.cachableActions = loc.controller.$getCachableActions()>
		<cfloop from="1" to="#arrayLen(loc.cachableActions)#" index="loc.i">
			<cfif loc.cachableActions[loc.i].action IS loc.params.action>
				<cfset loc.actionIsCachable = true>
				<cfset loc.timeToCache = loc.cachableActions[loc.i].time>
			</cfif>
		</cfloop>
	</cfif>

	<cfif loc.actionIsCachable>
		<cfset loc.category = "action">
		<cfset loc.key = "#cgi.script_name##cgi.path_info##cgi.query_string#">
		<cfset loc.lockName = loc.category & loc.key>
		<cflock name="#loc.lockName#" type="readonly" timeout="30">
			<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
		</cflock>
		<cfif IsBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
				<cfset request.wheels.response = $getFromCache(loc.key, loc.category)>
				<cfif IsBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset $callAction(loc.controller, loc.params.controller, loc.params.action)>
					<cfset $addToCache(loc.key, request.wheels.response, loc.timeToCache, loc.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset $callAction(loc.controller, loc.params.controller, loc.params.action)>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.action = getTickCount() - request.wheels.execution.components.action>
		<cfif StructKeyExists(request.wheels.execution.components, "view")>
			<cfset request.wheels.execution.components.action = request.wheels.execution.components.action - request.wheels.execution.components.view>
		</cfif>
		<cfset request.wheels.execution.components.afterFilters = getTickCount()>
	</cfif>

	<cfset loc.afterFilters = loc.controller.$getAfterFilters()>
	<cfif arrayLen(loc.afterFilters) IS NOT 0>
		<cfloop from="1" to="#arrayLen(loc.afterFilters)#" index="loc.i">
			<cfif	(Len(loc.afterFilters[loc.i].only) IS 0 AND Len(loc.afterFilters[loc.i].except) IS 0) OR (Len(loc.afterFilters[loc.i].only) IS NOT 0 AND listFindNoCase(loc.afterFilters[loc.i].only, loc.params.action)) OR (Len(loc.afterFilters[loc.i].except) IS NOT 0 AND NOT listFindNoCase(loc.afterFilters[loc.i].except, loc.params.action))>
				<cfinvoke component="#loc.controller#" method="#loc.afterFilters[loc.i].through#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.afterFilters = getTickCount() - request.wheels.execution.components.afterFilters>
	</cfif>

	<!--- Clear the flash (note that this is not done for redirectTo since the processing does not get here) --->
	<cfset StructClear(session.flash)>

	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="$callAction" returntype="void" access="private" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controllerName" type="string" required="true">
	<cfargument name="actionName" type="string" required="true">

	<cfif StructKeyExists(arguments.controller, arguments.actionName)>
		<cfinvoke component="#arguments.controller#" method="#arguments.actionName#">
	</cfif>
	<cfif NOT StructKeyExists(request.wheels, "response")>
		<!--- A render function has not been called yet so call it here --->
		<cftry>
			<cfset arguments.controller.renderPage()>
		<cfcatch>
			<cfif fileExists(expandPath("views/#arguments.controllerName#/#arguments.actionName#.cfm"))>
				<cfrethrow>
			<cfelse>
				<cfif application.settings.showErrorInformation>
					<cfthrow type="Wheels" message="Could not find the view page for the <tt>#arguments.actionName#</tt> action in the <tt>#arguments.controllerName#</tt> controller" extendedInfo="Create a file named <tt>#arguments.actionName#.cfm</tt> in the <tt>views/#arguments.controllerName#</tt> directory (create the directory as well if necessary).">
				<cfelse>
					<cfinclude template="../../events/onmissingtemplate.cfm">
					<cfabort>
				</cfif>
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>

</cffunction>