<cffunction name="_initControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">

	<cfset variables.class.name = arguments.name>
	<cfset variables.class.verifications = arrayNew(1)>
	<cfset variables.class.before_filters = arrayNew(1)>
	<cfset variables.class.after_filters = arrayNew(1)>
	<cfset variables.class.cachable_requests = arrayNew(1)>
	<cfset variables.class.cachable_actions = arrayNew(1)>

	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfreturn this>
</cffunction>


<cffunction name="_createControllerObject" returntype="any" access="public" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn createObject("component", "controllers.#variables.class.name#")._initControllerObject(variables.class.name, arguments.params)>
</cffunction>


<cffunction name="_initControllerObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="params" type="any" required="true">
	<cflock name="controller_lock" type="readonly" timeout="30">
		<cfset variables.class = application.wheels.controllers[arguments.name].getControllerClassData()>
	</cflock>
	<cfset variables.params = arguments.params>
	<cfreturn this>
</cffunction>