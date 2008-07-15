<!--- path of calling application.cfc will become the root dir --->
<cfset this.rootDir = getDirectoryFromPath(getBaseTemplatePath())>
<!--- niffty way to have unique application names and not have to worry about the 64 character length limit --->
<cfset this.name = hash(this.rootDir)>
<cfset this.mappings["/wheels"] = this.rootDir & "wheels">
<cfset this.mappings["/controllerRoot"] = this.rootDir & "controllers">
<cfset this.mappings["/modelRoot"] = this.rootDir & "models">
<cfset this.sessionmanagement = true>

<cfif IsDefined("server.coldfusion.productname") AND server.coldfusion.productname IS "ColdFusion Server">
	<cfinclude template="wheels/base/internal.cfm">
	<cfinclude template="wheels/base/public.cfm">
<cfelse>
	<cfinclude template="base/internal.cfm">
	<cfinclude template="base/public.cfm">
</cfif>

<cffunction name="onApplicationStart" output="false">
	<cfset var loc = structNew()>
	<cfset application.wheels = structNew()>
	<cfset application.wheels.version = "0.7.1">
	<cfset application.wheels.controllers = structNew()>
	<cfset application.wheels.models = structNew()>
	<cfset application.wheels.routes = arrayNew(1)>
	<cfset application.wheels.namedRoutePositions = structNew()>
	<!--- Set up struct for caches --->
	<cfset application.wheels.cache = structNew()>
	<cfset application.wheels.cache.internal = structNew()>
	<cfset application.wheels.cache.internal.sql = structNew()>
	<cfset application.wheels.cache.internal.image = structNew()>
	<cfset application.wheels.cache.external = structNew()>
	<cfset application.wheels.cache.external.main = structNew()>
	<cfset application.wheels.cache.external.action = structNew()>
	<cfset application.wheels.cache.external.page = structNew()>
	<cfset application.wheels.cache.external.partial = structNew()>
	<cfset application.wheels.cache.external.query = structNew()>
	<cfset application.wheels.cacheLastCulledAt = now()>
	<!--- load environment settings --->
	<cfif structKeyExists(URL, "reload") AND NOT isBoolean(URL.reload) AND len(url.reload) AND (len(application.settings.reloadPassword) IS 0 OR (structKeyExists(URL, "password") AND URL.password IS application.settings.reloadPassword))>
		<cfset application.settings.environment = URL.reload>
	<cfelse>
		<cfinclude template="../config/environment.cfm">
	</cfif>
	<cfinclude template="../config/settings.cfm">
	<cfinclude template="../config/environments/#application.settings.environment#.cfm">
	<!--- Load developer routes and add wheels default ones --->
	<cfinclude template="../config/routes.cfm">
	<cfinclude template="routes.cfm">
	<cfset application.wheels.webPath = replace(cgi.script_name, reverse(spanExcluding(reverse(cgi.script_name), "/")), "")>
	<cftry>
		<!--- determine and set database brand --->
		<cfinclude template="../config/database.cfm">
		<cfset loc.info = $dbinfo(datasource=application.settings.database.datasource, type="version")>
		<cfif loc.info.driver_name Contains "MySQL">
			<cfset loc.adapterName = "MySQL">
		<cfelse>
			<cfset loc.adapterName = "MicrosoftSQLServer">
		</cfif>
		<cfif loc.info.recordCount>
			<cfset application.wheels.adapter = createObject("component", "wheels.model.adapters.#loc.adapterName#")>
		</cfif>
	<cfcatch>
	</cfcatch>
	</cftry>
	<cfset application.wheels.dispatch = createObject("component", "wheels.dispatch")>
	<cfinclude template="../events/onapplicationstart.cfm">
</cffunction>

<cffunction name="onSessionStart" output="false">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../events/onsessionstart.cfm">
	</cflock>
</cffunction>

