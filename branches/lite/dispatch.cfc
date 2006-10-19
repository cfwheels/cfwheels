<cfcomponent>
	
	<cfset variables._routes = arrayNew(1)>

	<cffunction name="dispatch" access="remote" output="true">
		<cfset var methodName = "">
		<cfset var controllerName = "">
		<cfset var requestString = url.wheelsaction>
		<cfset var routes = arrayNew(1)>
		<cfset var routeParams = arrayNew(1)>
		<cfset var foundRoute = structNew()>
		<cfset var params = structNew()>
		<cfset var thisPattern = "">
		<cfset var thisRoute = structNew()>
		<cfset var routeFileLocation = "">
		<cfset var routeFileHash = "">
		<cfset var datesStruct = structNew()>
	
		<!---------------------->
		<!------ Routes -------->
		<!---------------------->
		
		<!--- fix URL variables (IIS only) --->
		<cfif url["wheelsaction"] CONTAINS "?">
			<cfset var_match = REFind("\?.*=", url["wheelsaction"], 1, "TRUE")>
			<cfset val_match = REFind("=.*$", url["wheelsaction"], 1, "TRUE")>
			<cfset var = Mid(url["wheelsaction"], (var_match.pos[1]+1), (var_match.len[1]-2))>
			<cfset val = Mid(url["wheelsaction"], (val_match.pos[1]+1), (val_match.len[1]-1))>
			<cfset "url.#var#" = val>
			<cfset url.wheelsaction = Mid(url["wheelsaction"], 1, (var_match.pos[1]-1))>
		</cfif>
		
		<!--- Remove the leading slash in the request (if there was something more than just a slash to begin with) to match our routes --->
		<cfif len(requestString) GT 1>
			<cfset requestString = right(url.wheelsaction,len(url.wheelsaction)-1)>
		</cfif>
		<cfif right(requestString,1) IS NOT "/">
			<cfset requestString = requestString & "/">
		</cfif>
		
		<!--- Only include the routes if we're in development, or in production but don't already have the variable --->
		<cfif application.settings.environment IS "development" OR (application.settings.environment IS "production" AND arrayLen(application.wheels.routes) IS 0)>
			<cfinclude template="#application.pathTo.config#/routes.cfm">
			<cfset application.wheels.routes = variables._routes>
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
		
		
		<!--------------------->
		<!------ Params ------->
		<!--------------------->
		
		<!--- Sets what kind of request this was.  By default, it's a GET --->
		<cfset request.get = true>
		<cfset request.post = false>
		<cfset request.put = false>
		<cfset request.delete = false>
		<cfset request.xhr = false>
		<cfset request.currentRequest = url.wheelsaction>
		
		<!--- Populate the params structure with the proper parts of the URL --->
		<cfloop from="1" to="#arrayLen(routeParams)#" index="i">
			<cfset "params.#routeParams[i]#" = mid(requestString,match.pos[i+1],match.len[i+1])>
		</cfloop>
		<!--- Now set the rest of the variables in the route --->
		<cfloop collection="#foundRoute#" item="key">
			<cfif key IS NOT "pattern">
				<cfset "params.#key#" = foundRoute[key]>
			</cfif>
		</cfloop>
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
						<cfif NOT structKeyExists(params,'#model#')>
							<cfset params[model] = structNew()>
						</cfif>
						<!--- Should only happen if field does not contain a () --->
						<cfset "params.#model#.#field#" = form[key]>
					
					</cfif>
					
				<cfelse>
				
					<!--- Just some random form field --->
					<cfset params[key] = form[key]>
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
					<cfset "params.#model#.#key#" = thisDate>
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
				<cfset "params.#lCase(key)#" = url[key]>
			</cfif>
		</cfloop>
		<!--- Set the default action if one isn't defined --->
		<cfif NOT structKeyExists(params,'action')>
			<cfset params.action = application.default.action>
		</cfif>
		
		<!--- Set the REQUEST scope to the value of the params --->
		<cfset request.params = duplicate(params)>
		<cfset params = "">
		
		<!---
		<!--- Send to index.cfm when no default route has been setup and the index.cfm file exists --->
		<cfif request.currentrequest IS "/" AND NOT structKeyExists(request.params'controller') AND fileExists('#application.absolutePathTo.webroot#index.cfm')>
			<cflocation url="/index.cfm" addtoken="No">
		</cfif>
		--->
		
		<!--------------------------->
		<!----- Flash notices ------->
		<!--------------------------->
		
		<cfif NOT structKeyExists(session,'flash')>
			<cfset session.flash = structNew()>
		</cfif>
		<!--- Creates a pointer to session.flash so that when something is changed in request.flash it's also changed in session.flash ---> 
		<cfset request.flash = session.flash>
		
		
		<!--------------------------->
		<!---- Controller/Action ---->
		<!--------------------------->
		
		<!--- Try to create an instance of the required controller --->
		<cfset controllerName = "#application.componentPathTo.controllers#.#request.params.controller#_controller">
		<cfif application.settings.environment IS "development">
			<cfif fileExists(expandPath(application.core.componentPathToFilePath(controllerName)&'.cfc'))>
				<cfset application.wheels.controllers[request.params.controller] = createObject("component",controllerName)>
			<cfelse>
				<cfthrow type="cfwheels.controllerMissing" message="There is no controller named '#request.params.controller#' in this application" detail="Use the <a href=""#application.pathTo.scripts#"">Generator</a> to create a controller!">
				<cfabort>
			</cfif>
		<cfelseif application.settings.environment IS "production">
			<!---	If we're in production, put the controller code into the application scope if it's not already there 
					If there's an error then show a page not found --->
			<cftry>
				<cfif NOT structKeyExists(application.wheels.controllers,request.params.controller)>
					<cfset application.wheels.controllers[request.params.controller] = createObject("component",controllerName)>
				</cfif>
				<cfcatch>
					<cfinclude template="#application.templates.pageNotFound#">
					<cfabort>
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- Get the instance of this controller --->
		<cfset Controller = application.wheels.controllers[request.params.controller]>
		
		<!--- Initialize the controller --->
		<cfset Controller.init()>
		
		<!--- Before Filters --->
		<cfif structKeyExists(Controller,'beforeFilters')>
			<cfloop index="i" from="1" to="#arraylen(Controller.beforeFilters)#">
				<cfif	(Controller.beforeFilters[i].only IS "" AND Controller.beforeFilters[i].except IS "") OR
						(Controller.beforeFilters[i].only IS NOT "" AND listFindNoCase(Controller.beforeFilters[i].only, request.params.action)) OR
						(Controller.beforeFilters[i].except IS NOT "" AND NOT listFindNoCase(Controller.beforeFilters[i].except, request.params.action))>
					<cfset methodName = trim(Controller.beforeFilters[i].filter)>
					<!--- Add parenthesis to make this a real method call --->
					<cfif methodName DOES NOT CONTAIN "(">
						<cfset methodName = methodName & "()">
					</cfif>
					<cfif structKeyExists(Controller,'#spanExcluding(methodName, "(")#')>
						<cfoutput><cfset evaluate("Controller.#methodName#")></cfoutput>
					<cfelse>
						<cfthrow type="cfwheels.beforeFilterMissing" message="There is no action called '#methodName#' which is trying to be called as a beforeFilter()" detail="Remove this action from your beforeFilter declaration, or create an action called '#request.params.action#' in your '#request.params.controller#' controller">
						<cfabort>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		
		<!--- Try to call the action --->
		<!--- If this is development, check to see if the file exists --->
		<cfif structKeyExists(Controller,request.params.action)>
			<cfoutput><cfset evaluate("Controller.#request.params.action#()")></cfoutput>
		<cfelseif structKeyExists(Controller,'methodMissing')>
			<cfoutput><cfset Controller.methodMissing()></cfoutput>
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
		
		<!--- 	
			When processing returns to this point, either the controller is done and is ready for the action to be run
			or the controller has called a render() (which went and called a different action already).  We check for this
			by looking to see if the buffer has ever been flushed (which means render() has NOT been called) or if there's 
			currently anything in it.  If not, call the proper action.  
		--->
		
		<cfif NOT getPageContext().getResponse().isCommitted() AND len(trim(getPageContext().getOut().buffer)) IS 0>
			<cfoutput>#Controller.render(action=request.params.action)#</cfoutput>
		</cfif>
		
		<!--- After Filters --->
		<cfif structKeyExists(Controller,'afterFilters')>
			<cfloop index="i" from="1" to="#arraylen(Controller.afterFilters)#">
				<cfif	(Controller.afterFilters[i].only IS "" AND Controller.afterFilters[i].except IS "") OR
						(Controller.afterFilters[i].only IS NOT "" AND listFindNoCase(Controller.afterFilters[i].only, request.params.action)) OR
						(Controller.afterFilters[i].except IS NOT "" AND NOT listFindNoCase(Controller.afterFilters[i].except, request.params.action))>
					<cfset methodName = trim(Controller.afterFilters[i].filter)>
					<cfif methodName DOES NOT CONTAIN "(">
						<cfset methodName = methodName & "()">
					</cfif>
					<cfif structKeyExists(Controller,'#spanExcluding(methodName, "(")#')>
						<cfoutput><cfset evaluate("Controller.#methodName#")></cfoutput>
					<cfelse>
						<cfthrow type="cfwheels.afterFilterMissing" message="There is no action called '#methodName#' which is trying to be called as an after filter" detail="Remove this action from your afterFilter declaration, or create the action">
						<cfabort>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Clear out the flash --->
		<cfset structClear(session.flash)>
		
	</cffunction>
	
	
	<cffunction name="route" access="private">
		<cfargument name="pattern" type="string" required="true">

		<cfset var thisRoute = structNew()>
		
		<cfset thisRoute.pattern = arguments.pattern>
		<cfloop collection="#arguments#" item="arg">
			<cfif arg IS NOT 'pattern'>
				<cfset thisRoute[arg] = arguments[arg]>
			</cfif>
		</cfloop>
		
		<cfset arrayAppend(variables._routes,thisRoute)>
	
	</cffunction>


</cfcomponent>