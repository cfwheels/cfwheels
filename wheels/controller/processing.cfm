<!--- PRIVATE FUNCTIONS --->

<cffunction name="$processAction" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};

		// check if action should be cached and if so cache statically or set the time to use later when caching just the action
		loc.cache = 0;
		if ($hasCachableActions() && flashIsEmpty() && StructIsEmpty(form))
		{
			loc.cachableActions = $cachableActions();
			loc.iEnd = ArrayLen(loc.cachableActions);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (loc.cachableActions[loc.i].action == params.action || loc.cachableActions[loc.i].action == "*")
				{
					if (loc.cachableActions[loc.i].static)
					{
						loc.timeSpan = $timeSpanForCache(loc.cachableActions[loc.i].time);
						$cache(action="serverCache", timeSpan=loc.timeSpan, useQueryString=true);
						if (!$reCacheRequired())
						{
							$abort();
						}
					}
					else
					{
						loc.cache = loc.cachableActions[loc.i].time;
						loc.appendToKey = loc.cachableActions[loc.i].appendToKey;
					}
					break;
				}
			}
		}

		if (get("showDebugInformation"))
		{
			$debugPoint("beforeFilters");
		}

		// run verifications if they exist on the controller
		$runVerifications(action=params.action, params=params);

		// continue unless an abort is issued from a verification
		if (!$abortIssued())
		{
			// run before filters if they exist on the controller
			$runFilters(type="before", action=params.action);

			if (get("showDebugInformation"))
			{
				$debugPoint("beforeFilters,action");
			}

			// only proceed to call the action if the before filter has not already rendered content
			if (!$performedRenderOrRedirect())
			{
				if (loc.cache)
				{
					// get content from the cache if it exists there and set it to the request scope, if not the $callActionAndAddToCache function will run, calling the controller action (which in turn sets the content to the request scope)
					loc.category = "action";

					// create the key for the cache
					loc.key = $hashedKey(variables.$class.name, variables.params);

					// evaluate variables and append to the cache key when specified
					if (Len(loc.appendToKey))
					{
						loc.iEnd = ListLen(loc.appendToKey);
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							loc.item = ListGetAt(loc.appendToKey, loc.i);
							if (IsDefined(loc.item))
							{
								loc.key &= Evaluate(loc.item);
							}
						}
					}

					loc.conditionArgs = {};
					loc.conditionArgs.key = loc.key;
					loc.conditionArgs.category = loc.category;
					loc.executeArgs = {};
					loc.executeArgs.controller = params.controller;
					loc.executeArgs.action = params.action;
					loc.executeArgs.key = loc.key;
					loc.executeArgs.time = loc.cache;
					loc.executeArgs.category = loc.category;
					loc.lockName = loc.category & loc.key & application.applicationName;
					variables.$instance.response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
				}
				if (!$performedRender())
				{
					// if we didn't render anything from a cached action we call the action here
					$callAction(action=params.action);
				}
			}

			// run after filters with surrounding debug points (don't run the filters if a delayed redirect will occur though)
			if (get("showDebugInformation"))
			{
				$debugPoint("action,afterFilters");
			}
			if (!$performedRedirect())
			{
				$runFilters(type="after", action=params.action);
			}
			if (get("showDebugInformation"))
			{
				$debugPoint("afterFilters");
			}
		}
		loc.rv = true;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Left(arguments.action, 1) == "$" || ListFindNoCase(application.wheels.protectedControllerMethods, arguments.action))
		{
			$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.action#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in CFWheels functions.");
		}
		if (StructKeyExists(this, arguments.action) && IsCustomFunction(this[arguments.action]))
		{
			$invoke(method=arguments.action);
		}
		else if (StructKeyExists(this, "onMissingMethod"))
		{
			loc.invokeArgs = {};
			loc.invokeArgs.missingMethodName = arguments.action;
			loc.invokeArgs.missingMethodArguments = {};
			$invoke(method="onMissingMethod", invokeArgs=loc.invokeArgs);
		}
		if (!$performedRenderOrRedirect())
		{
			try
			{
				renderPage();
			}
			catch (any e)
			{
				loc.file = get("viewPath") & "/" & LCase(variables.$class.name) & "/" & LCase(arguments.action) & ".cfm";
				if (FileExists(ExpandPath(loc.file)))
				{
					$throw(object=e);
				}
				else
				{
					if (get("showErrorInformation"))
					{
						$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.action#` action in the `#variables.$class.name#` controller.", extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(variables.$class.name)#` directory (create the directory as well if it doesn't already exist).");
					}
					else
					{
						$header(statusCode=404, statustext="Not Found");
						loc.template = get("eventPath") & "/onmissingtemplate.cfm";
						$includeAndOutput(template=loc.template);
						$abort();
					}
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$callActionAndAddToCache" returntype="string" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfargument name="time" type="numeric" required="true">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="true">
	<cfscript>
		var loc = {};
		$callAction(action=arguments.action);
		$addToCache(key=arguments.key, value=variables.$instance.response, time=arguments.time, category=arguments.category);
		loc.rv = response();
	</cfscript>
	<cfreturn loc.rv>
</cffunction>