<cffunction name="$initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
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
		loc.fileName = capitalize(variables.wheels.name);
		if (!ListFindNoCase(application.wheels.existingControllerFiles, variables.wheels.name))
			loc.fileName = "Controller";
		loc.rootObject = "controllerObject";
	</cfscript>
	<cfinclude template="../../root.cfm">
	<cfreturn loc.rootObject>
</cffunction>

<cffunction name="$initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="params" type="struct" required="true">
	<cflock name="controllerLock" type="readonly" timeout="30">
		<cfset variables.wheels = application.wheels.controllers[arguments.name].$getControllerClassData()>
	</cflock>
	<cfset variables.params = arguments.params>
	<cfreturn this>
</cffunction>

<cffunction name="$getControllerClassData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels>
</cffunction>