<cffunction name="request" output="false">
	<cfset var locals = structNew()>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.setup = getTickCount()>
	</cfif>

	<!--- find the matching route --->
	<cfif CGI.PATH_INFO IS CGI.SCRIPT_NAME OR CGI.PATH_INFO IS "/" OR CGI.PATH_INFO IS "">
		<cfset locals.route = "">
	<cfelse>
		<cfset locals.route = right(CGI.PATH_INFO, len(CGI.PATH_INFO)-1)>
	</cfif>
	<cfloop from="1" to="#arrayLen(application.wheels.routes)#" index="locals.i">
		<cfset locals.currentRoute = application.wheels.routes[locals.i].pattern>
		<cfif locals.route IS "" AND locals.currentRoute IS "">
			<cfset locals.foundRoute = application.wheels.routes[locals.i]>
			<cfbreak>
		<cfelse>
			<cfif listLen(locals.route, "/") GTE listLen(locals.currentRoute, "/") AND locals.currentRoute IS NOT "">
				<cfset locals.pos = 0>
				<cfset locals.match = true>
				<cfloop list="#locals.currentRoute#" delimiters="/" index="locals.j">
					<cfset locals.pos = locals.pos + 1>
					<cfset locals.thisRoute = replaceList(locals.j, "[,]", ",")>
					<cfset locals.thisURL = listGetAt(locals.route, locals.pos, "/")>
					<cfif left(locals.j, 1) IS NOT "[" AND locals.thisRoute IS NOT locals.thisURL>
						<cfset locals.match = false>
					</cfif>
				</cfloop>
				<cfif locals.match>
					<cfset locals.foundRoute = application.wheels.routes[locals.i]>
					<cfbreak>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfif NOT structKeyExists(locals, "foundRoute")>
		<cfthrow type="wheels" message="Routing error" detail="Make sure there is a route setup in your <tt>config/routes.cfm</tt> file that matches the <tt>#locals.route#</tt>request">
	</cfif>

	<!--- create the params struct and add any values that should be retrieved from the URL --->
	<cfset locals.params = URL>
	<cfset locals.pos = 0>
	<cfloop list="#locals.foundRoute.pattern#" delimiters="/" index="locals.i">
		<cfset locals.pos = locals.pos + 1>
		<cfif left(locals.i, 1) IS "[">
			<cfset locals.params[replaceList(locals.i, "[,]", ",")] = listGetAt(locals.route, locals.pos, "/")>
		</cfif>
	</cfloop>

	<!--- add controller and action unless they already exist --->
	<cfif NOT structKeyExists(locals.params, "controller")>
		<cfset locals.params.controller = locals.foundRoute.controller>
	</cfif>
	<cfif NOT structKeyExists(locals.params, "action")>
		<cfset locals.params.action = locals.foundRoute.action>
	</cfif>

	<!--- decrypt all values except controller and action --->
	<cfif application.settings.obfuscateURLs>
		<cfloop collection="#locals.params#" item="locals.i">
			<cfif locals.i IS NOT "controller" AND locals.i IS NOT "action">
				<cftry>
					<cfset locals.params[locals.i] = deobfuscateParam(locals.params[locals.i])>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cfif>

	<cfif structCount(form) IS NOT 0>

		<!--- loop through form variables and merge any date variables into one --->
		<cfset locals.dates = structNew()>
		<cfloop collection="#form#" item="locals.i">
			<cfif REFindNoCase(".*\((_year|_month|_day|_hour|_minute|_second)\)$", locals.i) IS NOT 0>
				<cfset locals.temp = listToArray(locals.i, "(")>
				<cfset locals.firstKey = locals.temp[1]>
				<cfset locals.secondKey = spanExcluding(locals.temp[2], ")")>
				<cfif NOT structKeyExists(locals.dates, locals.firstKey)>
					<cfset locals.dates[locals.firstKey] = structNew()>
				</cfif>
				<cfset locals.dates[locals.firstKey][replaceNoCase(locals.secondKey, "_", "")] = form[locals.i]>
			</cfif>
		</cfloop>
		<cfloop collection="#locals.dates#" item="locals.i">
			<cfif NOT structKeyExists(locals.dates[locals.i], "year")>
				<cfset locals.dates[locals.i].year = 1899>
			</cfif>
			<cfif NOT structKeyExists(locals.dates[locals.i], "month")>
				<cfset locals.dates[locals.i].month = 12>
			</cfif>
			<cfif NOT structKeyExists(locals.dates[locals.i], "day")>
				<cfset locals.dates[locals.i].day = 30>
			</cfif>
			<cfif NOT structKeyExists(locals.dates[locals.i], "hour")>
				<cfset locals.dates[locals.i].hour = 0>
			</cfif>
			<cfif NOT structKeyExists(locals.dates[locals.i], "minute")>
				<cfset locals.dates[locals.i].minute = 0>
			</cfif>
			<cfif NOT structKeyExists(locals.dates[locals.i], "second")>
				<cfset locals.dates[locals.i].second = 0>
			</cfif>
			<cftry>
				<cfset form[locals.i] = createDateTime(locals.dates[locals.i].year, locals.dates[locals.i].month, locals.dates[locals.i].day, locals.dates[locals.i].hour, locals.dates[locals.i].minute, locals.dates[locals.i].second)>
			<cfcatch>
				<cfset form[locals.i] = "">
			</cfcatch>
			</cftry>
			<cfif structKeyExists(form, "#locals.i#(_year)")>
				<cfset structDelete(form, "#locals.i#(_year)")>
			</cfif>
			<cfif structKeyExists(form, "#locals.i#(_month)")>
				<cfset structDelete(form, "#locals.i#(_month)")>
			</cfif>
			<cfif structKeyExists(form, "#locals.i#(_day)")>
				<cfset structDelete(form, "#locals.i#(_day)")>
			</cfif>
			<cfif structKeyExists(form, "#locals.i#(_hour)")>
				<cfset structDelete(form, "#locals.i#(_hour)")>
			</cfif>
			<cfif structKeyExists(form, "#locals.i#(_minute)")>
				<cfset structDelete(form, "#locals.i#(_minute)")>
			</cfif>
			<cfif structKeyExists(form, "#locals.i#(_second)")>
				<cfset structDelete(form, "#locals.i#(_second)")>
			</cfif>
		</cfloop>

		<!--- add form variables to the params struct --->
		<cfloop collection="#form#" item="locals.i">
			<cfset locals.match = reFindNoCase("(.*?)\[(.*?)\]", locals.i, 1, true)>
			<cfif arrayLen(locals.match.pos) IS 3>
				<!--- Model object form field, build a struct to hold the data, named after the model object --->
				<cfset locals.objectName = lCase(mid(locals.i, locals.match.pos[2], locals.match.len[2]))>
				<cfset locals.fieldName = lCase(mid(locals.i, locals.match.pos[3], locals.match.len[3]))>
				<cfif NOT structKeyExists(locals.params, locals.objectName)>
					<cfset locals.params[locals.objectName] = structNew()>
				</cfif>
				<cfset locals.params[locals.objectName][locals.fieldName] = form[locals.i]>
			<cfelse>
				<!--- Normal form field --->
				<cfset locals.params[locals.i] = form[locals.i]>
			</cfif>
		</cfloop>

	</cfif>

	<!--- set params in the request scope as well so we can display it in the debug info outside of the controller context --->
	<cfset request.wheels.params = locals.params>

	<!--- Create an empty flash unless it already exists --->
	<cflock scope="session" type="readonly" timeout="30">
		<cfset locals.flashExists = structKeyExists(session, "flash")>
	</cflock>
	<cfif NOT locals.flashExists>
		<cflock scope="session" type="exclusive" timeout="30">
			<cfset session.flash = structNew()>
		</cflock>
	</cfif>

	<!--- Create requested controller --->
	<cftry>
		<cfset locals.controller = _controller(locals.params.controller)._createControllerObject(locals.params)>
	<cfcatch>
		<cfif fileExists(expandPath("controllers/#locals.params.controller#.cfc"))>
			<cfrethrow>
		<cfelse>
			<cfif application.settings.showErrorInformation>
				<cfthrow type="wheels" message="Could not find the <tt>#locals.params.controller#</tt> controller" detail="Create a file named <tt>#locals.params.controller#.cfc</tt> in the <tt>controllers</tt> directory containing this code: <pre><code>#htmlEditFormat('<cfcomponent extends="wheels.controller"></cfcomponent>')#</code></pre>">
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
	<cfset locals.verifications = locals.controller._getVerifications()>
	<cfset locals.abort = false>
	<cfif arrayLen(locals.verifications) IS NOT 0>
		<cfloop from="1" to="#arraylen(locals.verifications)#" index="locals.i">
			<cfset locals.verification = locals.verifications[locals.i]>
			<cfif	(len(locals.verification.only) IS 0 AND len(locals.verification.except) IS 0) OR (len(locals.verification.only) IS NOT 0 AND listFindNoCase(locals.verification.only, locals.params.action)) OR (len(locals.verification.except) IS NOT 0 AND NOT listFindNoCase(locals.verification.except, locals.params.action))>
				<cfif isBoolean(locals.verification.post) AND ((locals.verification.post AND CGI.REQUEST_METHOD IS NOT "post") OR (NOT locals.verification.post AND CGI.REQUEST_METHOD IS "post"))>
					<cfset locals.abort = true>
				</cfif>
				<cfif isBoolean(locals.verification.get) AND ((locals.verification.get AND CGI.REQUEST_METHOD IS NOT "get") OR (NOT locals.verification.get AND CGI.REQUEST_METHOD IS "get"))>
					<cfset locals.abort = true>
				</cfif>
				<cfif isBoolean(locals.verification.ajax) AND ((locals.verification.ajax AND CGI.REQUEST_METHOD IS NOT "XMLHTTPRequest") OR (NOT locals.verification.ajax AND CGI.REQUEST_METHOD IS "XMLHTTPRequest"))>
					<cfset locals.abort = true>
				</cfif>
				<cfif locals.verification.params IS NOT "">
					<cfloop list="#locals.verification.params#" index="locals.j">
						<cfif NOT structKeyExists(locals.params, locals.j)>
							<cfset locals.abort = true>
						</cfif>
					</cfloop>
				</cfif>
				<cfif locals.verification.session IS NOT "">
					<cfloop list="#locals.verification.session#" index="locals.j">
						<cflock scope="session" type="readonly" timeout="30">
							<cfif NOT structKeyExists(session, locals.j)>
								<cfset locals.abort = true>
							</cfif>
						</cflock>
					</cfloop>
				</cfif>
				<cfif locals.verification.cookie IS NOT "">
					<cfloop list="#locals.verification.cookie#" index="locals.j">
						<cfif NOT structKeyExists(cookie, locals.j)>
							<cfset locals.abort = true>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfif locals.abort>
				<cfif locals.verification.handler IS NOT "">
					<cfinvoke component="#locals.controller#" method="#locals.verification.handler#">
					<cflocation url="#CGI.HTTP_RFEFERER#" addtoken="false">
				<cfelse>
					<cfset request.wheels.response = "">
					<cfreturn request.wheels.response>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<!--- Call before filters on controller if they exist --->
	<cfset locals.beforeFilters = locals.controller._getBeforeFilters()>
	<cfif arrayLen(locals.beforeFilters) IS NOT 0>
		<cfloop from="1" to="#arraylen(locals.beforeFilters)#" index="locals.i">
			<cfif	(len(locals.beforeFilters[locals.i].only) IS 0 AND len(locals.beforeFilters[locals.i].except) IS 0) OR (len(locals.beforeFilters[locals.i].only) IS NOT 0 AND listFindNoCase(locals.beforeFilters[locals.i].only, locals.params.action)) OR (len(locals.beforeFilters[locals.i].except) IS NOT 0 AND NOT listFindNoCase(locals.beforeFilters[locals.i].except, locals.params.action))>
				<cfinvoke component="#locals.controller#" method="#locals.beforeFilters[locals.i].through#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.beforeFilters = getTickCount() - request.wheels.execution.components.beforeFilters>
		<cfset request.wheels.execution.components.action = getTickCount()>
	</cfif>

	<!--- Call action on controller if it exists --->
	<cfset locals.actionIsCachable = false>
	<cfif application.settings.cacheActions AND structIsEmpty(session.flash) AND structIsEmpty(form)>
		<cfset locals.cachableActions = locals.controller._getCachableActions()>
		<cfloop from="1" to="#arrayLen(locals.cachableActions)#" index="locals.i">
			<cfif locals.cachableActions[locals.i].action IS locals.params.action>
				<cfset locals.actionIsCachable = true>
				<cfset locals.timeToCache = locals.cachableActions[locals.i].time>
			</cfif>
		</cfloop>
	</cfif>

	<cfif locals.actionIsCachable>
		<cfset locals.category = "action">
		<cfset locals.key = "#CGI.SCRIPT_NAME#_#CGI.PATH_INFO#_#CGI.QUERY_STRING#">
		<cfset locals.lockName = locals.category & locals.key>
		<cflock name="#locals.lockName#" type="readonly" timeout="30">
			<cfset request.wheels.response = _getFromCache(locals.key, locals.category)>
		</cflock>
		<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
	   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
				<cfset request.wheels.response = _getFromCache(locals.key, locals.category)>
				<cfif isBoolean(request.wheels.response) AND NOT request.wheels.response>
					<cfset _callAction(locals.controller, locals.params.controller, locals.params.action)>
					<cfset _addToCache(locals.key, request.wheels.response, locals.timeToCache, locals.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset _callAction(locals.controller, locals.params.controller, locals.params.action)>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.action = getTickCount() - request.wheels.execution.components.action>
		<cfif structKeyExists(request.wheels.execution.components, "view")>
			<cfset request.wheels.execution.components.action = request.wheels.execution.components.action - request.wheels.execution.components.view>
		</cfif>
		<cfset request.wheels.execution.components.afterFilters = getTickCount()>
	</cfif>

	<cfset locals.afterFilters = locals.controller._getAfterFilters()>
	<cfif arrayLen(locals.afterFilters) IS NOT 0>
		<cfloop from="1" to="#arraylen(locals.afterFilters)#" index="locals.i">
			<cfif	(len(locals.afterFilters[locals.i].only) IS 0 AND len(locals.afterFilters[locals.i].except) IS 0) OR (len(locals.afterFilters[locals.i].only) IS NOT 0 AND listFindNoCase(locals.afterFilters[locals.i].only, locals.params.action)) OR (len(locals.afterFilters[locals.i].except) IS NOT 0 AND NOT listFindNoCase(locals.afterFilters[locals.i].except, locals.params.action))>
				<cfinvoke component="#locals.controller#" method="#locals.afterFilters[locals.i].through#">
			</cfif>
		</cfloop>
	</cfif>

	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.afterFilters = getTickCount() - request.wheels.execution.components.afterFilters>
	</cfif>

	<!--- Clear the flash (note that this is not done for redirectTo since the processing does not get here) --->
	<cflock scope="session" type="exclusive" timeout="30">
		<cfset structClear(session.flash)>
	</cflock>

	<cfreturn request.wheels.response>
</cffunction>


<cffunction name="_callAction" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="controllerName" type="any" required="true">
	<cfargument name="actionName" type="any" required="true">

	<cfif structKeyExists(arguments.controller, arguments.actionName)>
		<cfinvoke component="#arguments.controller#" method="#arguments.actionName#">
	</cfif>
	<cfif NOT structKeyExists(request.wheels, "response")>
		<!--- A render function has not been called yet so call it here --->
		<cftry>
			<cfset arguments.controller.renderPage()>
		<cfcatch>
			<cfif fileExists(expandPath("views/#arguments.controllerName#/#arguments.actionName#.cfm"))>
				<cfrethrow>
			<cfelse>
				<cfif application.settings.showErrorInformation>
					<cfthrow type="wheels" message="Could not find the view page for the <tt>#arguments.actionName#</tt> action in the <tt>#arguments.controllerName#</tt> controller" detail="Create a file named <tt>#arguments.actionName#.cfm</tt> in the <tt>views/#arguments.controllerName#</tt> directory (create the directory as well if necessary).">
				<cfelse>
					<cfinclude template="../../events/onmissingtemplate.cfm">
					<cfabort>
				</cfif>
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>

</cffunction>