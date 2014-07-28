<!--- PRIVATE FUNCTIONS --->

<cffunction name="$createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};

		// if the controller file exists we instantiate it, otherwise we instantiate the parent controller
		// this is done so that an action's view page can be rendered without having an actual controller file for it
		loc.controllerName = $objectFileName(name=variables.wheels.class.name, objectPath=variables.wheels.class.path, type="controller");
		loc.returnValue = $createObjectFromRoot(path=variables.wheels.class.path, fileName=loc.controllerName, method="$initControllerObject", name=variables.wheels.class.name, params=arguments.params);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		variables.wheels.class.name = arguments.name;
		variables.wheels.class.path = arguments.path;

		// if our name has pathing in it, remove it and add it to the end of of the class path variable
		if (Find("/", arguments.name))
		{
			variables.wheels.class.name = ListLast(arguments.name, "/");
			variables.wheels.class.path = ListAppend(arguments.path, ListDeleteAt(arguments.name, ListLen(arguments.name, "/"), "/"), "/");
		}

		variables.wheels.class.verifications = [];
		variables.wheels.class.filters = [];
		variables.wheels.class.cachableActions = [];
		variables.wheels.class.layout = {};
		
		// default the controller to only respond to html
		variables.wheels.class.formats = {};
		variables.wheels.class.formats.default = "html";
		variables.wheels.class.formats.actions = {};
		variables.wheels.class.formats.existingTemplates = "";
		variables.wheels.class.formats.nonExistingTemplates = "";
		
		$setFlashStorage(get("flashStorage"));
		if (StructKeyExists(variables, "init"))
		{
			init();
		}
		loc.returnValue = this;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$setControllerClassData" returntype="void" access="public" output="false">
	<cfscript>
		variables.wheels.class = application.wheels.controllers[arguments.name].$getControllerClassData();
	</cfscript>
</cffunction>

<cffunction name="$initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};

		// create a struct for storing request specific data
		variables.$instance = {};
		variables.$instance.contentFor = {};

		// include controller specific helper files if they exist, cache the file check for performance reasons
		loc.helperFileExists = false;
		if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
		{
			if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm")))
			{
				loc.helperFileExists = true;
			}
			if (application.wheels.cacheFileChecking)
			{
				if (loc.helperFileExists)
				{
					application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
				}
				else
				{
					application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
				}
			}
		}
		if (Len(arguments.name) && (ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) || loc.helperFileExists))
		{
			$include(template="#application.wheels.viewPath#/#arguments.name#/helpers.cfm");
		}

		loc.executeArgs = {};
		loc.executeArgs.name = arguments.name;
		$simpleLock(name="controllerLock", type="readonly", execute="$setControllerClassData", executeArgs=loc.executeArgs);
		variables.params = arguments.params;
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="$getControllerClassData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels.class>
</cffunction>