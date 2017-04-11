<cfscript>

/**
 * If the controller file exists we instantiate it, otherwise we instantiate the parent controller.
 * This is done so that an action's view page can be rendered without having an actual controller file for it.
 */
public any function $createControllerObject(required struct params) {
	local.controllerName = $objectFileName(
		name=variables.$class.name,
		objectPath=variables.$class.path,
		type="controller"
	);
	return $createObjectFromRoot(
		path=variables.$class.path,
		fileName=local.controllerName,
		method="$initControllerObject",
		name=variables.$class.name,
		params=arguments.params
	);
}

/**
 * Return the controller data that is on the class level.
 */
public struct function $getControllerClassData() {
	return variables.$class;
}

/**
 * Initialize the controller class level object and return it.
 */
public any function $initControllerClass(string name="") {
	variables.$class.name = arguments.name;
	variables.$class.path = arguments.path;
	variables.$class.verifications = [];
	variables.$class.filters = [];
	variables.$class.cachableActions = [];
	variables.$class.layout = {};

	// Setup format info for providing content.
	// Default the controller to only respond to HTML.
	variables.$class.formats = {};
	variables.$class.formats.default = "html";
	variables.$class.formats.actions = {};
	variables.$class.formats.existingTemplates = "";
	variables.$class.formats.nonExistingTemplates = "";

	$setFlashStorage($get("flashStorage"));

	// Call the developer's "config" function if it exists.
	if (StructKeyExists(variables, "config")) {
		config();
	}

	return this;
}

/**
 * Initialize the controller instance level object and return it.
 */
public any function $initControllerObject(required string name, required struct params) {

	// Create a struct for storing request specific data.
	variables.$instance = {};
	variables.$instance.contentFor = {};

	// Set file name to look for (e.g. "views/folder/helpers.cfm").
	// Name could be dot notation so we need to change delimiters.
	local.template = $get("viewPath") & "/" & LCase(ListChangeDelims(arguments.name, '/', '.')) & "/helpers.cfm";

	// Check if the file exists on the file system if we have not already checked in a previous request.
	// When the file is not found in either the existing or nonexisting list we know that we have not yet checked for it.
	local.helperFileExists = false;
	if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name)) {
		if (FileExists(ExpandPath(local.template))) {
			local.helperFileExists = true;
		}
		if ($get("cacheFileChecking")) {
			if (local.helperFileExists) {
				application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
			} else {
				application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
			}
		}
	}

	// Include controller specific helper file if it exists.
	if (Len(arguments.name) && (ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) || local.helperFileExists)) {
		$include(template=local.template);
	}

	local.executeArgs = {};
	local.executeArgs.name = arguments.name;
	local.lockName = "controllerLock" & application.applicationName;
	$simpleLock(name=local.lockName, type="readonly", execute="$setControllerClassData", executeArgs=local.executeArgs);
	variables.params = arguments.params;
	return this;
}

/**
 * Get the class level data from the controller object in the application scope and set it to this controller.
 * By class level we mean that it's stored in the controller object in the application scope.
 */
public void function $setControllerClassData() {
	variables.$class = application.wheels.controllers[arguments.name].$getControllerClassData();
}

</cfscript>
