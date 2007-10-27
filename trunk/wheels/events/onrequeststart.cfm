<cfset request.wheels = structNew()>
<cfset request.wheels.cache = structNew()>

<cfif application.settings.show_debug_information>
	<cfset request.wheels.execution = structNew()>
	<cfset request.wheels.execution.components = structNew()>
	<cfset request.wheels.execution.queries = structNew()>
	<cfset request.wheels.execution.partials = structNew()>
	<cfset request.wheels.execution.component_total = getTickCount()>
	<cfset request.wheels.execution.query_total = 0>
	<cfset request.wheels.execution.partial_total = 0>
	<cfset request.wheels.execution.components.running_request_start = getTickCount()>
</cfif>

<cfif NOT application.settings.cache_model_initialization>
	<!--- clear models in application scope so that the database and developer files get re-checked the next time a particular model is requested --->
	<cfset structClear(application.wheels.models)>
</cfif>

<cfif NOT application.settings.cache_routes>
	<!--- clear routes in application scope and reload them --->
	<cfset arrayClear(application.wheels.routes)>
	<cfinclude template="../../config/routes.cfm">
</cfif>
