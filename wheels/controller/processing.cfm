<cffunction name="$processAction" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.debug = application.wheels.showDebugInformation;
		if (loc.debug)
			$debugPoint("beforeFilters");
		// run verifications and before filters if they exist on the controller
		this.$runVerifications(action=params.action, params=params);
		this.$runFilters(type="before", action=params.action);
		
		// check to see if the controller params has changed and if so, instantiate the new controller and re-run filters and verifications
		if (params.controller != this.controllerName())
		{
			this = $controller(params.controller).$createControllerObject(params);
			if (loc.debug)
				$debugPoint("beforeFilters");
			this.$processAction();
			return;
		}
		
		if (loc.debug)
			$debugPoint("beforeFilters,action");

		// only proceed to call the action if the before filter has not already rendered content
		if (!$performedRenderOrRedirect())
		{
			// call action on controller if it exists
			loc.actionIsCachable = false;
			if ($hasCachableActions() && flashIsEmpty() && StructIsEmpty(form))
			{
				loc.cachableActions = $cachableActions();
				loc.iEnd = ArrayLen(loc.cachableActions);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if (loc.cachableActions[loc.i].action == params.action || loc.cachableActions[loc.i].action == "*")
					{
						loc.actionIsCachable = true;
						loc.time = loc.cachableActions[loc.i].time;
						loc.static = loc.cachableActions[loc.i].static;
					}
				}
			}
			if (loc.actionIsCachable)
			{
				loc.category = "action";
				loc.key = $cacheKey();
				loc.lockName = loc.category & loc.key;
				loc.conditionArgs = {};
				loc.conditionArgs.key = loc.key;
				loc.conditionArgs.category = loc.category;
				loc.executeArgs = {};
				loc.executeArgs.controller = loc.controller;
				loc.executeArgs.action = params.action;
				loc.executeArgs.key = loc.key;
				loc.executeArgs.time = loc.time;
				loc.executeArgs.static = loc.static;
				loc.executeArgs.category = loc.category;
				// get content from the cache if it exists there and set it to the request scope, if not the $callActionAndAddToCache function will run, caling the controller action (which in turn sets the content to the request scope)
				variables.wheels.$response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
			}
			else
			{
				$callAction(action=params.action);
			}
		}

		// run after filters with surrounding debug points (don't run the filters if a delayed redirect will occur though)
		if (loc.debug)
			$debugPoint("action,afterFilters");
		if (!$performedRedirect())
			$runFilters(type="after", action=params.action);
		if (loc.debug)
			$debugPoint("afterFilters");
	</cfscript>
	<cfreturn />
</cffunction>

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};

		if (Left(arguments.action, 1) == "$" || ListFindNoCase(application.wheels.protectedControllerMethods, arguments.action))
			$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.action#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in Wheels functions.");

		if (StructKeyExists(this, arguments.action) && IsCustomFunction(this[arguments.action]))
		{
			$invoke(method=arguments.action);
		}
		else if (StructKeyExists(this, "onMissingMethod"))
		{
			loc.argumentCollection = {};
			loc.argumentCollection.missingMethodName = arguments.action;
			loc.argumentCollection.missingMethodArguments = {};
			$invoke(method="onMissingMethod", argumentCollection=loc.argumentCollection);
		}

		if (!$performedRenderOrRedirect())
		{
			try
			{
				renderPage();
			}
			catch(Any e)
			{
				if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.wheels.name)#/#LCase(arguments.action)#.cfm")))
				{
					$throw(object=e);
				}
				else
				{
					if (application.wheels.showErrorInformation)
					{
						$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.action#` action in the `#variables.wheels.name#` controller.", extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(variables.wheels.name)#` directory (create the directory as well if it doesn't already exist).");
					}
					else
					{
						$header(statusCode="404", statusText="Not Found");
						$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
						$abort();
					}
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$callActionAndAddToCache" returntype="string" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfargument name="static" type="boolean" required="true">
	<cfargument name="time" type="numeric" required="true">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="true">
	<cfscript>
		$callAction(action=arguments.action);
		if (arguments.static)
			$cache(cache="serverCache", timeSpan=CreateTimeSpan(0,0,arguments.time,0));
		else
			$addToCache(key=arguments.key, value=variables.wheels.$response, time=arguments.time, category=arguments.category);
	</cfscript>
	<cfreturn $getResponse()>
</cffunction>