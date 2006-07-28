<!---
   Copyright 2006 Rob Cameron

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cftrace text="dispatch.cfc - START">

<!---------------------->
<!------ Routes -------->
<!---------------------->

<!--- fix URL variables (IIS only) --->
<cfif url["cf_request"] Contains "?">
	<cfset var_match = REFind("\?.*=", url["cf_request"], 1, "TRUE")>
	<cfset val_match = REFind("=.*$", url["cf_request"], 1, "TRUE")>
	<cfset var = Mid(url["cf_request"], (var_match.pos[1]+1), (var_match.len[1]-2))>
	<cfset val = Mid(url["cf_request"], (val_match.pos[1]+1), (val_match.len[1]-1))>
	<cfset "url.#var#" = val>
	<cfset url.cf_request = Mid(url["cf_request"], 1, (var_match.pos[1]-1))>
</cfif>

<!--- Remove the leading slash in the request (if there was something more than just a slash to begin with) to match our routes --->
<cfif len(requestString) GT 1>
	<cfset requestString = right(url.cf_request,len(url.cf_request)-1)>
</cfif>
<cfif right(requestString,1) IS NOT "/">
	<cfset requestString = requestString & "/">
</cfif>

<!--- Hash the file to see if it's changed --->
<cfset routeFileLocation = expandPath(application.pathTo.config) & "/routes.cfm">
<cffile action="read" file="#routeFileLocation#" variable="routeFile">
<cfset routeFileHash = hash(routeFile)>

<cfif NOT isDefined('application.routes.hash') OR application.routes.hash IS NOT routeFileHash>
	<!--- Re-read file and parse apart routes --->
	<cfinclude template="#application.pathTo.config#/routes.cfm">
	
	<cfset application.routes.theRoutes = arrayNew(1)>
	<cfset application.routes.theRoutes = routes>
	
	<!--- Set the has to the current file --->
	<cfset application.routes.hash = routeFileHash>
	
	<cftrace text="Rewrote application.routes.hash">
</cfif>

<!--- Compare route to URL --->
<!--- For each route in /config/routes.cfm --->
<cfloop from="1" to="#arrayLen(application.routes.theRoutes)#" index="i">
	<cfset arrayClear(routeParams)>
	<cfset thisRoute = application.routes.theRoutes[i]>
	
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
<cfset request.xhr = false>
<cfset request.currentRequest = url.cf_request>

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
				
				<cfif NOT isDefined('datesStruct.#dateFieldName#')>
					<cfset datesStruct[dateFieldName] = arrayNew(1)>
				</cfif>
				<cfset arraySet(datesStruct[dateFieldName],dateFieldPart,dateFieldPart,dateFieldValue)>

			<cfelse>
			
			<!--- regular model-type field --->
				<cfif NOT isDefined("params.#model#")>
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

<!--- Take any URL variables (except cf_request and method) and put them in params 
	  If a FORM and URL variable are named the same, URL will win and go into params --->
<cfloop collection="#url#" item="key">
	<cfif key IS NOT "method" AND key IS NOT "cf_request">
		<cfset "params.#lCase(key)#" = url[key]>
	</cfif>
</cfloop>
<!--- Set the default action if one isn't defined --->
<cfif NOT isDefined('params.action')>
	<cfset params.action = application.default.action>
</cfif>

<!--- Set the REQUEST scope to the value of the params --->
<cfset request.params = duplicate(params)>

<!--- Send to index.cfm when no default route has been setup and the index.cfm file exists (IIS only) --->
<cfif request.currentrequest IS "/" AND NOT isDefined("request.params.controller") AND fileExists(application.pathTo.webroot&'index.cfm')>
	<cflocation url="/index.cfm" addtoken="No">
</cfif>

<cftrace text="dispatch.cfc - After params">


<!--------------------------->
<!----- Flash notices ------->
<!--------------------------->

<cfif NOT isDefined('session.flash')>
	<cfset session.flash = structNew()>
</cfif>
<!--- Creates a pointer to session.flash so that when something is changed in request.flash it's also changed in session.flash ---> 
<cfset request.flash = session.flash>


<!--------------------------->
<!---- Controller/Action ---->
<!--------------------------->

