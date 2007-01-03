<cfset variables._routes = arrayNew(1)>

<cffunction name="dispatch" returntype="any" access="remote" output="true">

	<cfset var local = structNew()>
	
	<cftry>
	
	<cftrace category="Wheels Dispatch Start"></cftrace>

	<!------ Routes -------->
	<cfset findRoute(url.wheels)>

	<!------ Params ------->
	<cfset setParams()>
	
	<!----- Flash notices ------->		
	<cfset setFlash()>
	
	<!------ Controller ------>
	<cftrace category="Wheels Create Controller Start"></cftrace>
	<cfset local.controller = createController()>
	<cftrace category="Wheels Create Controller End"></cftrace>

	<cftrace category="Wheels Before Filters & Events Start"></cftrace>
	<!--- Run event start functions --->
	<cfif structKeyExists(request.wheels, "run_on_application_start") AND structKeyExists(local.controller, "onApplicationStart")>
		<cfset local.controller.onApplicationStart()>
	</cfif>
	<cfif structKeyExists(local.controller, "onRequestStart")>
		<cfset local.controller.onRequestStart()>
	</cfif>

	<!------ beforeFilters ------>
	<cfif arrayLen(local.controller.getBeforeFilters()) IS NOT 0>
		<cfset callBeforeFilters(local.controller)>
	</cfif>
	<cftrace category="Wheels Before Filters & Events End"></cftrace>
	
	<!------ Action ------>
	<cftrace category="Wheels Call Action Start"></cftrace>
	<cfset callAction(local.controller)>
	
	<!--- 	
		When processing returns to this point, either the controller is done and is ready for the action to be run
		or the controller has called a render() (which went and called a different action/view already).  We check for this
		by looking to see if the buffer has ever been flushed (which means render() has NOT been called) or if there's 
		currently anything in it.  If not, render the action's view to the browser   
	--->
	
	<cfif NOT getPageContext().getResponse().isCommitted() AND len(trim(getPageContext().getOut().buffer)) IS 0>
		#local.controller.render(action=request.params.action)#
	</cfif>
	<cftrace category="Wheels Call Action End"></cftrace>
	
	<cftrace category="Wheels After Filters & Events Start"></cftrace>
	<!------ afterFilters ------>
	<cfif arrayLen(local.controller.getAfterFilters()) IS NOT 0>
		<cfset callAfterFilters(local.controller)>
	</cfif>
	
	<!--- Run event end functions --->
	<cfif structKeyExists(local.controller, "onRequestEnd")>
		<cfset local.controller.onRequestEnd()>
	</cfif>
	<cftrace category="Wheels After Filters & Events End"></cftrace>

	<!--- Clear the flash --->
	<cfset clearFlash()>
	
	<cftrace category="Wheels Dispatch End"></cftrace>
	
	<cfcatch>
		<cfif application.settings.environment IS "production">
			<cfif application.settings.error_email_address IS NOT "">
				<cfmail to="#application.settings.error_email_address#" from="#application.settings.error_email_address#" subject="#listLast(getDirectoryFromPath(getBaseTemplatePath()),'\')# error" type="html">
					<h1>Summary</h1>
					<ul>
						<li><strong>Error:</strong><br />#cfcatch.message#</li>
						<li><strong>URL:</strong><br />http://#CGI.server_name##CGI.script_name#?#CGI.query_string#</li>
						<li><strong>IP Address:</strong><br />#CGI.remote_addr#</li>
					</ul>					
					<h1>Error</h1>
					<ul>
					<cfloop collection="#cfcatch#" item="local.i">
						<cfif isSimpleValue(cfcatch[local.i]) AND local.i IS NOT "StackTrace" AND cfcatch[local.i] IS NOT "">
							<li><strong>#local.i#:</strong><br />#cfcatch[local.i]#</li>
						</cfif>
					</cfloop>
						<li><strong>Context:</strong><br />
						<cfloop index="local.i" from="1" to="#arrayLen(cfcatch.tagContext)#">
							Line #cfcatch.tagContext[local.i]["line"]# in #cfcatch.tagContext[local.i]["template"]#<br />
						</cfloop>
						</li>
					</ul>
					<cfset local.scopes = "CGI,Request,Form,URL,Session,Cookie">
					<cfloop list="#local.scopes#" index="local.i">
						<cfset local.this_scope = evaluate(local.i)>
						<cfif structCount(local.this_scope) GT 0>
							<h1>#local.i#</h1>
							<ul>
							<cfloop collection="#local.this_scope#" item="local.j">
								<cfif isSimpleValue(local.this_scope[local.j]) AND local.this_scope[local.j] IS NOT "">
									<li><strong>#local.j#:</strong><br />#local.this_scope[local.j]#</li>
								</cfif>
							</cfloop>
							</ul>					
						</cfif>
					</cfloop>
				</cfmail>
			</cfif>
			<cfinclude template="#application.pathTo.app#/error_production.cfm">
		<cfelse>
			<cfif structKeyExists(cfcatch, "type") AND cfcatch.type Contains "cfwheels">
				<cfinclude template="#application.pathTo.app#/error_development.cfm">
			<cfelse>
				<cfrethrow>			
			</cfif>
		</cfif>
	</cfcatch>
	</cftry>
	
	
