<cffunction name="$initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">

	<cfset variables.wheels.name = arguments.name>
	<cfset variables.wheels.verifications = ArrayNew(1)>
	<cfset variables.wheels.beforeFilters = ArrayNew(1)>
	<cfset variables.wheels.afterFilters = ArrayNew(1)>
	<cfset variables.wheels.cachableActions = ArrayNew(1)>

	<cfif StructKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="$createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="struct" required="true">
	<cfreturn CreateObject("component", "controllerRoot.#variables.wheels.name#").$initControllerObject(variables.wheels.name, arguments.params)>
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