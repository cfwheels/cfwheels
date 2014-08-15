<cffunction name="$processAction" returntype="boolean" access="public" output="false">
	<cfset var loc = {}>
	<!--- check if action should be cached and if so cache statically or set the time to use later when caching just the action --->
	<cfset loc.cache = 0>
	<cfif $hasCachableActions() && flashIsEmpty() && StructIsEmpty(form)>
		<cfset loc.cachableActions = $cachableActions()>
		<cfset loc.iEnd = ArrayLen(loc.cachableActions)>
		<cfloop from="1" to="#loc.iEnd#" index="loc.i">
			<cfif loc.cachableActions[loc.i].action eq params.action or loc.cachableActions[loc.i].action eq "*">
				<cfif loc.cachableActions[loc.i].static>
					<!--- the cfcache call is required to be directly in the processing file (see issue #332) --->
					<cfcache attributeCollection="#{action='serverCache', timeSpan=$timeSpanForCache(loc.cachableActions[loc.i].time), useQueryString=true}#">
				<cfelse>
					<cfset loc.cache = loc.cachableActions[loc.i].time>
				</cfif>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

	<cfscript>

		if (application.wheels.showDebugInformation)
		{
			$debugPoint("beforeFilters");
		}

		// run verifications if they exist on the controller
		$runVerifications(action=params.action, params=params);
		
		// return immediately if an abort is issued from a verification
		if ($abortIssued())
		{
			return true;
		}

		// run before filters if they exist on the controller
		$runFilters(type="before", action=params.action);

		if (application.wheels.showDebugInformation)
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
				loc.key = $hashedKey(variables.params);
				loc.lockName = loc.category & loc.key;
				loc.conditionArgs = {key=loc.key, category=loc.category};
				loc.executeArgs = {controller=params.controller, action=params.action, key=loc.key, time=loc.cache, category=loc.category};
				variables.$instance.response = $doubleCheckedLock(name=loc.lockName, condition="$getFromCache", execute="$callActionAndAddToCache", conditionArgs=loc.conditionArgs, executeArgs=loc.executeArgs);
			}
			if (!$performedRender())
			{
				// if we didn't render anything from a cached action we call the action here
				$callAction(action=params.action);
			}
		}

		// run after filters with surrounding debug points (don't run the filters if a delayed redirect will occur though)
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("action,afterFilters");
		}
		if (!$performedRedirect())
		{
			$runFilters(type="after", action=params.action);
		}
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("afterFilters");
		}
	</cfscript>
	<cfreturn true>
</cffunction>

<cffunction name="$callAction" returntype="void" access="public" output="false">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		if (!ListFindNoCase(application.wheels.protectedFunctions, arguments.action))
		{
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
				catch(Any e)
				{
					if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(variables.wheels.class.name)#/#LCase(arguments.action)#.cfm")))
					{
						$throw(object=e);
					}
					else
					{
						loc.error = true;
					}
				}
			}
		}
		else
		{
			loc.error = true;
		}
		if (StructKeyExists(loc, "error"))
		{
			if (application.wheels.showErrorInformation)
			{
				if (ListFindNoCase(application.wheels.protectedFunctions, arguments.action))
				{
					$throw(type="Wheels.ActionNotAllowed", message="You are not allowed to execute the `#arguments.action#` method as an action.", extendedInfo="Make sure your action does not have the same name as any of the built-in Wheels functions.");
				}
				else
				{
					$throw(type="Wheels.ViewNotFound", message="Could not find the view page for the `#arguments.action#` action in the `#variables.wheels.class.name#` controller.", extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(variables.wheels.class.name)#` directory (create the directory as well if it doesn't already exist).");
				}
			}
			else
			{
				$header(statusCode=404, statustext="Not Found");
				$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
				$abort();
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
		loc.returnValue = response();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
