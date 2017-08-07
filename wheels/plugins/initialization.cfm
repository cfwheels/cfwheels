<cfscript>

public any function init(
	required string pluginPath,
	boolean deletePluginDirectories=application.wheels.deletePluginDirectories,
	boolean overwritePlugins=application.wheels.overwritePlugins,
	boolean loadIncompatiblePlugins=application.wheels.loadIncompatiblePlugins,
	string wheelsEnvironment=application.wheels.environment,
	string wheelsVersion=application.wheels.version
) {
	variables.$class = {};
	variables.$class.plugins = {};
	variables.$class.pluginMeta = {};
	variables.$class.mixins = {};
	variables.$class.mixableComponents = "application,dispatch,controller,mapper,model,base,sqlserver,mysql,postgresql,h2,test";
	variables.$class.incompatiblePlugins = "";
	variables.$class.dependantPlugins = "";
	StructAppend(variables.$class, arguments);
	/* handle pathing for different operating systems */
	variables.$class.pluginPathFull = ReplaceNoCase(ExpandPath(variables.$class.pluginPath), "\", "/", "all");
	/* sort direction */
	variables.sort = "ASC";
	/* extract out plugins */
	$pluginsExtract();
	/* remove orphan plugin directories */
	if (variables.$class.deletePluginDirectories) {
		$pluginDelete();
	}
	/* process plugins */
	$pluginsProcess();
	/* get versions */
	$pluginMetaData();
	/* process mixins */
	$processMixins();
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
	local.plugins = $pluginFiles();
	for (local.p in local.plugins) {
		local.plugin = local.plugins[local.p];
		if (!local.plugin.folderExists || (local.plugin.folderExists && variables.$class.overwritePlugins)) {
			if (!local.plugin.folderExists) {
				try {
					DirectoryCreate(local.plugin.folderPath);
				} catch (any e) {
					//
				}
			}
			$zip(action="unzip", destination=local.plugin.folderPath, file=local.plugin.file, overwrite=true);
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
	local.pluginKeys = ListSort(StructKeyList(local.plugins), "textnocase", variables.sort);
	local.wheelsVersion = SpanExcluding(variables.$class.wheelsVersion, " ");
	for (local.pluginKey in local.pluginKeys) {
		local.pluginValue = local.plugins[local.pluginKey];
		local.plugin = CreateObject("component", $componentPathToPlugin(local.pluginKey, local.pluginValue.name)).init();
		if (!StructKeyExists(local.plugin, "version") || ListFind(local.plugin.version, local.wheelsVersion) || variables.$class.loadIncompatiblePlugins) {
			variables.$class.plugins[local.pluginKey] = local.plugin;
			if (StructKeyExists(local.plugin, "version") && !ListFind(local.plugin.version, local.wheelsVersion)) {
				variables.$class.incompatiblePlugins = ListAppend(variables.$class.incompatiblePlugins, local.pluginKey);
			}
		}
	};
}

/**
 * Attempt to extract version numbers from box.json and/or corresponding .zip files
 * Storing box.json data too as this may be useful later
 */
public void function $pluginMetaData() {
	for(local.plugin in variables.$class.plugins){
		variables.$class.pluginMeta[local.plugin]={
			"version": "",
			"boxjson": {}
		};
		local.boxJsonLocation=$fullPathToPlugin(local.plugin & "/" & 'box.json');
		if(fileExists(local.boxJsonLocation)){
			local.boxJson=deserializeJSON(fileRead(local.boxJsonLocation));
			variables.$class.pluginMeta[local.plugin]["boxjson"]=local.boxJson;
			if(structKeyExists(local.boxJson, "version")){
				variables.$class.pluginMeta[local.plugin]["version"]=local.boxJson.version;
			}
		}
	}
}

public void function $determineDependancy() {
	for (local.iPlugins in variables.$class.plugins) {
		local.pluginMeta = GetMetaData(variables.$class.plugins[local.iPlugins]);
		if (StructKeyExists(local.pluginMeta, "dependency")) {
			for (local.iDependency in local.pluginMeta.dependency) {
				local.iDependency = trim(local.iDependency);
				if (!StructKeyExists(variables.$class.plugins, local.iDependency)) {
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
	for (local.iMixableComponents in variables.$class.mixableComponents) {
		variables.$class.mixins[local.iMixableComponents] = {};
	}

	// get a sorted list of plugins so that we run through them the same on
	// every platform
	local.pluginKeys = ListToArray(ListSort(structKeyList(variables.$class.plugins), "textnocase", variables.sort));

	for (local.iPlugin in local.pluginKeys) {

		// reference the plugin
		local.plugin = variables.$class.plugins[local.iPlugin];

		// grab meta data of the plugin
		local.pluginMeta = GetMetaData(local.plugin);

		if (!StructKeyExists(local.pluginMeta, "environment") || ListFindNoCase(local.pluginMeta.environment, variables.$class.wheelsEnvironment)) {

			// by default and for backwards compatibility, we inject all methods
			// into all objects
			local.pluginMixins = "global";

			// if the component has a default mixin value, assign that value
			if (StructKeyExists(local.pluginMeta, "mixin")) {
				local.pluginMixins = local.pluginMeta["mixin"];
			}

			// loop through all plugin methods and enter injection info accordingly
			// (based on the mixin value on the method or the default one set on the
			// entire component)
			local.pluginMethods = StructKeyList(local.plugin);

			for (local.iPluginMethods in local.pluginMethods) {
				if (IsCustomFunction(local.plugin[local.iPluginMethods]) && local.iPluginMethods neq "init") {
					local.methodMeta = GetMetaData(local.plugin[local.iPluginMethods]);
					local.methodMixins = local.pluginMixins;
					if (StructKeyExists(local.methodMeta, "mixin")) {
						local.methodMixins = local.methodMeta["mixin"];
					}

					// mixin all methods except those marked as none
					if (local.methodMixins != "none") {
						for (local.iMixableComponent in variables.$class.mixableComponents) {
							if (local.methodMixins == "global" || ListFindNoCase(local.methodMixins, local.iMixableComponent)) {

								// new secret magic sauce here is to get the mixable method to our framework method
								// $pluginRunner. When called, we'll be able to see what the function name called
								// was and will be able to run our stack of methods easily
								variables.$class.mixins[local.iMixableComponent][local.iPluginMethods] = $pluginRunner;

								// other secret sauce for complete backwards compatibility is to set the core scope
								// here so that we don't create it when plugin injection runs. Here we set the method to
								// $$pluginContinue and it passes back a data struct that $pluginRunner
								// can recognize as a specific call to contine running the stack
								variables.$class.mixins[local.iMixableComponent]["core"][local.iPluginMethods] = $pluginRunner;

								// now we create a new struct $stacks that is a struct of method names with each
								// method name being an array of plugin override methods. This will be put into
								// variables.$stacks in any object that we mix plugins into and will allow
								// $pluginRunner to have access to the functions :D
								if (!StructKeyExists(variables.$class.mixins[local.iMixableComponent], "$stacks") || !StructKeyExists(variables.$class.mixins[local.iMixableComponent]["$stacks"], local.iPluginMethods)) {
									variables.$class.mixins[local.iMixableComponent]["$stacks"][local.iPluginMethods] = [];
								}

								ArrayPrepend(variables.$class.mixins[local.iMixableComponent]["$stacks"][local.iPluginMethods], local.plugin[local.iPluginMethods]);
							}
						}
					}
				}
			}
		}
	}
}

/**
* GETTERS
*/

public any function getPlugins() {
	return variables.$class.plugins;
}

public any function getPluginMeta() {
	return variables.$class.pluginMeta;
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
	local.query = $directory(action="list", directory=variables.$class.pluginPathFull, type="dir", sort="name #variables.sort#");
	return $query(dbtype="query", query=local.query, sql="select * from query where name not like '.%' ORDER BY name #variables.sort#");
}

public query function $files() {
	local.query = $directory(action="list", directory=variables.$class.pluginPathFull, filter="*.zip", type="file", sort="name #variables.sort#");
	return $query(dbtype="query", query=local.query, sql="select * from query where name not like '.%' ORDER BY name #variables.sort#");
}

</cfscript>
