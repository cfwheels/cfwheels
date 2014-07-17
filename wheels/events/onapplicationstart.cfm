<cffunction name="onApplicationStart" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// abort if called from incorrect file
		$abortInvalidRequest();

		// setup the wheels storage struct for the current request
		$initializeRequestScope();

		// set or reset all settings but make sure to pass along the reload password between forced reloads with "reload=x"
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "reloadPassword"))
		{
			loc.oldReloadPassword = application.wheels.reloadPassword;
		}
		application._wheels = {};
		if (StructKeyExists(loc, "oldReloadPassword"))
		{
			application._wheels.reloadPassword = loc.oldReloadPassword;
		}

		// check and store server engine name, throw error if using a version that we don't support
		if (StructKeyExists(server, "railo"))
		{
			application._wheels.serverName = "Railo";
			application._wheels.serverVersion = server.railo.version;
			loc.minimumServerVersion = "4.2.1.000";
		}
		else
		{
			application._wheels.serverName = "Adobe ColdFusion";
			application._wheels.serverVersion = server.coldfusion.productversion;
			loc.minimumServerVersion = "8.0.1.0";
		}
		if (!$checkMinimumVersion(application._wheels.serverVersion, loc.minimumServerVersion))
		{
			$throw(type="Wheels.EngineNotSupported", message="#application._wheels.serverName# #application._wheels.serverVersion# is not supported by Wheels.", extendedInfo="Please upgrade to version #loc.minimumServerVersion# or higher.");
		}

		// copy over the cgi variables we need to the request scope (since we use some of these to determine URL rewrite capabilities we need to be able to access them directly on application start for example)
		request.cgi = $cgiScope();

		// set up containers for routes, caches, settings etc
		application._wheels.version = "1.3 Edge";
		application._wheels.controllers = {};
		application._wheels.models = {};
		application._wheels.existingHelperFiles = "";
		application._wheels.existingLayoutFiles = "";
		application._wheels.existingObjectFiles = "";
		application._wheels.nonExistingHelperFiles = "";
		application._wheels.nonExistingLayoutFiles = "";
		application._wheels.nonExistingObjectFiles = "";
		application._wheels.routes = [];
		application._wheels.namedRoutePositions = {};
		application._wheels.mixins = {};
		application._wheels.cache = {};
		application._wheels.cache.sql = {};
		application._wheels.cache.image = {};
		application._wheels.cache.main = {};
		application._wheels.cache.action = {};
		application._wheels.cache.page = {};
		application._wheels.cache.partial = {};
		application._wheels.cache.query = {};
		application._wheels.cacheLastCulledAt = Now();

		// set up paths to various folders in the framework
		application._wheels.webPath = Replace(request.cgi.script_name, Reverse(spanExcluding(Reverse(request.cgi.script_name), "/")), "");
		application._wheels.rootPath = "/" & ListChangeDelims(application._wheels.webPath, "/", "/");
		application._wheels.rootcomponentPath = ListChangeDelims(application._wheels.webPath, ".", "/");
		application._wheels.wheelsComponentPath = ListAppend(application._wheels.rootcomponentPath, "wheels", ".");
		application._wheels.configPath = "config";
		application._wheels.eventPath = "events";
		application._wheels.filePath = "files";
		application._wheels.imagePath = "images";
		application._wheels.javascriptPath = "javascripts";
		application._wheels.modelPath = "models";
		application._wheels.modelComponentPath = "models";
		application._wheels.pluginPath = "plugins";
		application._wheels.pluginComponentPath = "plugins";
		application._wheels.stylesheetPath = "stylesheets";
		application._wheels.viewPath = "views";

		// set environment either from the url or the developer's environment.cfm file
		if (StructKeyExists(URL, "reload") && !IsBoolean(URL.reload) && Len(url.reload) && StructKeyExists(application._wheels, "reloadPassword") && (!Len(application._wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application._wheels.reloadPassword)))
		{
			application._wheels.environment = URL.reload;
		}
		else
		{
			$include(template="#application._wheels.configPath#/environment.cfm");
		}

		// load wheels settings
		$include(template="wheels/events/onapplicationstart/settings.cfm");

		// load general developer settings first, then override with environment specific ones
		$include(template="#application._wheels.configPath#/settings.cfm");
		$include(template="#application._wheels.configPath#/#application._wheels.environment#/settings.cfm");

		if(application._wheels.clearQueryCacheOnReload)
		{
			$objectcache(action="clear");
		}

		// reload the plugins each time we reload the application
		$loadPlugins();
		
		// allow developers to inject plugins into the application variables scope
		if (!StructIsEmpty(application._wheels.mixins))
		{
			$include(template="wheels/plugins/injection.cfm");
		}

		// load developer routes and adds the default wheels routes (unless the developer has specified not to)
		$loadRoutes();

		// create the dispatcher that will handle all incoming requests
		application._wheels.dispatch = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");

		// assign it all to the application scope in one atomic call
		application.wheels = application._wheels;
		StructDelete(application, "_wheels");

		// run the developer's on application start code
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>