<cffunction name="_initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">

	<cfset variables.wheels.name = arguments.name>
	<cfset variables.wheels.verifications = arrayNew(1)>
	<cfset variables.wheels.beforeFilters = arrayNew(1)>
	<cfset variables.wheels.afterFilters = arrayNew(1)>
	<cfset variables.wheels.cachableActions = arrayNew(1)>

	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfreturn this>
</cffunction>


<cffunction name="_createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn createObject("component", "controllerRoot.#variables.wheels.name#")._initControllerObject(variables.wheels.name, arguments.params)>
</cffunction>


<cffunction name="_initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="params" type="any" required="true">
	<cflock name="controllerLock" type="readonly" timeout="30">
		<cfset variables.wheels = application.wheels.controllers[arguments.name].getControllerClassData()>
	</cflock>
	<cfset variables.params = arguments.params>
	<cfreturn this>
</cffunction>


<cffunction name="getControllerClassData" returntype="any" access="public" output="false">
	<cfreturn variables.wheels>
</cffunction>