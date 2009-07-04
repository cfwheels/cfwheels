<cffunction name="onApplicationStart" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};

		// abort if called from incorrect file
		$abortInvalidRequest();

		// set or reset all settings but make sure to pass along the reload password between forced reloads with "reload=x"
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "reloadPassword"))
			loc.oldReloadPassword = application.wheels.reloadPassword;
		application.wheels = {};
		if (StructKeyExists(loc, "oldReloadPassword"))
			application.wheels.reloadPassword = loc.oldReloadPassword;

		if (StructKeyExists(server, "railo"))
		{
			application.wheels.serverName = "Railo";
			application.wheels.serverVersion = server.railo.version;
		}
		else
		{
			application.wheels.serverName = "Adobe ColdFusion";
			application.wheels.serverVersion = server.coldfusion.productversion;
		}
		loc.majorVersion = Left(application.wheels.serverVersion, 1);
		if ((application.wheels.serverName == "Railo" && loc.majorVersion < 3) || (application.wheels.serverName == "Adobe ColdFusion" && loc.majorVersion < 8))
			$throw(type="Wheels.NoSupport", message="#application.wheels.serverName# #application.wheels.serverVersion# is not supported by Wheels.", extendedInfo="Upgrade to Adobe ColdFusion 8 or Railo 3.");
		application.wheels.version = "0.9.3";
		application.wheels.controllers = {};
		application.wheels.models = {};
		application.wheels.existingModelFiles = "";
		application.wheels.existingControllerFiles = "";
		application.wheels.nonExistingControllerFiles = "";
		application.wheels.existingLayoutFiles = "";
		application.wheels.nonExistingLayoutFiles = "";
		application.wheels.existingHelperFiles = "";
		application.wheels.nonExistingHelperFiles = "";
		application.wheels.routes = [];
		application.wheels.namedRoutePositions = {};

		// set up paths based on if user is running one app or multiple apps in sub folders
		if (DirectoryExists(this.rootDir & "config"))
		{
			loc.root = this.rootDir;
			loc.path = "";
			loc.componentPath = "";
		}
		else
		{
			loc.folder = LCase(cgi.server_name);
			loc.folder = ListDeleteAt(loc.folder, ListLen(loc.folder, "."), ".");
			loc.folder = Replace(loc.folder, "www.", "");
			loc.folder = Replace(loc.folder, ".co", "");
			loc.root = this.rootDir & loc.folder & "/";
			loc.path = loc.folder & "/";
			loc.componentPath = loc.folder & ".";
		}

		application.wheels.webPath = Replace(cgi.script_name, Reverse(spanExcluding(Reverse(cgi.script_name), "/")), "");
		application.wheels.rootPath = "/" & ListChangeDelims(application.wheels.webPath, "/", "/");
		application.wheels.rootcomponentPath = ListChangeDelims(application.wheels.webPath, ".", "/");

		application.wheels.configPath = loc.path & "config";
		application.wheels.controllerPath = loc.path & "controllers";
		application.wheels.controllerComponentPath = loc.componentPath & "controllers";
		application.wheels.eventPath = loc.path & "events";
		application.wheels.filePath = loc.path & "files";
		application.wheels.imagePath = loc.path & "images";
		application.wheels.javascriptPath = loc.path & "javascripts";
		application.wheels.modelPath = loc.path & "models";
		application.wheels.modelComponentPath = loc.componentPath & "models";
		application.wheels.pluginPath = loc.path & "plugins";
		application.wheels.pluginComponentPath = loc.componentPath & "plugins";
		application.wheels.stylesheetPath = loc.path & "stylesheets";
		application.wheels.viewPath = loc.path & "views";

		application.wheels.wheelsPath = listappend(application.wheels.rootPath, "wheels", "/");
		application.wheels.wheelsComponentPath = listappend(application.wheels.rootcomponentPath, "wheels", ".");

		// set up struct for caches
		application.wheels.cache = {};
		application.wheels.cache.sql = {};
		application.wheels.cache.image = {};
		application.wheels.cache.main = {};
		application.wheels.cache.action = {};
		application.wheels.cache.page = {};
		application.wheels.cache.partial = {};
		application.wheels.cache.query = {};
		application.wheels.cacheLastCulledAt = Now();

		// set environment
		if (StructKeyExists(URL, "reload") && !IsBoolean(URL.reload) && Len(url.reload) && (!Len(application.wheels.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.wheels.reloadPassword)))
			application.wheels.environment = URL.reload;
		else
			$include(template="#application.wheels.configPath#/environment.cfm");

		// load wheels settings
		$include(template="wheels/events/onapplicationstart/settings.cfm");

		// load developer settings
		$include(template="#application.wheels.configPath#/settings.cfm");

		//override settings with environment specific ones
		$include(template="#application.wheels.configPath#/#application.wheels.environment#/settings.cfm");

		// load developer routes and add wheels default ones
		$include(template="#application.wheels.configPath#/routes.cfm");
		$include(template="wheels/events/onapplicationstart/routes.cfm");

		// load plugins
		application.wheels.plugins = {};
		application.wheels.incompatiblePlugins = "";

		// handle plugins
		loc.pluginObj = createobject("component", "wheels.plugins").$init();
		// make sure the old pluginmanager is uninstalled, so errors are not thrown
		loc.pluginObj.$uninstallPlugin("pluginmanager");
		// load all plugins
		loc.pluginObj.$loadAllPlugins();

		application.wheels.dispatch = CreateObject("component", "wheels.Dispatch");
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>
