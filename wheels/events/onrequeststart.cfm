<cffunction name="onRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		// abort if called from incorrect file
		$abortInvalidRequest();

		// need to setup the wheels struct here since it's used to store debugging info below if this is a reload request
		request.wheels = {};

		// reload application by calling onApplicationStart if requested
		if (StructKeyExists(URL, "reload") && (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "reloadPassword") || !Len(application.wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.wheels.reloadPassword)))
		{
			$debugPoint("total,reload");
			$simpleLock(execute="onApplicationStart", name="wheelsReloadLock", type="exclusive");
		}

		// run the rest of the request start code
		$simpleLock(execute="$runOnRequestStart", executeArgs=arguments, name="wheelsReloadLock", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="$runOnRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		var loc = {};
	
		if (application.wheels.showDebugInformation)
		{
			// if the first debug point has not already been set in a reload request we set it here
			if (StructKeyExists(request.wheels, "execution"))
				$debugPoint("reload");
			else
				$debugPoint("total");
			$debugPoint("requestStart");
			request.wheels.deprecation = [];
		}
		if (application.wheels.environment == "maintenance")
		{
			if (StructKeyExists(URL, "except"))
				application.wheels.ipExceptions = URL.except;
			if (!Len(application.wheels.ipExceptions) || !ListFind(application.wheels.ipExceptions, request.cgi.remote_addr))
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
		request.wheels.params = {};
		request.wheels.cache = {};
		
		if (!StructKeyExists(request, "cgi"))
			request.cgi = Duplicate(cgi);
	
		loc.iEnd = ArrayLen(application.wheels.cgi);
		for (loc.i=1; loc.i lte loc.iEnd; loc.i++)
			request.cgi[application.wheels.cgi[loc.i]] = cgi[application.wheels.cgi[loc.i]];

		if (!application.wheels.cacheModelInitialization)
			StructClear(application.wheels.models);
		if (!application.wheels.cacheControllerInitialization)
			StructClear(application.wheels.controllers);
		if (!application.wheels.cacheRoutes)
		{
			ArrayClear(application.wheels.routes);
			StructClear(application.wheels.namedRoutePositions);
			$include(template="wheels/plugins/injection.cfm");
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