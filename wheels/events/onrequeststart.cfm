<cffunction name="onRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		if (StructKeyExists(URL, "reload") && (!Len(application.settings.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.settings.reloadPassword)))
			$simpleLock(execute="onApplicationStart", scope="application", type="exclusive");
		$simpleLock(execute="runOnRequestStart", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="runOnRequestStart" returntype="void" access="public" output="false">
	<cfargument name="targetPage" type="any" required="true">
	<cfscript>
		var loc = {};
		if (application.settings.environment == "maintenance")
		{
			if (StructKeyExists(URL, "except"))
				application.settings.ipExceptions = URL.except;
			if (!Len(application.settings.ipExceptions) || !ListFind(application.settings.ipExceptions, cgi.remote_addr))
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
		if (application.settings.showDebugInformation)
			$debugPoint("total,requestStart");
		if (!application.settings.cacheModelInitialization)
			StructClear(application.wheels.models);
		if (!application.settings.cacheControllerInitialization)
			StructClear(application.wheels.controllers);
		if (!application.settings.cacheRoutes)
		{
			ArrayClear(application.wheels.routes);
			$include(template="#application.wheels.configPath#/routes.cfm");
			$include(template="wheels/events/onapplicationstart/routes.cfm");
		}
		if (!application.settings.cacheDatabaseSchema)
			$clearCache("sql", "internal");
		$include(template="#application.wheels.eventPath#/onrequeststart.cfm");
		if (application.settings.showDebugInformation)
			$debugPoint("requestStart");
	</cfscript>
</cffunction>