<!--- Reload the application if reload=true --->
<cfif structKeyExists(URL, "reload")>
	<cflock scope="application" type="exclusive" timeout="30">
		<cfset onApplicationStart()>
	</cflock>
</cfif>

<cfset request.wheels = structNew()>
<cfset request.wheels.cache = structNew()>

<cfif application.settings.environment IS NOT "production">
	<cfset request.wheels.execution = structNew()>
	<cfset request.wheels.execution.components = structNew()>
	<cfset request.wheels.execution.queries = structNew()>
	<cfset request.wheels.execution.partials = structNew()>
	<cfset request.wheels.execution.component_total = getTickCount()>
	<cfset request.wheels.execution.query_total = 0>
	<cfset request.wheels.execution.partial_total = 0>
</cfif>

<cfif application.settings.environment IS "development">
	<!--- clear models in application scope in development mode so that the database and developer files get re-checked once on each request --->
	<cfset structClear(application.wheels.models)>
	<!--- clear routes and reload them --->
	<cfset arrayClear(application.wheels.routes)>
	<cfinclude template="../../config/routes.cfm">
</cfif>