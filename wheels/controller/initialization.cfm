<cffunction name="_initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">

	<cfset variables.wheels.name = arguments.name>
	<cfset variables.wheels.verifications = arrayNew(1)>
	<cfset variables.wheels.before_filters = arrayNew(1)>
	<cfset variables.wheels.after_filters = arrayNew(1)>
	<cfset variables.wheels.cachable_requests = arrayNew(1)>
	<cfset variables.wheels.cachable_actions = arrayNew(1)>

	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfreturn this>
</cffunction>


<cffunction name="CFW_createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn createObject("component", "controllers.#variables.wheels.name#")._initControllerObject(variables.wheels.name, arguments.params)>
</cffunction>


<cffunction name="_initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="params" type="any" required="true">
	<cflock name="controller_lock" type="readonly" timeout="30">
		<cfset variables.wheels = application.wheels.controllers[arguments.name].getControllerClassData()>
	</cflock>
	<cfset variables.params = arguments.params>
	<cfreturn this>
</cffunction>