</cffunction>


<cffunction name="createController" returntype="any" access="private" output="false">

	<cfset var local = structNew()>
	
	<cfset local.controller_name = "#application.componentPathTo.controllers#.#request.params.controller#_controller">
	
	<cfif application.settings.environment IS "development">
		<cfif fileExists(expandPath("/" & replace(local.controller_name, ".", "/", "all") & ".cfc"))>
			<cfset local.controller = createObject("component", local.controller_name)>
		<cfelse>
			<cfthrow type="cfwheels.controller_missing" message="There is no controller named ""#request.params.controller#"" in this application." detail="Create the ""#request.params.controller#_controller.cfc"" file manually in the ""app/controllers"" folder (it should extend ""cfwheels.controller"") or use the <a href=""#application.pathTo.generator#"">Generator</a>.">
		</cfif>
	<cfelseif application.settings.environment IS "production">
		<!---	If we're in production and there's an error then show a page not found --->
		<cftry>
			<cfset local.controller = createObject("component", local.controller_name)>
			<cfcatch>
				<cfinclude template="#application.templates.pageNotFound#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cfif>
	
	<!--- Initialize the controller and return it --->
	<cfreturn local.controller.init()>

</cffunction>


<cffunction name="callAction" returntype="any" access="private" output="true">
	<cfargument name="controller" type="any" required="yes">
	
	<!--- If this is development, check to see if the file exists --->
	<cfif structKeyExists(arguments.controller, request.params.action)>
		<cfset evaluate("arguments.controller.#request.params.action#()")>
	<cfelseif structKeyExists(arguments.controller, "methodMissing")>
		<cfset arguments.controller.methodMissing()>
	<cfelse>
		<cfif application.settings.environment IS "development">
			<cfthrow type="cfwheels.action_missing" message="There is no action named ""#request.params.action#"" in the ""#request.params.controller#"" controller" detail="Create a function called ""#request.params.action#"" in your controller, or create a function called ""methodMissing"" in your controller to handle requests to undefined actions.">
		<cfelseif application.settings.environment IS "production">
			<cfinclude template="#application.templates.pageNotFound#">
			<cfabort>
		</cfif>
	</cfif>

</cffunction>


<cffunction name="setFlash" returntype="any" access="private" output="false">

	<cfif NOT structKeyExists(session, "flash")>
		<cfset session.flash = structNew()>
	</cfif>
	<!--- Creates a pointer to session.flash so that when something is changed in request.flash it's also changed in session.flash --->
	<cfset request.flash = session.flash>

</cffunction>


<cffunction name="clearFlash" returntype="any" access="private" output="false">

	<cfset structClear(session.flash)>

</cffunction>


