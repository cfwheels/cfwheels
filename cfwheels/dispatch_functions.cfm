<cffunction name="dispatch" access="remote" output="true" hint="Takes a request and calls the proper controller/action">
	<cfset var controller = "">
	
	<!--- If wheelsaction isn't present, we can't do anything --->
	<cfif NOT structKeyExists(url,'wheelsaction')>
		<cfthrow type="cfwheels.missingWheelsAction" message="There is no 'wheelsaction' variable present in the url" detail="This is most likely caused by a problem with URL rewriting. Check that your URL is being rewritten as '?wheelsaction=/the/original/url'">
		<cfabort>
	</cfif>

	<!------ Routes -------->
	<cfset findRoute(url.wheelsaction)>

	<!------ Params ------->
	<cfset setParams()>
	
	<!----- Flash notices ------->		
	<cfset setFlash()>
	
	<!------ Controller ------>
	<cfset controller = createController()>

	<!------ beforeFilters ------>
	<cfif arrayLen(controller.getBeforeFilters()) IS NOT 0>
		<cfset callBeforeFilters(controller)>
	</cfif>
	
	<!------ Action ------>
	<cfset callAction(controller)>
	
	<!--- 	
		When processing returns to this point, either the controller is done and is ready for the action to be run
		or the controller has called a render() (which went and called a different action/view already).  We check for this
		by looking to see if the buffer has ever been flushed (which means render() has NOT been called) or if there's 
		currently anything in it.  If not, render the action's view to the browser   
	--->
	
	<cfif NOT getPageContext().getResponse().isCommitted() AND len(trim(getPageContext().getOut().buffer)) IS 0>
		<cfoutput>#controller.render(action=request.params.action)#</cfoutput>
	</cfif>
	
	<!------ afterFilters ------>
	<cfif arrayLen(controller.getAfterFilters()) IS NOT 0>
		<cfset callAfterFilters(controller)>
	</cfif>
	
	<!--- Clear the flash --->
	<cfset clearFlash()>
	
</cffunction>


<cffunction name="createController" access="private" hint="Creates an instance of the required controller">

	<cfset var controllerName = "#application.componentPathTo.controllers#.#request.params.controller#_controller">
	<cfset var controller = "">
	
	<cfif application.settings.environment IS "development">
		<cfif fileExists(expandPath(application.core.componentPathToFilePath(controllerName)&'.cfc'))>
			<cfset controller = createObject("component",controllerName)>
		<cfelse>
			<cfthrow type="cfwheels.controllerMissing" message="There is no controller named '#request.params.controller#' in this application" detail="Use the <a href=""#application.pathTo.scripts#"">Generator</a> to create a controller!">
			<cfabort>
		</cfif>
	<cfelseif application.settings.environment IS "production">
		<!---	If we're in production and there's an error then show a page not found --->
		<cftry>
			<cfset controller = createObject("component",controllerName)>
			<cfcatch>
				<cfinclude template="#application.templates.pageNotFound#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cfif>
	
	<!--- Initialize the controller and return it --->
	<cfreturn controller.init()>

</cffunction>


<cffunction name="callAction" access="private" returntype="void" hint="Calls the action on a controller">
	<cfargument name="controller" required="true" type="any" hint="The controller to call actions on">
	
	<!--- If this is development, check to see if the file exists --->
	<cfif structKeyExists(arguments.controller,request.params.action)>
		<cfoutput><cfset evaluate("arguments.controller.#request.params.action#()")></cfoutput>
	<cfelseif structKeyExists(arguments.controller,'methodMissing')>
		<cfoutput><cfset arguments.controller.methodMissing()></cfoutput>
	<cfelse>
		<!--- <cfif NOT fileExists("#expandPath(application.pathTo.views)#/#request.params.controller#/#request.params.action#.cfm")> --->
			<cfif application.settings.environment IS "development">
				<cfthrow type="cfwheels.actionMissing" message="There is no action named '#request.params.action#' in the '#request.params.controller#' controller" detail="Create a function called '#request.params.action#' in your controller, or create an action called 'methodMissing()' in your controller to handle requests to undefined actions">
				<cfabort>
			<cfelseif application.settings.environment IS "production">
				<cfinclude template="#application.templates.pageNotFound#">
				<cfabort>
			</cfif>
		<!--- </cfif> --->
	</cfif>

