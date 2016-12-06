<cfscript>
	/**
	* PRIVATE FUNCTIONS
	*/

	public any function $createControllerObject(required struct params) {
		// if the controller file exists we instantiate it, otherwise we instantiate the parent controller
		// this is done so that an action's view page can be rendered without having an actual controller file for it
		local.controllerName = $objectFileName(name=variables.$class.name, objectPath=variables.$class.path, type="controller");
		local.rv = $createObjectFromRoot(path=variables.$class.path, fileName=local.controllerName, method="$initControllerObject", name=variables.$class.name, params=arguments.params);
		return local.rv;
	}

	public any function $initControllerClass(string name="") {
		variables.$class.name = arguments.name;
		variables.$class.path = arguments.path;

		variables.$class.verifications = [];
		variables.$class.filters = [];
		variables.$class.cachableActions = [];
		variables.$class.layout = {};

		// default the controller to only respond to html
		variables.$class.formats = {};
		variables.$class.formats.default = "html";
		variables.$class.formats.actions = {};
		variables.$class.formats.existingTemplates = "";
		variables.$class.formats.nonExistingTemplates = "";

		$setFlashStorage(get("flashStorage"));
		if (StructKeyExists(variables, "init"))
		{
			init();
		}
		local.rv = this;
		return local.rv;
	}

	public void function $setControllerClassData() {
		variables.$class = application.wheels.controllers[arguments.name].$getControllerClassData();
	}

	public any function $initControllerObject(required string name, required struct params) {

		// create a struct for storing request specific data
		variables.$instance = {};
		variables.$instance.contentFor = {};

		// setup direct helper methods for named routes
		for (local.namedRoute in application.wheels.namedRoutePositions) {
			variables[local.namedRoute & "Path"] = $namedRoute;
			variables[local.namedRoute & "Url"] = $namedRoute;
		}

		// include controller specific helper files if they exist,
		// cache the file check for performance reasons
		// name could be dot notation so we need to change delims
		local.template = get("viewPath")
			& "/"
			& LCase(ListChangeDelims(arguments.name, '/', '.'))
			& "/helpers.cfm";

		local.helperFileExists = false;
		if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
		{
			if (FileExists(ExpandPath(local.template)))
			{
				local.helperFileExists = true;
			}
			if (get("cacheFileChecking"))
			{
				if (local.helperFileExists)
				{
					application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
				}
				else
				{
					application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
				}
			}
		}
		if (Len(arguments.name) && (ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) || local.helperFileExists))
		{
			$include(template=local.template);
		}

		local.executeArgs = {};
		local.executeArgs.name = arguments.name;
		local.lockName = "controllerLock" & application.applicationName;
		$simpleLock(name=local.lockName, type="readonly", execute="$setControllerClassData", executeArgs=local.executeArgs);
		variables.params = arguments.params;
		local.rv = this;
		return local.rv;
	}

	public struct function $getControllerClassData() {
		local.rv = variables.$class;
		return local.rv;
	}
</cfscript>
