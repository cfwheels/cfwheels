<cffunction name="onApplicationStart" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// abort if called from incorrect file
		$abortInvalidRequest();

		// setup the wheels storage struct for the current request
		$initializeRequestScope();
		
		// preserve the following setting between reloads
		loc.savedSettings = {};
		if (StructKeyExists(application, "wheels"))
		{
			loc.savedSettings = $saveScopeSettings(application.wheels, "reloadPassword,allowedEnvironmentSwitchThroughURL");
		}
			
		application.wheels = {};
		
		// include the version
		$include(template="wheels/version.cfm");

		// check and store server engine name, throw error if using a version that we don't support
		// really need to refactor this into a method
		if (StructKeyExists(server, "railo"))
		{
			application.wheels.serverName = "Railo";
			application.wheels.serverVersion = server.railo.version;
			loc.minimumServerVersion = "3.3.1.000";
			
			// Distinguish against Railo4 since it has changed a bunch of things
			if(ListFirst(application.wheels.serverVersion, '.') eq 4)
			{
				application.wheels.serverName = "Railo4";
			}
		}
		else
		{
			application.wheels.serverName = "Adobe ColdFusion";
			application.wheels.serverVersion = server.coldfusion.productversion;
			loc.minimumServerVersion = "8,0,1,0";
		}

		if (!$checkMinimumVersion(application.wheels.serverVersion, loc.minimumServerVersion))
		{
			$throw(type="Wheels.EngineNotSupported", message="#application.wheels.serverName# #application.wheels.serverVersion# is not supported by Wheels.", extendedInfo="Please upgrade to version #loc.minimumServerVersion# or higher.");
		}
		
		// load any saved settings from the previous reload
		StructAppend(application.wheels, loc.savedSettings, true);

		// copy over the cgi variables we need to the request scope (since we use some of these to determine URL rewrite capabilities we need to be able to access them directly on application start for example)
		request.cgi = $cgiScope();
		
		// load locales
		application.wheels.locales = $loadLocales();
		// default locale
		application.wheels.locale = "en-US";
		application.wheels.utcTimestamps = false;

		// set up containers for routes, caches, settings etc
		application.wheels.controllers = {};
		application.wheels.models = {};
		application.wheels.existingHelperFiles = "";
		application.wheels.existingLayoutFiles = "";
		application.wheels.existingObjectFiles = "";
		application.wheels.nonExistingHelperFiles = "";
		application.wheels.nonExistingLayoutFiles = "";
		application.wheels.nonExistingObjectFiles = "";
		application.wheels.routes = [];
		application.wheels.namedRoutePositions = {};
		application.wheels.mixins = {};
		application.wheels.vendor = {};

		// set up paths to various folders in the framework
		application.wheels.webPath = Replace(request.cgi.script_name, Reverse(spanExcluding(Reverse(request.cgi.script_name), "/")), "");
		application.wheels.rootPath = "/" & ListChangeDelims(application.wheels.webPath, "/", "/");
		application.wheels.rootcomponentPath = ListChangeDelims(application.wheels.webPath, ".", "/");
		application.wheels.wheelsComponentPath = ListAppend(application.wheels.rootcomponentPath, "wheels", ".");
		application.wheels.configPath = "config";
		application.wheels.eventPath = "events";
		application.wheels.filePath = "files";
		application.wheels.imagePath = "images";
		application.wheels.javascriptPath = "javascripts";
		application.wheels.modelPath = "models";
		application.wheels.modelComponentPath = "models";
		application.wheels.pluginPath = "plugins";
		application.wheels.pluginComponentPath = "plugins";
		application.wheels.stylesheetPath = "stylesheets";
		application.wheels.viewPath = "views";
		
		// see if they are switching environments
		loc.environment = $switchEnivronmentSecurity(application.wheels, url);

		if (Len(loc.environment))
		{
			application.wheels.environment = loc.environment;	
		}
		else
		{
			// load the environment
			$include(template="#application.wheels.configPath#/environment.cfm");	
		}

		// load wheels settings
		$include(template="wheels/events/onapplicationstart/settings.cfm");

		// load general developer settings first, then override with environment specific ones
		$include(template="#application.wheels.configPath#/settings.cfm");
		$include(template="#application.wheels.configPath#/#application.wheels.environment#/settings.cfm");

		if(application.wheels.clearQueryCacheOnReload)
		{
			$objectcache(action="clear");
		}

		// add all public controller / view methods to a list of methods that you should not be allowed to call as a controller action from the url
		loc.allowedGlobalMethods = "get,set,addroute,addDefaultRoutes";
		loc.protectedControllerMethods = StructKeyList($createObjectFromRoot(path=application.wheels.controllerPath, fileName="Wheels", method="$initControllerClass"));
		application.wheels.protectedControllerMethods = "";
		loc.iEnd = ListLen(loc.protectedControllerMethods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.method = ListGetAt(loc.protectedControllerMethods, loc.i);
			if (Left(loc.method, 1) != "$" && !ListFindNoCase(loc.allowedGlobalMethods, loc.method))
				application.wheels.protectedControllerMethods = ListAppend(application.wheels.protectedControllerMethods, loc.method);
		}

		// load plugins
		$loadPlugins();
		
		// allow developers to inject plugins into the application variables scope
		if (!StructIsEmpty(application.wheels.mixins))
			$include(template="wheels/plugins/injection.cfm");

		// load developer routes and adds the default wheels routes (unless the developer has specified not to)
		$loadRoutes();

		// create the dispatcher that will handle all incoming requests
		application.wheels.dispatch = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");

		// create the cache objects for each category
		application.wheels.caches = {};
		
		for (loc.item in application.wheels.cacheSettings)
			application.wheels.caches[loc.item] = $createObjectFromRoot(path="wheels", fileName="Cache", method="init", argumentCollection=application.wheels.cacheSettings[loc.item]);
		
		// run the developer's on application start code
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>