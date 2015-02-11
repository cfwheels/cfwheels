<cffunction name="onRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		// abort if called from incorrect file
		$abortInvalidRequest();

		// fix for shared application name issue 359
		if(!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "eventpath"))
		{
			$simpleLock(name="reloadLock#application.applicationName#", execute="onApplicationStart", type="exclusive", timeout=180);
		}

		// need to setup the wheels struct up here since it's used to store debugging info below if this is a reload request
		$initializeRequestScope();

		// reload application by calling onApplicationStart if requested
		if (StructKeyExists(URL, "reload") && (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "reloadPassword") || !Len(application.wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.wheels.reloadPassword)))
		{
			$debugPoint("total,reload");
			$simpleLock(name="reloadLock#application.applicationName#", execute="onApplicationStart", type="exclusive", timeout=180);
		}

		// run the rest of the request start code
		$simpleLock(name="reloadLock#application.applicationName#", execute="$runOnRequestStart", executeArgs=arguments, type="readOnly", timeout=180);
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
			{
				$debugPoint("reload");
			}
			else
			{
				$debugPoint("total");
			}
			$debugPoint("requestStart");
		}

		// copy over the cgi variables we need to the request scope unless it's already been done on application start
		if (!StructKeyExists(request, "cgi"))
		{
			request.cgi = $cgiScope();
		}

		// reload the plugins on each request if cachePlugins is set to false
		if (!application.wheels.cachePlugins)
		{
			$loadPlugins();
		}

		// inject methods from plugins directly to Application.cfc
		if (!StructIsEmpty(application.wheels.mixins))
		{
			$include(template="wheels/plugins/injection.cfm");
		}

		if (application.wheels.environment == "maintenance")
		{
			if (StructKeyExists(url, "except"))
			{
				application.wheels.ipExceptions = url.except;
			}
			if (!Len(application.wheels.ipExceptions) || !ListFind(application.wheels.ipExceptions, request.cgi.remote_addr))
			{
				$header(statusCode=503, statustext="Service Unavailable");
				$includeAndOutput(template="#application.wheels.eventPath#/onmaintenance.cfm");
				$abort();
			}
		}
		if (Right(arguments.targetPage, 4) == ".cfc")
		{
			StructDelete(this, "onRequest");
			StructDelete(variables, "onRequest");
		}
		if (!application.wheels.cacheModelInitialization)
		{
			$simpleLock(name="modelLock#application.applicationName#", execute="$clearModelInitializationCache", type="exclusive");
		}
		if (!application.wheels.cacheControllerInitialization)
		{
			$simpleLock(name="controllerLock#application.applicationName#", execute="$clearControllerInitializationCache", type="exclusive");
		}
		if (!application.wheels.cacheRoutes)
		{
			$loadRoutes();
		}
		if (!application.wheels.cacheDatabaseSchema)
		{
			$clearCache("sql");
		}
		$include(template="#application.wheels.eventPath#/onrequeststart.cfm");
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("requestStart");
		}
	</cfscript>
</cffunction>