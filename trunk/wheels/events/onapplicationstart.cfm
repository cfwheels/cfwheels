<cffunction name="onApplicationStart" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		application.wheels = {};
		
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
		application.wheels.version = "0.9";
		if (cgi.script_name IS "/rewrite.cfm")
			application.wheels.URLRewriting = "On";
		else if (Len(cgi.path_info))
			application.wheels.URLRewriting = "Partial";
		else
			application.wheels.URLRewriting = "Off";
		application.wheels.controllers = {};
		application.wheels.models = {};
		application.wheels.existingModelFiles = "";
		application.wheels.existingControllerFiles = "";
		application.wheels.nonExistingControllerFiles = "";
		application.wheels.existingLayoutFiles = "";
		application.wheels.nonExistingLayoutFiles = "";
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
			loc.folder = LCase(cgi.http_host);
			loc.folder = ListDeleteAt(loc.folder, ListLen(loc.folder, "."), ".");
			loc.folder = Replace(loc.folder, "www.", "");
			loc.folder = Replace(loc.folder, ".co", "");
			loc.root = this.rootDir & loc.folder & "/";
			loc.path = loc.folder & "/";
			loc.componentPath = loc.folder & ".";
		}
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
		
		// set up struct for caches
		application.wheels.cache = {};
		application.wheels.cache.internal = {};
		application.wheels.cache.internal.sql = {};
		application.wheels.cache.internal.image = {};
		application.wheels.cache.external = {};
		application.wheels.cache.external.main = {};
		application.wheels.cache.external.action = {};
		application.wheels.cache.external.page = {};
		application.wheels.cache.external.partial = {};
		application.wheels.cache.external.query = {};
		application.wheels.cacheLastCulledAt = Now();
		
		// load environment settings
		if (StructKeyExists(URL, "reload") && !IsBoolean(URL.reload) && Len(url.reload) && (!Len(application.settings.reloadPassword) || (StructKeyExists(URL, "password") && URL.password == application.settings.reloadPassword)))
			application.settings.environment = URL.reload;
		else
			$include(template="#application.wheels.configPath#/environment.cfm");
		$include(template="#application.wheels.configPath#/settings.cfm");
		$include(template="#application.wheels.configPath#/environments/#application.settings.environment#.cfm");
		
		// load developer routes and add wheels default ones
		$include(template="#application.wheels.configPath#/routes.cfm");
		$include(template="wheels/events/onapplicationstart/routes.cfm");
		
		application.wheels.webPath = Replace(cgi.script_name, Reverse(spanExcluding(Reverse(cgi.script_name), "/")), "");
		
		// load plugins
		application.wheels.plugins = {};
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
			if (loc.name != ".svn" && !ListContainsNoCase(ValueList(loc.pluginFiles.name), loc.name & "-"))
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
					{
						$directory(action="create", directory=loc.thisPluginFolder);
						$zip(action="unzip", destination=loc.thisPluginFolder, file=loc.thisPluginFile);
					}
					loc.fileName = LCase(loc.pluginName) & "." & loc.pluginName;
					application.wheels.plugins[loc.pluginName] = $createObjectFromRoot(objectType="pluginObject", fileName=loc.fileName);
					if (application.wheels.plugins[loc.pluginName].version != application.wheels.version)
						$throw(type="Wheels.IncompatiblePlugin", message="#loc.pluginName# is incompatible with this version of Wheels.", extendedInfo="You're running version #application.wheels.version# of Wheels and the #loc.pluginName# plugin you have installed only supports version #application.wheels.plugins[loc.pluginName].version#. Download a new version of #loc.pluginName#, drop it in the 'plugins' folder and restart Wheels by issuing a 'reload=true' request.");
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
		}

		// determine and set database brand unless we're running in maintenance mode
		if (application.settings.environment != "maintenance")
		{
			$include(template="#application.wheels.configPath#/database.cfm");
			if (!Len(application.settings.database.datasource))
				application.settings.database.datasource = LCase(ListLast(this.rootDir, Right(this.rootDir, 1)));
			try
			{
				loc.info = $dbinfo(datasource=application.settings.database.datasource, username=application.settings.database.username, password=application.settings.database.password, type="version");
			}
			catch(Any e)
			{
				$throw(type="Wheels.DataSourceNotFound", message="The '#application.settings.database.datasource#' data source could not be found.", extendedInfo="You need to add a data source with this name in the #application.wheels.serverName# Administrator before running Wheels. You can specify a different name for the data source in 'config/database.cfm' if necessary.");
			}
			if (loc.info.driver_name Contains "MySQL")
				loc.adapterName = "MySQL";
			else if (loc.info.driver_name Contains "Oracle")
				loc.adapterName = "Oracle";
			else if (loc.info.driver_name Contains "SQLServer" || loc.info.driver_name Contains "Microsoft SQL Server")
				loc.adapterName = "MicrosoftSQLServer";
			else
				$throw(type="Wheels.NoSupport", message="#loc.info.database_productname# is not supported by Wheels.", extendedInfo="Use Microsoft SQL Server, Oracle or MySQL.");			
			application.wheels.adapter = CreateObject("component", "wheels.#loc.adapterName#");
			application.wheels.databaseProductName = loc.info.database_productname;
			application.wheels.databaseVersion = loc.info.database_version;
		}
		application.wheels.dispatch = CreateObject("component", "wheels.Dispatch");
		$include(template="#application.wheels.eventPath#/onapplicationstart.cfm");
	</cfscript>
</cffunction>
