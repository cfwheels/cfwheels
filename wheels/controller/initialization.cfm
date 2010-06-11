<cffunction name="$initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		variables.wheels.name = arguments.name;
		variables.wheels.verifications = [];
		variables.wheels.beforeFilters = [];
		variables.wheels.afterFilters = [];
		variables.wheels.cachableActions = [];
		if (StructKeyExists(variables, "init"))
			init();
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="$createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = $createObjectFromRoot(path=application.wheels.controllerComponentPath, fileName=$controllerFileName(variables.wheels.name), method="$initControllerObject", name=variables.wheels.name, params=arguments.params);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$setControllerClassData" returntype="void" access="public" output="false">
	<cfscript>
		variables.wheels = application.wheels.controllers[arguments.name].$getControllerClassData();
	</cfscript>
</cffunction>

<cffunction name="$initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cfscript>
		var loc = {};

		// include controller specific helper files if they exist, cache the file check for performance reasons
		loc.helperFileExists = false;
		if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
		{
			if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm")))
				loc.helperFileExists = true;
			if (application.wheels.cacheFileChecking)
			{
				if (loc.helperFileExists)
					application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
				else
					application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
			}
		}
		if (ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) || loc.helperFileExists)
			$include(template="#application.wheels.viewPath#/#arguments.name#/helpers.cfm");
		
		loc.executeArgs = {};
		loc.executeArgs.name = arguments.name;
		$simpleLock(name="controllerLock", type="readonly", execute="$setControllerClassData", executeArgs=loc.executeArgs);
		variables.params = arguments.params;
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="$getControllerClassData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels>
</cffunction>