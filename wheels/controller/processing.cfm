<cfscript>
	/**
	* PUBLIC FUNCTIONS
	*/

	public boolean function processAction() {
		// CSRF protection.
		$runCsrfProtection(action=params.action);

		// Check if action should be cached, and if so, cache statically or set the time to use later when caching just
		// the action.
		local.cache = 0;

		if (get("cacheActions") && $hasCachableActions() && flashIsEmpty() && StructIsEmpty(form)) {
			local.cachableActions = $cachableActions();

			for (local.action in local.cachableActions) {
				if (local.action.action == params.action || local.action.action == "*") {
					if (local.action.static) {
						local.timeSpan = $timeSpanForCache(local.action.time);
						$cache(action="serverCache", timeSpan=local.timeSpan, useQueryString=true);

						if (!$reCacheRequired()) {
							Abort;
						}
					}
					else {
						local.cache = local.action.time;
						local.appendToKey = local.action.appendToKey;
					}

					break;
				}
			}
		}

		if (get("showDebugInformation")) {
			$debugPoint("beforeFilters");
		}

		// Run verifications if they exist on the controller.
		$runVerifications(action=params.action, params=params);

		// Continue unless an abort is issued from a verification.
		if (!$abortIssued()) {
			// Run before filters if they exist on the controller.
			$runFilters(type="before", action=params.action);

			if (get("showDebugInformation")) {
				$debugPoint("beforeFilters,action");
			}

			// Only proceed to call the action if the before filter has not already rendered content.
			if (!$performedRenderOrRedirect()) {
				if (local.cache) {
					// Get content from the cache if it exists there and set it to the request scope. If not, the
					// $callActionAndAddToCache function will run, calling the controller action (which in turn sets the
					// content to the request scope).
					local.category = "action";

					// Create the key for the cache.
					local.key = $hashedKey(variables.$class.name, variables.params);

					// Evaluate variables and append to the cache key when specified.
					if (Len(local.appendToKey)) {
						for (local.item in local.appendToKey) {
							if (IsDefined(local.item)) {
								local.key &= Evaluate(local.item);
							}
						}
					}

					local.conditionArgs = {};
					local.conditionArgs.key = local.key;
					local.conditionArgs.category = local.category;
					local.executeArgs = {};
					local.executeArgs.controller = params.controller;
					local.executeArgs.action = params.action;
					local.executeArgs.key = local.key;
					local.executeArgs.time = local.cache;
					local.executeArgs.category = local.category;
					local.lockName = local.category & local.key & application.applicationName;

					variables.$instance.response = $doubleCheckedLock(
						name=local.lockName,
						condition="$getFromCache",
						execute="$callActionAndAddToCache",
						conditionArgs=local.conditionArgs,
						executeArgs=local.executeArgs
					);
				}

				if (!$performedRender()) {
					// If we didn't render anything from a cached action, we call the action here.
					$callAction(action=params.action);
				}
			}

			// Run after filters with surrounding debug points. (Don't run the filters if a delayed redirect will occur
			// though.)
			if (get("showDebugInformation")) {
				$debugPoint("action,afterFilters");
			}

			if (!$performedRedirect()) {
				$runFilters(type="after", action=params.action);
			}

			if (get("showDebugInformation")) {
				$debugPoint("afterFilters");
			}
		}

		return true;
	}

	/**
	* PRIVATE FUNCTIONS
	*/
	public void function $callAction(required string action) {
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
			local.invokeArgs = {};
			local.invokeArgs.missingMethodName = arguments.action;
			local.invokeArgs.missingMethodArguments = {};
			$invoke(method="onMissingMethod", invokeArgs=local.invokeArgs);
		}
		if (!$performedRenderOrRedirect())
		{
			try
			{
				renderPage();
			}
			catch (any e)
			{
				local.file = get("viewPath") & "/" & LCase(ListChangeDelims(variables.$class.name, '/', '.')) & "/" & LCase(arguments.action) & ".cfm";
				if (FileExists(ExpandPath(local.file)))
				{
					$throw(object=e);
				}
				else
				{
					if (get("showErrorInformation"))
					{
						$throw(
							type="Wheels.ViewNotFound",
							message="Could not find the view page for the `#arguments.action#` action in the `#variables.$class.name#` controller.",
							extendedInfo="Create a file named `#LCase(arguments.action)#.cfm` in the `views/#LCase(ListChangeDelims(variables.$class.name, '/', '.'))#` directory (create the directory as well if it doesn't already exist)."
						);
					}
					else
					{
						$header(statusCode=404, statustext="Not Found");
						local.template = get("eventPath") & "/onmissingtemplate.cfm";
						$includeAndOutput(template=local.template);
						$abort();
					}
				}
			}
		}
	}

	public string function $callActionAndAddToCache(
		required string action,
		required numeric time,
		required string key,
		required string category
	) {
		$callAction(action=arguments.action);
		$addToCache(key=arguments.key, value=variables.$instance.response, time=arguments.time, category=arguments.category);
		local.rv = response();
		return local.rv;
	}
</cfscript>
