<cffunction name="$init" returntype="any" access="public" output="false">
	<cfset variables.ParamsParser = $createObjectFromRoot(path="wheels", fileName="ParamsParser", method="init")>
	<cfreturn this>
</cffunction>

<cffunction name="$getPathFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfargument name="scriptName" type="string" required="true">
	<cfscript>
		var returnValue = "";
		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
			returnValue = "";
		else
			returnValue = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfargument name="sessionScope" type="struct" required="false" default="#session#">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// determine the path from the url, find a matching route for it and create the params struct
		loc.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
		loc.route = application.wheels.Router.search(route=loc.path);
		loc.params = variables.ParamsParser.create(path=loc.path, route=loc.route, formScope=arguments.formScope, urlScope=arguments.urlScope);

		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = loc.params;

		// create an empty flash unless it already exists
		if (!StructKeyExists(arguments.sessionScope, "flash"))
			arguments.sessionScope.flash = {};

		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		loc.controller.$processAction();

		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (StructKeyExists(request.wheels, "redirect"))
			$location(argumentCollection=request.wheels.redirect);

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		StructClear(arguments.sessionScope.flash);
	</cfscript>
	<cfreturn Trim(request.wheels.response)>
</cffunction>