</cffunction>


<cffunction name="setFlash" access="private" output="false" returntype="void" hint="Sets up the flash to persist between requests">

	<cfif NOT structKeyExists(session,'flash')>
		<cfset session.flash = structNew()>
	</cfif>
	<!--- Creates a pointer to session.flash so that when something is changed in request.flash
		  it's also changed in session.flash ---> 
	<cfset request.flash = session.flash>

</cffunction>


<cffunction name="clearFlash" access="private" output="false" returntype="void" hint="Clears out the flash (called at the end of a request)">

	<cfset structClear(session.flash)>

</cffunction>


<cffunction name="callBeforeFilters" access="private" returntype="void" hint="Calls the before filters in a controller">
	<cfargument name="controller" type="any" required="true" hint="The controller to call beforeFilters on">

	<cfset var beforeFilters = arguments.controller.getBeforeFilters()>
	<cfset var methodName = "">
	
	<cfloop index="i" from="1" to="#arraylen(beforeFilters)#">
		<cfif	(beforeFilters[i].only IS "" AND beforeFilters[i].except IS "") OR
				(beforeFilters[i].only IS NOT "" AND listFindNoCase(beforeFilters[i].only, request.params.action)) OR
				(beforeFilters[i].except IS NOT "" AND NOT listFindNoCase(beforeFilters[i].except, request.params.action))>
			<cfset methodName = trim(beforeFilters[i].filter)>
			<!--- Add parenthesis to make this a real method call --->
			<cfif methodName DOES NOT CONTAIN "(">
				<cfset methodName = methodName & "()">
			</cfif>
			<cfif structKeyExists(arguments.controller,'#spanExcluding(methodName, "(")#')>
				<cfoutput><cfset evaluate("arguments.controller.#methodName#")></cfoutput>
			<cfelse>
				<cfthrow type="cfwheels.beforeFilterMissing" message="There is no action called '#methodName#' which is trying to be called as a beforeFilter()" detail="Remove this action from your beforeFilter declaration, or create an action called '#request.params.action#' in your '#request.params.controller#' controller">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="callAfterFilters" access="private" returntype="void" hint="Calls the after filters in a controller">
	<cfargument name="controller" type="any" required="true" hint="The controller to call beforeFilters on">

	<cfset var afterFilters = arguments.controller.getAfterFilters()>
	<cfset var methodName = "">
	
	<cfloop index="i" from="1" to="#arraylen(afterFilters)#">
		<cfif	(afterFilters[i].only IS "" AND Controller.afterFilters[i].except IS "") OR
				(afterFilters[i].only IS NOT "" AND listFindNoCase(afterFilters[i].only, request.params.action)) OR
				(afterFilters[i].except IS NOT "" AND NOT listFindNoCase(afterFilters[i].except, request.params.action))>
			<cfset methodName = trim(afterFilters[i].filter)>
			<cfif methodName DOES NOT CONTAIN "(">
				<cfset methodName = methodName & "()">
			</cfif>
			<cfif structKeyExists(arguments.controller,'#spanExcluding(methodName, "(")#')>
				<cfoutput><cfset evaluate("arguments.controller.#methodName#")></cfoutput>
			<cfelse>
				<cfthrow type="cfwheels.afterFilterMissing" message="There is no action called '#methodName#' which is trying to be called as an afterFilter()" detail="Remove this action from your afterFilter declaration, or create the action">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="setParams" access="private" output="false" returntype="void" hint="Populates request.params with url and form variables">

	<cfset var match = arrayNew(1)>
	<cfset var model = "">
	<cfset var field = "">
	<cfset var dateFieldName = "">
	<cfset var dateFieldPart = "">
	<cfset var dateFieldValue = "">
	<cfset var datesStruct = structNew()>
	<cfset var thisDate = "">
	<cfset var tempArray = arrayNew(1)>
	<cfset var separator = "">
	<cfset var key = "">
	
	<!--- Sets what kind of request this was.  By default, it's a GET --->
	<cfset request.get = true>
	<cfset request.post = false>
	<cfset request.put = false>
	<cfset request.delete = false>
	<cfset request.xhr = false>
	<cfset request.currentRequest = url.wheelsaction>
	
	<!--- Check to see if this is an XMLHttpRequest --->
	<cfif cgi.http_accept CONTAINS "text/javascript">
		<cfset request.xhr = true>
	</cfif>
	
	<!--- Take any FORM variables and put them in params --->
	<cfif NOT structIsEmpty(form)>
		<cfloop collection="#form#" item="key">
			<!--- If a FORM variable contains brackets [] then it represents a model. Build a struct to hold the data, named after the model --->
			<cfset match = reFindNoCase("(.*?)\[(.*?)\]",key,1,true)>
			
			<cfif arrayLen(match.pos) IS 3>
			
				<cfset model = lCase(mid(key, match.pos[2], match.len[2]))>
				<cfset field = lCase(mid(key, match.pos[3], match.len[3]))>
				
				<!--- Check to see if this field is part of a date --->
				<cfset match = reFindNoCase("(.*)\((.*)\)",field,1,true)>
				
				<cfif arrayLen(match.pos) IS 3>
					<!--- date field --->
					<cfset dateFieldName = lCase(mid(field, match.pos[2], match.len[2]))>
					<cfset dateFieldPart = left(mid(field, match.pos[3], match.len[3]),1)>
					<cfset dateFieldValue = form[key]>
					
					<cfif NOT structKeyExists(datesStruct,'#dateFieldName#')>
						<cfset datesStruct[dateFieldName] = arrayNew(1)>
					</cfif>
					<cfset arraySet(datesStruct[dateFieldName],dateFieldPart,dateFieldPart,dateFieldValue)>
				<cfelse>
					<!--- regular model-type field --->
					<cfif NOT structKeyExists(request.params,'#model#')>
						<cfset request.params[model] = structNew()>
					</cfif>
					<!--- Should only happen if field does not contain a () --->
					<cfset request.params[model][field] = form[key]>
				</cfif>
				
			<cfelse>
				<!--- Just some random form field --->
				<cfset request.params[key] = form[key]>
			</cfif>
		</cfloop>
		
		<!--- If there are any date fields, figure them out --->
		<cfif NOT structIsEmpty(datesStruct)>
			<cfloop collection="#datesStruct#" item="key">
				<cfset thisDate = "">
				<cfset tempArray = datesStruct[key]>
				<cfloop from="1" to="#arrayLen(tempArray)#" index="i">
					<cfswitch expression="#i#">
						<cfcase value="2,3">
							<cfset separator = "-">
						</cfcase>
						<cfcase value="4">
							<cfset separator = " ">
						</cfcase>
						<cfcase value="5,6">
							<cfset separator = ":">
						</cfcase>
						<cfdefaultcase>
							<cfset separator = "">
						</cfdefaultcase>
					</cfswitch>
					<cfset thisDate = thisDate & separator & tempArray[i]>
				</cfloop>
				<cfset request.params[model][key] = thisDate>
			</cfloop>
		</cfif>
		
		<!--- If there are any FORM variables, this is a POST --->
		<cfset request.get = false>
		<cfset request.post = true>
	</cfif>
	
	<!--- Take any URL variables (except wheelsaction and method) and put them in params 
		  If a FORM and URL variable are named the same, URL will win and go into params --->
	<cfloop collection="#url#" item="key">
		<cfif key IS NOT "method" AND key IS NOT "wheelsaction">
			<cfset request.params[lCase(key)] = url[key]>
		</cfif>
	</cfloop>
	<!--- Set the default action if one isn't defined --->
	<cfif NOT structKeyExists(request.params,'action')>
		<cfset request.params.action = application.default.action>
	</cfif>
	

