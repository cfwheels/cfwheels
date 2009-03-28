<cffunction name="onRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		if (StructKeyExists(URL, "reload") and (not(StructKeyExists(application, "wheels")) or not(StructKeyExists(application.wheels, "reloadPassword")) or not(Len(application.wheels.reloadPassword)) or (StructKeyExists(URL, "password") and URL.password eq application.wheels.reloadPassword)))
			$simpleLock(execute="onApplicationStart", scope="application", type="exclusive");
		$simpleLock(execute="runOnRequestStart", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="runOnRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		var loc = StructNew();
		if (application.wheels.environment eq "maintenance")
		{
			if (StructKeyExists(URL, "except"))
				application.wheels.ipExceptions = URL.except;
			if (not(Len(application.wheels.ipExceptions)) or not(ListFind(application.wheels.ipExceptions, cgi.remote_addr)))
			{
				$includeAndOutput(template="#application.wheels.eventPath#/onmaintenance.cfm");
				$abort();
			}
		}
		if (Right(arguments.targetPage, 4) eq ".cfc")
		{
			StructDelete(this, "onRequest");
			StructDelete(variables, "onRequest");
		}
		request.wheels = StructNew();
		request.wheels.params = StructNew();
		request.wheels.cache = StructNew();
		if (application.wheels.showDebugInformation)
			$debugPoint("total,requestStart");
		if (not(application.wheels.cacheModelInitialization))
			StructClear(application.wheels.models);
		if (not(application.wheels.cacheControllerInitialization))
			StructClear(application.wheels.controllers);
		if (not(application.wheels.cacheRoutes))
		{
			ArrayClear(application.wheels.routes);
			$include(template="#application.wheels.configPath#/routes.cfm");
			$include(template="wheels/events/onapplicationstart/routes.cfm");
		}
		if (not(application.wheels.cacheDatabaseSchema))
			$clearCache("sql");
		if (not(application.wheels.cacheFileChecking))
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