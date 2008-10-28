<cffunction name="onRequestStart" output="false">
	<cfargument name="targetPage">
	<cfset var loc = {}>
		<cfif Right(arguments.targetPage, 4) IS ".cfc">
		<cfset StructDelete(this, "onRequest")>
		<cfset StructDelete(variables, "onRequest")>
	</cfif>
	<cfif StructKeyExists(URL, "reload") AND (Len(application.settings.reloadPassword) IS 0 OR (StructKeyExists(URL, "password") AND URL.password IS application.settings.reloadPassword))>
		<cflock scope="application" type="exclusive" timeout="30">
			<cfset onApplicationStart()>
		</cflock>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfif application.settings.environment IS "maintenance">
			<cfif StructKeyExists(URL, "except")>
				<cfset application.settings.ipExceptions = URL.except>
			</cfif>
			<cfif Len(application.settings.ipExceptions) IS 0 OR ListFind(application.settings.ipExceptions, cgi.remote_addr) IS 0>
				<cfinclude template="../../#application.wheels.eventPath#/onmaintenance.cfm">
				<cfabort>
			</cfif>
		</cfif>
		<cfset request.wheels = StructNew()>
		<cfset request.wheels.params = StructNew()>
		<cfset request.wheels.cache = StructNew()>
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution = StructNew()>
			<cfset request.wheels.execution.components = StructNew()>
			<cfset request.wheels.execution.componentTotal = GetTickCount()>
			<cfset request.wheels.execution.components.requestStart = GetTickCount()>
		</cfif>
		<cfif NOT application.settings.cacheModelInitialization>
			<cfset structClear(application.wheels.models)>
		</cfif>
		<cfif NOT application.settings.cacheControllerInitialization>
			<cfset structClear(application.wheels.controllers)>
		</cfif>
		<cfif NOT application.settings.cacheRoutes>
			<cfset arrayClear(application.wheels.routes)>
			<cfinclude template="../../#application.wheels.configPath#/routes.cfm">
			<cfinclude template="onapplicationstart/routes.cfm">
		</cfif>
		<cfif NOT application.settings.cacheDatabaseSchema>
			<cfset $clearCache("sql", "internal")>
		</cfif>
		<cfinclude template="../../#application.wheels.eventPath#/onrequeststart.cfm">
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution.components.requestStart = GetTickCount() - request.wheels.execution.components.requestStart>
		</cfif>
	</cflock>
</cffunction>