<!--- Try to create an instance of the required controller --->
<!--- If this is development, check to see if the file exists --->
<cfset controllerName = "#application.componentPathTo.controllers#.#request.params.controller#_controller">
<cfif application.settings.environment IS "development">
	<cfif fileExists(expandPath(core.componentPathToFilePath(controllerName)&'.cfc'))>
		<cfobject component="#controllerName#" name="Controller">
	<cfelse>
		<cfthrow type="cfwheels.controllerMissing" message="There is no controller named '#request.params.controller#' in this application" detail="Use the Wheels Generator to create a controller!">
		<cfabort>
	</cfif>
<cfelse>
	<cfobject component="#controllerName#" name="Controller">
</cfif>

<!--- Initialize the controller --->
<cfset Controller.init()>

<cftrace text="dispatch.cfc - After controller creation">

<!--- Before Filters --->
<cfif isDefined('Controller.beforeFilters')>
	<cfloop index="i" from="1" to="#arraylen(Controller.beforeFilters)#">
		<cfif	(Controller.beforeFilters[i].only IS "" AND Controller.beforeFilters[i].except IS "") OR
				(Controller.beforeFilters[i].only IS NOT "" AND listFindNoCase(Controller.beforeFilters[i].only, request.params.action)) OR
				(Controller.beforeFilters[i].except IS NOT "" AND NOT listFindNoCase(Controller.beforeFilters[i].except, request.params.action))>
			<cfset methodName = trim(Controller.beforeFilters[i].filter)>
			<cfif methodName Does NOT Contain "(">
				<cfset methodName = methodName & "()">
			</cfif>
			<cfif isDefined('Controller.#spanExcluding(methodName, "(")#')>
				<cfoutput><cfset evaluate("Controller.#methodName#")></cfoutput>
			<cfelse>
				<cfthrow type="cfwheels.beforeFilterMissing" message="There is no action called '#methodName#' which is trying to be called as a before filter" detail="Remove this action from your beforeFilter declaration, or create the action">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cftrace text="dispatch.cfc - After Before Filters">

<!--- Try to call the action --->
<!--- If this is development, check to see if the file exists --->
<cfif isDefined('Controller.#request.params.action#')>
	<cfoutput><cfset evaluate("Controller.#request.params.action#()")></cfoutput>
<cfelseif application.settings.environment IS "development">
	<cfif NOT fileExists("#expandPath(application.pathTo.views)#/#request.params.controller#/#request.params.action#.cfm")>
		<cfthrow type="cfwheels.actionMissing" message="There is no action named '#request.params.action#' in the '#request.params.controller#' controller" detail="Create a function called '#request.params.action#' in your controller, or create an action called 'methodMissing()' in your controller to handle requests to undefined actions">
		<cfabort>		
	</cfif>
</cfif>

<cftrace text="dispatch.cfc - After action call">

<!--- 	
	When processing returns to this point, either the controller is done and is ready for the action to be run
	or the controller has called a render() (which went and called a different action already).  We check for this
	by looking to see if the buffer has ever been flushed (which means render() has NOT been called) or if there's 
	currently anything in it.  If not, call the proper action.  
--->

<cfif NOT getPageContext().getResponse().isCommitted() AND len(trim(getPageContext().getOut().buffer)) IS 0>
	<cfoutput>#Controller.render(action=request.params.action)#</cfoutput>
</cfif>

<cftrace text="dispatch.cfc - After render()">

<!--- After Filters --->
<cfif isDefined('Controller.afterFilters')>
	<cfloop index="i" from="1" to="#arraylen(Controller.afterFilters)#">
		<cfif	(Controller.afterFilters[i].only IS "" AND Controller.afterFilters[i].except IS "") OR
				(Controller.afterFilters[i].only IS NOT "" AND listFindNoCase(Controller.afterFilters[i].only, request.params.action)) OR
				(Controller.afterFilters[i].except IS NOT "" AND NOT listFindNoCase(Controller.afterFilters[i].except, request.params.action))>
			<cfset methodName = trim(Controller.afterFilters[i].filter)>
			<cfif methodName Does NOT Contain "(">
				<cfset methodName = methodName & "()">
			</cfif>
			<cfif isDefined('Controller.#spanExcluding(methodName, "(")#')>
				<cfoutput><cfset evaluate("Controller.#methodName#")></cfoutput>
			<cfelse>
				<cfthrow type="cfwheels.afterFilterMissing" message="There is no action called '#methodName#' which is trying to be called as an after filter" detail="Remove this action from your afterFilter declaration, or create the action">
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cftrace text="dispatch.cfc - After After Filters">

<!--- Clear out the flash --->
<cfset structClear(session.flash)>

<cftrace text="dispatch.cfc - END">
