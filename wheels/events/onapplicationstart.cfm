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
		application.wheels.version = "0.9.4";
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
		application.wheels.mixableComponents = "dispatch,controller,model,microsoftsqlserver,mysql,oracle,postgresql";
		application.wheels.mixins = {};
		application.wheels.dependantPlugins = "";
		loc.pluginFolder = this.rootDir & "plugins";
		// get a list of plugin files and folders
		loc.pluginFolders = $directory(directory=loc.pluginFolder, type="dir");
		loc.pluginFiles = $directory(directory=loc.pluginFolder, filter="*.zip", type="file", sort="name DESC");
		// delete plugin folders if no corresponding plugin file exist
		loc.iEnd = loc.pluginFolders.recordCount;
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.name = loc.pluginFolders["name"][loc.i];
			loc.directory = loc.pluginFolders["directory"][loc.i];
			if (Left(loc.name, 1) != "." && !ListContainsNoCase(ValueList(loc.pluginFiles.name), loc.name & "-"))
			{
				loc.directory = loc.directory & "/" & loc.name;
				$directory(action="delete", directory=loc.directory, recurse=true);
			}
		}
		// create directory and unzip code for the most recent version of each plugin
		if (loc.pluginFiles.recordCount)
		{
			loc.iEnd = loc.pluginFiles.recordCount;
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.name = loc.pluginFiles["name"][loc.i];
				loc.pluginName = ListFirst(loc.name, "-");
				if (!StructKeyExists(application.wheels.plugins, loc.pluginName))
				{
					loc.pluginVersion = Replace(ListLast(loc.name, "-"), ".zip", "", "one");
					loc.thisPluginFile = loc.pluginFolder & "/" & loc.name;
					loc.thisPluginFolder = loc.pluginFolder & "/" & LCase(loc.pluginName);
					if (!DirectoryExists(loc.thisPluginFolder))
						$directory(action="create", directory=loc.thisPluginFolder);
					$zip(action="unzip", destination=loc.thisPluginFolder, file=loc.thisPluginFile, overwrite=application.wheels.overwritePlugins);
					loc.fileName = LCase(loc.pluginName) & "." & loc.pluginName;
					loc.plugin = $createObjectFromRoot(path=application.wheels.pluginComponentPath, fileName=loc.fileName, method="init");
					if (!StructKeyExists(loc.plugin, "version") || loc.plugin.version == SpanExcluding(application.wheels.version, " ") || application.wheels.loadIncompatiblePlugins)
					{
						application.wheels.plugins[loc.pluginName] = loc.plugin;
						if (StructKeyExists(loc.plugin, "version") && loc.plugin.version != SpanExcluding(application.wheels.version, " "))
							application.wheels.incompatiblePlugins = ListAppend(application.wheels.incompatiblePlugins, loc.pluginName);
					}
				}
			}
			
			// store plugin injection information in application scope so we don't have to run this code on each injection
			loc.iEnd = ListLen(application.wheels.mixableComponents);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				application.wheels.mixins[ListGetAt(application.wheels.mixableComponents, loc.i)] = "";
			}
			loc.iList = StructKeyList(application.wheels.plugins);
			loc.iEnd = ListLen(loc.iList);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.iList, loc.i);
				loc.pluginMeta = GetMetaData(application.wheels.plugins[loc.iItem]); // grab meta data of the plugin
				if (!StructKeyExists(loc.pluginMeta, "environment") || ListFindNoCase(loc.pluginMeta.environment, application.wheels.environment))
				{
					loc.pluginMixins = "global"; // by default and for backwards compatibility, we inject all methods into all objects
					if (StructKeyExists(loc.pluginMeta, "mixin"))
						loc.pluginMixins = loc.pluginMeta["mixin"]; // if the component has a default mixin value, assign that value
					// loop through all plugin methods and enter injection info accordingly (based on the mixin value on the method or the default one set on the entire component)
					loc.jList = StructKeyList(application.wheels.plugins[loc.iItem]);
					loc.jEnd = ListLen(loc.jList);
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
					{
						loc.jItem = ListGetAt(loc.jList, loc.j);
						if (IsCustomFunction(application.wheels.plugins[loc.iItem][loc.jItem]) && loc.jItem != "init")
						{
							loc.methodMeta = GetMetaData(application.wheels.plugins[loc.iItem][loc.jItem]);
							loc.methodMixins = loc.pluginMixins;
							if (StructKeyExists(loc.methodMeta, "mixin"))
								loc.methodMixins = loc.methodMeta["mixin"];
							// mixin all methods except those marked as none
							if (loc.methodMixins != "none")
							{
								loc.kEnd = ListLen(application.wheels.mixableComponents);
								for (loc.k=1; loc.k <= loc.kEnd; loc.k++)
								{
									loc.kItem = ListGetAt(application.wheels.mixableComponents, loc.k);
									if (loc.methodMixins == "global" || ListFindNoCase(loc.methodMixins, loc.kItem))
										application.wheels.mixins[loc.kItem] = ListAppend(application.wheels.mixins[loc.kItem], loc.iItem  & "." & loc.jItem);
								}
							}
						}
					}
				}
			}
			
			// look for plugins that are incompatible with each other
			loc.addedFunctions = "";
			for (loc.key in application.wheels.plugins)
			{
				for (loc.keyTwo in application.wheels.plugins[loc.key])
				{
					if (!ListFindNoCase("init,version", loc.keyTwo))
					{
						if (ListFindNoCase(loc.addedFunctions, loc.keyTwo))
							$throw(type="Wheels.IncompatiblePlugin", message="#loc.key# is incompatible with a previously installed plugin.", extendedInfo="make sure none of the plugins you have installed overrides the same Wheels functions.");
						else
							loc.addedFunctions = ListAppend(loc.addedFunctions, loc.keyTwo);
					}
				}
			}

			// look for plugins that depend on other plugins that are not installed
			for (loc.key in application.wheels.plugins)
			{
				loc.pluginInfo = GetMetaData(application.wheels.plugins[loc.key]);
				if (StructKeyExists(loc.pluginInfo, "dependency"))
				{
					loc.iEnd = ListLen(loc.pluginInfo.dependency);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						loc.iItem = ListGetAt(loc.pluginInfo.dependency, loc.i);
						if (!StructKeyExists(application.wheels.plugins, loc.iItem))
							application.wheels.dependantPlugins = ListAppend(application.wheels.dependantPlugins, Reverse(SpanExcluding(Reverse(loc.pluginInfo.name), ".")) & "|" & loc.iItem);
					}
				}
			}

		}

		// add all public controller / view methods to a list of methods that you should not be allowed to call as a controller action from the URL
		loc.allowedGlobalMethods = "get,set,addroute";
		loc.protectedControllerMethods = StructKeyList($createObjectFromRoot(path=application.wheels.controllerComponentPath, fileName="Controller", method="$initControllerClass"));
		application.wheels.protectedControllerMethods = "";
		loc.iEnd = ListLen(loc.protectedControllerMethods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.method = ListGetAt(loc.protectedControllerMethods, loc.i);
			if (Left(loc.method, 1) != "$" && !ListFindNoCase(loc.allowedGlobalMethods, loc.method))
				application.wheels.protectedControllerMethods = ListAppend(application.wheels.protectedControllerMethods, loc.method);
		}

		application.wheels.dispatch = CreateObject("component", "#application.wheels.wheelsComponentPath#.Dispatch");
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>