<cffunction name="onRequestStart" output="false">
	<cfargument name="targetpage">
	<cfset var loc = structNew()>
	<cfif structKeyExists(URL, "reload") AND (len(application.settings.reloadPassword) IS 0 OR (structKeyExists(URL, "password") AND URL.password IS application.settings.reloadPassword))>
		<cflock scope="application" type="exclusive" timeout="30">
			<cfset onApplicationStart()>
		</cflock>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfif application.settings.environment IS "maintenance">
			<cfif structKeyExists(URL, "except")>
				<cfset application.settings.ipExceptions = URL.except>
			</cfif>
			<cfif len(application.settings.ipExceptions) IS 0 OR listFind(application.settings.ipExceptions, cgi.remote_addr) IS 0>
				<cfinclude template="../events/onmaintenance.cfm">
				<cfabort>
			</cfif>
		</cfif>
		<cfset request.wheels = structNew()>
		<cfset request.wheels.params = structNew()>
		<cfset request.wheels.cache = structNew()>
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution = structNew()>
			<cfset request.wheels.execution.components = structNew()>
			<cfset request.wheels.execution.componentTotal = getTickCount()>
			<cfset request.wheels.execution.components.requestStart = getTickCount()>
		</cfif>
		<cfif NOT application.settings.cacheModelInitialization>
			<cfset structClear(application.wheels.models)>
		</cfif>
		<cfif NOT application.settings.cacheControllerInitialization>
			<cfset structClear(application.wheels.controllers)>
		</cfif>
		<cfif NOT application.settings.cacheRoutes>
			<cfset arrayClear(application.wheels.routes)>
			<cfinclude template="../config/routes.cfm">
			<cfinclude template="routes.cfm">
		</cfif>
		<cfif NOT application.settings.cacheDatabaseSchema>
			<cfset $clearCache("sql", "internal")>
		</cfif>
		<cfinclude template="../events/onrequeststart.cfm">
	</cflock>
	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.requestStart = getTickCount() - request.wheels.execution.components.requestStart>
	</cfif>
</cffunction>

<cffunction name="onRequest" output="true">
	<cfargument name="targetpage">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="#arguments.targetpage#">
	</cflock>
</cffunction>

<cffunction name="onRequestEnd" output="true">
	<cfargument name="targetpage">
	<cfset var loc = structNew()>
	<cfif application.settings.showDebugInformation>
		<cfset request.wheels.execution.components.requestEnd = getTickCount()>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../events/onrequestend.cfm">
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution.components.requestEnd = getTickCount() - request.wheels.execution.components.requestEnd>
		</cfif>
		<cfinclude template="debug.cfm">
	</cflock>
</cffunction>

<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionscope">
  <cfargument name="applicationscope">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../events/onsessionend.cfm">
	</cflock>
</cffunction>

<cffunction name="onApplicationEnd" output="false">
	<cfargument name="applicationscope">
	<cfinclude template="../events/onapplicationend.cfm">
</cffunction>

<cffunction name="onMissingTemplate" output="true">
	<cfargument name="targetpage">
	<cfinclude template="../events/onmissingtemplate.cfm">
</cffunction>

<cffunction name="onError" output="true">
	<cfargument name="exception">
	<cfargument name="eventname">
	<cfif application.settings.sendEmailOnError>
		<cfmail to="#application.settings.errorEmailAddress#" from="#application.settings.errorEmailAddress#" subject="#application.applicationname# error" type="html">
			<cfinclude template="error.cfm">
		</cfmail>
	</cfif>
	<cfif application.settings.showErrorInformation>
		<cfif NOT StructKeyExists(arguments.exception, "cause")>
			<cfset arguments.exception.cause = arguments.exception>
		</cfif>
		<cfif arguments.exception.cause.type IS "wheels">
			<cfinclude template="errors/header.cfm">
			<cfinclude template="errors/error.cfm">
			<cfinclude template="errors/footer.cfm">
		<cfelse>
			<cfthrow object="#arguments.exception#">
		</cfif>
	<cfelse>
		<cfinclude template="../events/onerror.cfm">
	</cfif>
</cffunction>