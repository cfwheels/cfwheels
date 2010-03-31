<!--- PRIVATE FUNCTIONS --->

<cffunction name="$initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		variables.wheels.name = arguments.name;
		variables.wheels.verifications = [];
		variables.wheels.filters = [];
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
		// if the controller file exists we instantiate it, otherwise we instantiate the parent controller
		// this is done so that an action's view page can be rendered without having an actual controller file for it
		if (ListFindNoCase(application.wheels.existingControllerFiles, variables.wheels.name))
			loc.fileName = capitalize(variables.wheels.name);
		else
			loc.fileName = "Controller";
		loc.returnValue = $createObjectFromRoot(path=application.wheels.controllerPath, fileName=loc.fileName, method="$initControllerObject", name=variables.wheels.name, params=arguments.params);
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

		// include controller specific helper files if they exist
		if (ListFindNoCase(application.wheels.existingHelperFiles, arguments.params.controller))
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