<cffunction name="onRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		// abort if called from incorrect file
		$abortInvalidRequest();

		// reload application by calling onApplicationStart if requested
		if (StructKeyExists(URL, "reload") && (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "reloadPassword") || !Len(application.wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.wheels.reloadPassword)))
			$simpleLock(execute="onApplicationStart", name="wheelsReloadLock", type="exclusive");
		$simpleLock(execute="$runOnRequestStart", executeArgs=arguments, name="wheelsReloadLock", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="$runOnRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		if (application.wheels.environment == "maintenance")
		{
			if (StructKeyExists(URL, "except"))
				application.wheels.ipExceptions = URL.except;
			if (!Len(application.wheels.ipExceptions) || !ListFind(application.wheels.ipExceptions, cgi.remote_addr))
			{
				$includeAndOutput(template="#application.wheels.eventPath#/onmaintenance.cfm");
				$abort();
			}
		}
		if (Right(arguments.targetPage, 4) == ".cfc")
		{
			StructDelete(this, "onRequest");
			StructDelete(variables, "onRequest");
		}
		request.wheels = {};
		request.wheels.params = {};
		request.wheels.cache = {};
		if(get("environment") neq "production")
			request.wheels.deprecation = [];
		if (application.wheels.showDebugInformation)
			$debugPoint("total,requestStart");
		if (!application.wheels.cacheModelInitialization)
			StructClear(application.wheels.models);
		if (!application.wheels.cacheControllerInitialization)
			StructClear(application.wheels.controllers);
		if (!application.wheels.cacheRoutes)
		{
			ArrayClear(application.wheels.routes);
			StructClear(application.wheels.namedRoutePositions);
			$include(template="#application.wheels.configPath#/routes.cfm");
			$include(template="wheels/events/onapplicationstart/routes.cfm");
		}
		if (!application.wheels.cacheDatabaseSchema)
			$clearCache("sql");
		if (!application.wheels.cacheFileChecking)
		{
			application.wheels.existingControllerFiles = "";
			application.wheels.nonExistingControllerFiles = "";
			application.wheels.existingLayoutFiles = "";
			application.wheels.nonExistingLayoutFiles = "";
			application.wheels.existingHelperFiles = "";
			application.wheels.nonExistingHelperFiles = "";
		}
		$include(template="#application.wheels.eventPath#/onrequeststart.cfm");
		if (application.wheels.showDebugInformation)
			$debugPoint("requestStart");
	</cfscript>
</cffunction>