</cffunction>


<cffunction name="findRoute" access="private" output="false" returntype="void" hint="Figures out which route matches this request">
	<cfargument name="wheelsaction" type="string" required="true">
	
	<cfset var varMatch = "">
	<cfset var valMatch = "">
	<cfset var vari = "">
	<cfset var vali = "">
	<cfset var requestString = arguments.wheelsaction>
	<cfset var routeParams = arrayNew(1)>
	<cfset var thisRoute = structNew()>
	<cfset var thisPattern = "">
	<cfset var match = structNew()>
	<cfset var foundRoute = structNew()>
	<cfset var returnRoute = structNew()>
	<cfset var params = structNew()>
	<cfset var key = "">
	<cfset var i = "">

	<!--- fix URL variables (IIS only) --->
	<cfif requestString CONTAINS "?">
		<cfset varMatch = REFind("\?.*=", requestString, 1, "TRUE")>
		<cfset valMatch = REFind("=.*$", requestString, 1, "TRUE")>
		<cfset vari = Mid(requestString, (varMatch.pos[1]+1), (varMatch.len[1]-2))>
		<cfset vali = Mid(requestString, (valMatch.pos[1]+1), (valMatch.len[1]-1))>
		<cfset url[vari] = vali>
		<cfset requestString = Mid(requestString, 1, (var_match.pos[1]-1))>
	</cfif>
	
	<!--- Remove the leading slash in the request (if there was something more than just a slash to begin with) to match our routes --->
	<cfif len(requestString) GT 1>
		<cfset requestString = right(requestString,len(requestString)-1)>
	</cfif>
	<cfif right(requestString,1) IS NOT "/">
		<cfset requestString = requestString & "/">
	</cfif>
	
	<!--- Only include the routes if we're in development, or in production but don't already have the variable --->
	<cfif application.settings.environment IS "development" OR (application.settings.environment IS "production" AND arrayLen(application.wheels.routes) IS 0)>
		<cfinclude template="#application.pathTo.config#/routes.ini">
		<cfset application.wheels.routes = duplicate(variables._routes)>
	</cfif>
	
	<!--- Compare route to URL --->
	<!--- For each route in /config/routes.cfm --->
	<cfloop from="1" to="#arrayLen(application.wheels.routes)#" index="i">
		<cfset arrayClear(routeParams)>
		<cfset thisRoute = application.wheels.routes[i]>
		
		<!--- Add a trailing slash to ease pattern matching --->
		<cfif right(thisRoute.pattern,1) IS NOT "/">
			<cfset thisRoute.pattern = thisRoute.pattern & "/">
		</cfif>
	
		<!--- Replace any :parts with a regular expression for matching against the URL --->
		<cfset thisPattern = REReplace(thisRoute.pattern, ":.*?/", "(.+?)/", "all")>
		<!--- Try to match this route against the URL --->
		<cfset match = REFindNoCase(thisPattern,requestString,1,true)>
		
		<!--- If a match was made, use the result to route the request --->
		<cfif match.len[1] IS NOT 0>
			<cfset foundRoute = thisRoute>
			
			<!--- For each part of the URL in the route --->
			<cfloop list="#thisRoute.pattern#" delimiters="/" index="thisPattern">
				<!--- if this part of the route pattern is a variable --->
				<cfif find(":",thisPattern)>
					<cfset arrayAppend(routeParams,right(thisPattern,len(thisPattern)-1))>
				</cfif>
			</cfloop>
			
			<!--- And leave the loop 'cause we found our route --->
			<cfbreak>
		</cfif>
		
	</cfloop>
	
	<!--- Populate the params structure with the proper parts of the URL --->
	<cfloop from="1" to="#arrayLen(routeParams)#" index="i">
		<cfset "request.params.#routeParams[i]#" = mid(requestString,match.pos[i+1],match.len[i+1])>
	</cfloop>
	<!--- Now set the rest of the variables in the route --->
	<cfloop collection="#foundRoute#" item="key">
		<cfif key IS NOT "pattern">
			<cfset request.params[key] = foundRoute[key]>
		</cfif>
	</cfloop>

</cffunction>


<cffunction name="addRoute" access="private" hint="Adds a route to dispatch">
	<cfargument name="pattern" type="string" required="true" hint="The pattern to match against the URL">
	
	<cfset var thisRoute = structNew()>
	<cfset var arg = "">
	
	<cfset thisRoute.pattern = arguments.pattern>
	<cfloop collection="#arguments#" item="arg">
		<cfif arg IS NOT 'pattern'>
			<cfset thisRoute[arg] = arguments[arg]>
		</cfif>
	</cfloop>
	
	<cfset arrayAppend(variables._routes,thisRoute)>

</cffunction>
