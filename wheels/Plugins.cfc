component output="false" {

	variables.$class = {};
	variables.$class.plugins = {};
	variables.$class.mixins = {};
	variables.$class.mixableComponents = "application,dispatch,controller,model,base,sqlserver,mysql,mariadb,oracle,postgresql,h2,test";
	variables.$class.incompatiblePlugins = "";
	variables.$class.dependantPlugins = "";

	include "global/cfml.cfm";

	public any function init(
	  required string pluginPath,
	  boolean deletePluginDirectories=application.wheels.deletePluginDirectories,
	  boolean overwritePlugins=application.wheels.overwritePlugins,
	  boolean loadIncompatiblePlugins=application.wheels.loadIncompatiblePlugins,
	  string wheelsEnvironment=application.wheels.environment,
	  string wheelsVersion=application.wheels.version
	) {
		StructAppend(variables.$class, arguments);
		/* handle pathing for different operating systems */
		variables.$class.pluginPathFull = ReplaceNoCase(ExpandPath(variables.$class.pluginPath), "\", "/", "all");
		/* extract out plugins */
		$pluginsExtract();
		/* remove orphan plugin directories */
		if (variables.$class.deletePluginDirectories) {
			$pluginDelete();
		}
		/* process plugins */
		$pluginsProcess();
		/* process mixins */
		$processMixins();
		/* incompatibility */
		$determineIncompatible();
		/* dependancies */
		$determineDependancy();
		return this;
	}

	public struct function $pluginFolders() {
		local.plugins = {};
		// Within plugin folders, grab info about each plugin and package up into a struct.
		for (local.folder in $folders()) {
			// For *nix, we need a case-sensitive name for the plugin component, so we must reference its CFC file name.
			local.subfolder = DirectoryList("#local.folder.directory#/#local.folder.name#", false, "query");
			local.pluginCfc = $query(
				dbtype="query",
				query=local.subfolder,
				sql="SELECT name FROM query WHERE LOWER(name) = '#LCase(local.folder.name)#.cfc'"
			);
			local.temp = {};
			local.temp.name = Replace(local.pluginCfc.name, ".cfc", "");
			local.temp.folderPath = $fullPathToPlugin(local.folder.name);
			local.temp.componentName = local.folder.name & "." & Replace(local.pluginCfc.name, ".cfc", "");
			local.plugins[local.folder.name] = local.temp;
		}
		return local.plugins;
	}

	public struct function $pluginFiles() {
		// get all plugin zip files
		local.files = $files();
		local.plugins = {};
		for (local.i in local.files) {
			local.name = ListFirst(local.i.name, "-");
			local.temp = {};
			local.temp.file = $fullPathToPlugin(local.i.name);
			local.temp.name = local.i.name;
			local.temp.folderPath = $fullPathToPlugin(LCase(local.name));
			local.temp.folderExists = DirectoryExists(local.temp.folderPath);
			local.plugins[local.name] = local.temp;
		};
		return local.plugins;
	}

	public void function $pluginsExtract() {
		// get all plugin zip files
		loc.plugins = $pluginFiles();
		for (loc.p in loc.plugins) {
			loc.plugin = loc.plugins[loc.p];
			if (! loc.plugin.folderExists || (loc.plugin.folderExists && variables.$class.overwritePlugins)) {
				if (! loc.plugin.folderExists) {
					try {
						DirectoryCreate(loc.plugin.folderPath);
					} catch(any e) {
						//
					}
				}
				$zip(action="unzip", destination=loc.plugin.folderPath, file=loc.plugin.file, overwrite=true);
			}
		};
	}

	public void function $pluginDelete() {
		local.folders = $pluginFolders();
		// put zip files into a list
		local.files = $pluginFiles();
		local.files = StructKeyList(local.files);
		// loop through the plugins folders
		for (local.iFolder in $pluginFolders()) {
			local.folder = local.folders[local.iFolder];
			// see if a folder is in the list of plugin files
			if (!ListContainsNoCase(local.files, local.folder.name)) {
				DirectoryDelete(local.folder.folderPath, true);
			}
 		};
	}

	public void function $pluginsProcess() {
		local.plugins = $pluginFolders();
		local.pluginKeys = StructKeyList(local.plugins);
		local.wheelsVersion = SpanExcluding(variables.$class.wheelsVersion, " ");
		for (local.pluginKey in local.pluginKeys) {
			local.pluginValue = local.plugins[local.pluginKey];
			local.plugin = CreateObject("component", $componentPathToPlugin(local.pluginKey, local.pluginValue.name)).init();
			if (! StructKeyExists(local.plugin, "version") || ListFind(local.plugin.version, local.wheelsVersion) || variables.$class.loadIncompatiblePlugins) {
				variables.$class.plugins[local.pluginKey] = local.plugin;
				if (StructKeyExists(local.plugin, "version") && ! ListFind(local.plugin.version, local.wheelsVersion)) {
					variables.$class.incompatiblePlugins = ListAppend(variables.$class.incompatiblePlugins, local.pluginKey);
				}
			}
		};
	}

	public void function $determineIncompatible() {
		local.excludeMethods = "init,version,pluginVersion";
		local.loadedMethods = {};
		for (local.iPlugins in variables.$class.plugins) {
			local.plugin = variables.$class.plugins[local.iPlugins];
			for (local.method in local.plugin) {
				if (! ListFindNoCase(local.excludeMethods, local.method)) {
					if (StructKeyExists(local.loadedMethods, local.method)) {
						$throw(type="Wheels.IncompatiblePlugin", message="#local.iPlugins# is incompatible with a previously installed plugin.", extendedInfo="Make sure none of the plugins you have installed override the same CFWheels functions.");
					} else {
						local.loadedMethods[local.method] = "";
					}
				}
			};
		};
	}

	public void function $determineDependancy() {
		for (local.iPlugins in variables.$class.plugins) {
			local.pluginMeta = GetMetaData(variables.$class.plugins[local.iPlugins]);
			if (StructKeyExists(local.pluginMeta, "dependency")) {
				for (local.iDependency in local.pluginMeta.dependency) {
					local.iDependency = trim(local.iDependency);
					if (! StructKeyExists(variables.$class.plugins, local.iDependency)) {
						variables.$class.dependantPlugins = ListAppend(variables.$class.dependantPlugins, Reverse(SpanExcluding(Reverse(local.pluginMeta.name), ".")) & "|" & local.iDependency);
					}
				};
			}
		};
	}

	/**
	* MIXINS
	*/

	public void function $processMixins() {
		// setup a container for each mixableComponents type
		for (loc.iMixableComponents in variables.$class.mixableComponents) {
			variables.$class.mixins[loc.iMixableComponents] = {};
		};
		for (loc.iPlugin in variables.$class.plugins) {
			// reference the plugin
			loc.plugin = variables.$class.plugins[loc.iPlugin];
			// grab meta data of the plugin
			loc.pluginMeta = GetMetaData(loc.plugin);
			if (! StructKeyExists(loc.pluginMeta, "environment") || ListFindNoCase(loc.pluginMeta.environment, variables.$class.wheelsEnvironment)) {
				// by default and for backwards compatibility, we inject all methods into all objects
				loc.pluginMixins = "global";
				if (StructKeyExists(loc.pluginMeta, "mixin")) {
					// if the component has a default mixin value, assign that value
					loc.pluginMixins = loc.pluginMeta["mixin"];
				}
				// loop through all plugin methods and enter injection info accordingly (based on the mixin value on the method or the default one set on the entire component)
				loc.pluginMethods = StructKeyList(loc.plugin);
				for (loc.iPluginMethods in loc.pluginMethods) {
					if (IsCustomFunction(loc.plugin[loc.iPluginMethods]) && loc.iPluginMethods neq "init") {
						loc.methodMeta = GetMetaData(loc.plugin[loc.iPluginMethods]);
						loc.methodMixins = loc.pluginMixins;
						if (StructKeyExists(loc.methodMeta, "mixin")) {
							loc.methodMixins = loc.methodMeta["mixin"];
						}
						// mixin all methods except those marked as none
						if (loc.methodMixins neq "none") {
							for (loc.iMixableComponent in variables.$class.mixableComponents) {
								if (loc.methodMixins EQ "global" || ListFindNoCase(loc.methodMixins, loc.iMixableComponent)) {
									variables.$class.mixins[loc.iMixableComponent][loc.iPluginMethods] = loc.plugin[loc.iPluginMethods];
								}
							};
						}
					}
				};
			}
		};
	}

	/**
	* GETTERS
	*/

	public any function getPlugins() {
		return variables.$class.plugins;
	}

	public any function getIncompatiblePlugins() {
		return variables.$class.incompatiblePlugins;
	}

	public any function getDependantPlugins() {
		return variables.$class.dependantPlugins;
	}

	public any function getMixins() {
		return variables.$class.mixins;
	}

	public any function getMixableComponents() {
		return variables.$class.mixableComponents;
	}

	public any function inspect() {
		return variables;
	}

	/**
	* PRIVATE
	*/

	public string function $fullPathToPlugin(required string folder) {
		return ListAppend(variables.$class.pluginPathFull, arguments.folder, "/");
	}

	public string function $componentPathToPlugin(required string folder, required string file) {
		local.path = [ListChangeDelims(variables.$class.pluginPath, ".", "/"), arguments.folder, arguments.file];
		return ArrayToList(local.path, ".");
	}

	public query function $folders() {
		local.query = $directory(action="list", directory=variables.$class.pluginPathFull, type="dir");
		return $query(dbtype="query", query=local.query, sql="select * from query where name not like '.%'");
	}

	public query function $files() {
		local.query = $directory(action="list", directory=variables.$class.pluginPathFull, filter="*.zip", type="file", sort="name DESC");
		return $query(dbtype="query", query=local.query, sql="select * from query where name not like '.%' order by name");
	}

}