<cffunction name="callBeforeFilters" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="yes">

	<cfset var local = structNew()>
	
	<cfset local.before_filters = arguments.controller.getBeforeFilters()>
	
	<cfloop from="1" to="#arraylen(local.before_filters)#" index="local.i">
		<cfif	(local.before_filters[local.i].only IS "" AND local.before_filters[local.i].except IS "") OR
				(local.before_filters[local.i].only IS NOT "" AND listFindNoCase(local.before_filters[local.i].only, request.params.action)) OR
				(local.before_filters[local.i].except IS NOT "" AND NOT listFindNoCase(local.before_filters[local.i].except, request.params.action))>
			<cfset local.method_name = trim(local.before_filters[local.i].filter)>
			<!--- Add parenthesis to make this a real method call --->
			<cfif local.method_name Does Not Contain "(">
				<cfset local.method_name = local.method_name & "()">
			</cfif>
			<cfif structKeyExists(arguments.controller, "#spanExcluding(local.method_name, "(")#")>
				<cfset evaluate("arguments.controller.#local.method_name#")>
			<cfelse>
				<cfthrow type="cfwheels.beforeFilterMissing" message="There is no action called '#local.method_name#' which is trying to be called as a beforeFilter()" detail="Remove this action from your beforeFilter declaration, or create an action called '#request.params.action#' in your '#request.params.controller#' controller">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="callAfterFilters" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="yes">

	<cfset var local = structNew()>
	
	<cfset local.after_filters = arguments.controller.getAfterFilters()>
	
	<cfloop from="1" to="#arraylen(local.after_filters)#" index="local.i">
		<cfif	(local.after_filters[local.i].only IS "" AND local.after_filters[local.i].except IS "") OR
				(local.after_filters[local.i].only IS NOT "" AND listFindNoCase(local.after_filters[local.i].only, request.params.action)) OR
				(local.after_filters[local.i].except IS NOT "" AND NOT listFindNoCase(local.after_filters[local.i].except, request.params.action))>
			<cfset local.method_name = trim(local.after_filters[local.i].filter)>
			<!--- Add parenthesis to make this a real method call --->
			<cfif local.method_name Does Not Contain "(">
				<cfset local.method_name = local.method_name & "()">
			</cfif>
			<cfif structKeyExists(arguments.controller, "#spanExcluding(local.method_name, "(")#")>
				<cfset evaluate("arguments.controller.#local.method_name#")>
			<cfelse>
				<cfthrow type="cfwheels.afterFilterMissing" message="There is no action called '#local.method_name#' which is trying to be called as an afterFilter()" detail="Remove this action from your afterFilter declaration, or create the action">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="setParams" returntype="any" access="private" output="false">

	<cfset var local = structNew()>

	<cfset local.match = arrayNew(1)>
	<cfset local.temp_array = arrayNew(1)>
	<cfset local.dates_struct = structNew()>
	
	<!--- Sets what kind of request this was.  By default, it's a GET --->
	<cfset request.get = true>
	<cfset request.post = false>
	<cfset request.put = false>
	<cfset request.delete = false>
	<cfset request.xhr = false>
	<cfset request.current_request = url.wheels>
	
	<!--- Check to see if this is an XMLHttpRequest --->
	<cfif CGI.http_accept Contains "text/javascript">
		<cfset request.xhr = true>
	</cfif>
	
	<!--- Take any FORM variables and put them in params --->
	<cfif NOT structIsEmpty(form)>
		<cfloop collection="#form#" item="local.key">
			<!--- If a FORM variable contains brackets [] then it represents a model. Build a struct to hold the data, named after the model --->
			<cfset local.match = reFindNoCase("(.*?)\[(.*?)\]", local.key, 1, true)>
			
			<cfif arrayLen(local.match.pos) IS 3>
			
				<cfset local.model = lCase(mid(local.key, local.match.pos[2], local.match.len[2]))>
				<cfset local.field = lCase(mid(local.key, local.match.pos[3], local.match.len[3]))>
				
				<!--- Check to see if this field is part of a date --->
				<cfset local.match = reFindNoCase("(.*)\((.*)\)", local.field, 1, true)>
				
				<cfif arrayLen(local.match.pos) IS 3>
					<!--- date field --->
					<cfset local.date_field_name = lCase(mid(local.field, local.match.pos[2], local.match.len[2]))>
					<cfset local.date_field_part = left(mid(local.field, local.match.pos[3], local.match.len[3]),1)>
					<cfset local.date_field_value = form[local.key]>
					
					<cfif NOT structKeyExists(local.dates_struct, local.date_field_name)>
						<cfset local.dates_struct[local.date_field_name] = arrayNew(1)>
					</cfif>
					<cfset arraySet(local.dates_struct[local.date_field_name], local.date_field_part, local.date_field_part, local.date_field_value)>
				<cfelse>
					<!--- regular model-type field --->
					<cfif NOT structKeyExists(request.params, local.model)>
						<cfset request.params[local.model] = structNew()>
					</cfif>
					<!--- Should only happen if field does not contain a () --->
					<cfset request.params[local.model][local.field] = form[local.key]>
				</cfif>
				
			<cfelse>
				<!--- Just some random form field --->
				<cfset request.params[local.key] = form[local.key]>
			</cfif>
		</cfloop>
		
		<!--- If there are any date fields, figure them out --->
		<cfif NOT structIsEmpty(local.dates_struct)>
			<cfloop collection="#local.dates_struct#" item="local.key">
				<cfset local.this_date = "">
				<cfset local.temp_array = local.dates_struct[local.key]>
				<cfloop from="1" to="#arrayLen(local.temp_array)#" index="local.i">
					<cfswitch expression="#local.i#">
						<cfcase value="2,3">
							<cfset local.separator = "-">
						</cfcase>
						<cfcase value="4">
							<cfset local.separator = " ">
						</cfcase>
						<cfcase value="5,6">
							<cfset local.separator = ":">
						</cfcase>
						<cfdefaultcase>
							<cfset local.separator = "">
						</cfdefaultcase>
					</cfswitch>
					<cfset local.this_date = local.this_date & local.separator & local.temp_array[local.i]>
				</cfloop>
				<cfset request.params[local.model][local.key] = local.this_date>
			</cfloop>
		</cfif>
		
		<!--- If there are any FORM variables, this is a POST --->
		<cfset request.get = false>
		<cfset request.post = true>
	</cfif>
	
	<!--- Take any URL variables (except wheels and method) and put them in params 
		  If a FORM and URL variable are named the same, URL will win and go into params --->
	<cfloop collection="#url#" item="local.key">
		<cfif local.key IS NOT "method" AND local.key IS NOT "wheels">
			<cfset request.params[lCase(local.key)] = url[local.key]>
		</cfif>
	</cfloop>
	<!--- Set the default action if one isn't defined --->
	<cfif NOT structKeyExists(request.params, "action")>
		<cfset request.params.action = application.default.action>
	</cfif>
	

</cffunction>


<cffunction name="findRoute" returntype="any" access="private" output="false">
	<cfargument name="wheels" type="any" required="yes">
	
	<cfset var local = structNew()>

	<cfset local.request_string = arguments.wheels>
	<cfset local.route_params = arrayNew(1)>

	<!--- fix URL variables (IIS only) --->
	<cfif local.request_string Contains "?">
		<cfset local.var_match = REFind("\?.*=", local.request_string, 1, "true")>
		<cfset local.val_match = REFind("=.*$", local.request_string, 1, "true")>
		<cfset local.vari = Mid(local.request_string, (local.var_match.pos[1]+1), (local.var_match.len[1]-2))>
		<cfset local.vali = Mid(local.request_string, (local.val_match.pos[1]+1), (local.val_match.len[1]-1))>
		<cfset url[local.vari] = local.vali>
		<cfset local.request_string = Mid(local.request_string, 1, (local.var_match.pos[1]-1))>
	</cfif>
	
	<!--- Remove the leading slash in the request (if there was something more than just a slash to begin with) to match our routes --->
	<cfif len(local.request_string) GT 1>
		<cfset local.request_string = right(local.request_string,len(local.request_string)-1)>
	</cfif>
	<cfif right(local.request_string,1) IS NOT "/">
		<cfset local.request_string = local.request_string & "/">
	</cfif>
	
	<!--- Only include the routes if we're in development or in production but don't already have the variable --->
	<cfif application.settings.environment IS "development" OR (application.settings.environment IS "production" AND arrayLen(application.wheels.routes) IS 0)>
		<cfinclude template="#application.pathTo.config#/routes.ini">
		<cfset application.wheels.routes = duplicate(variables._routes)>
	</cfif>
	
	<!--- Compare route to URL --->
	<!--- For each route in /config/routes.cfm --->
	<cfloop from="1" to="#arrayLen(application.wheels.routes)#" index="local.i">
		<cfset arrayClear(local.route_params)>
		<cfset local.this_route = application.wheels.routes[local.i]>
		
		<!--- Add a trailing slash to ease pattern matching --->
		<cfif right(local.this_route.pattern,1) IS NOT "/">
			<cfset local.this_route.pattern = local.this_route.pattern & "/">
		</cfif>
	
		<!--- Replace any :parts with a regular expression for matching against the URL --->
		<cfset local.this_pattern = REReplace(local.this_route.pattern, ":.*?/", "(.+?)/", "all")>
		<!--- Try to match this route against the URL --->
		<cfset local.match = REFindNoCase(local.this_pattern, local.request_string, 1, true)>
		
		<!--- If a match was made, use the result to route the request --->
		<cfif local.match.len[1] IS NOT 0>
			<cfset local.found_route = local.this_route>
			
			<!--- For each part of the URL in the route --->
			<cfloop list="#local.this_route.pattern#" delimiters="/" index="local.i">
				<!--- if this part of the route pattern is a variable --->
				<cfif find(":", local.i)>
					<cfset arrayAppend(local.route_params, right(local.i, len(local.i)-1))>
				</cfif>
			</cfloop>
			
			<!--- And leave the loop 'cause we found our route --->
			<cfbreak>
		</cfif>
		
	</cfloop>
	
	<!--- Populate the params structure with the proper parts of the URL --->
	<cfloop from="1" to="#arrayLen(local.route_params)#" index="local.i">
		<cfset "request.params.#local.route_params[local.i]#" = mid(local.request_string, local.match.pos[local.i+1], local.match.len[local.i+1])>
	</cfloop>
	<!--- Now set the rest of the variables in the route --->
	<cfloop collection="#local.found_route#" item="local.i">
		<cfif local.i IS NOT "pattern">
			<cfset request.params[local.i] = local.found_route[local.i]>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="addRoute" returntype="any" access="private" output="false">
	<cfargument name="pattern" type="string" required="yes">
	
	<cfset var local = structNew()>
	
	<cfset local.this_route.pattern = arguments.pattern>
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "pattern">
			<cfset local.this_route[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>
	
	<cfset arrayAppend(variables._routes, local.this_route)>

</cffunction>
