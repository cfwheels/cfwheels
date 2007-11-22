<cfset this.name = listLast(replace(getDirectoryFromPath(getBaseTemplatePath()), "\", "/", "all"), "/")>
<cfset this.mappings["/wheels"] = getDirectoryFromPath(getBaseTemplatePath()) & "wheels">
<cfset this.mappings["/controllers"] = getDirectoryFromPath(getBaseTemplatePath()) & "controllers">
<cfset this.mappings["/models"] = getDirectoryFromPath(getBaseTemplatePath()) & "models">
<cfset this.sessionmanagement = true>

<cfinclude template="wheels/base/caching.cfm">
<cfinclude template="wheels/base/internal.cfm">
<cfinclude template="wheels/base/miscellaneous.cfm">
<cfinclude template="wheels/base/strings.cfm">

<cffunction name="onApplicationStart" output="false">
	<cfset var local = structNew()>
	<cfset application.wheels = structNew()>
	<cfset application.wheels.version = "0.7">
	<cfset application.wheels.controllers = structNew()>
	<cfset application.wheels.models = structNew()>
	<cfset application.wheels.routes = arrayNew(1)>
	<!--- Set up struct for caches --->
	<cfset application.wheels.cache = structNew()>
	<cfset application.wheels.cache.internal = structNew()>
	<cfset application.wheels.cache.internal.sql = structNew()>
	<cfset application.wheels.cache.internal.image = structNew()>
	<cfset application.wheels.cache.external = structNew()>
	<cfset application.wheels.cache.external.main = structNew()>
	<cfset application.wheels.cache.external.request = structNew()>
	<cfset application.wheels.cache.external.action = structNew()>
	<cfset application.wheels.cache.external.page = structNew()>
	<cfset application.wheels.cache.external.partial = structNew()>
	<cfset application.wheels.cache.external.query = structNew()>
	<cfset application.wheels.cache_last_culled_at = now()>
	<!--- load environment settings --->
	<cfif structKeyExists(URL, "reload") AND NOT isBoolean(URL.reload) AND (len(application.settings.reload_password) IS 0 OR (structKeyExists(URL, "password") AND URL.password IS application.settings.reload_password))>
		<cfset application.settings.environment = URL.reload>
	<cfelse>
		<cfinclude template="../config/environment.cfm">
	</cfif>
	<cfinclude template="../config/settings.cfm">
	<cfinclude template="../config/environments/#application.settings.environment#.cfm">
	<!--- Load routes --->
	<cfinclude template="../config/routes.cfm">
	<cfset application.wheels.web_path = replace(CGI.script_name, reverse(spanExcluding(reverse(CGI.script_name), "/")), "")>
	<cftry>
		<!--- determine and set database brand --->
		<cfinclude template="../config/database.cfm">
		<cfloop list="create,read,update,delete" index="local.i">
			<cfif application.settings.database[local.i].datasource IS "">
				<cfset application.settings.database[local.i].datasource = application.settings.database.datasource>
				<cfset application.settings.database[local.i].username = application.settings.database.username>
				<cfset application.settings.database[local.i].password = application.settings.database.password>
				<cfset application.settings.database[local.i].timeout = application.settings.database.timeout>
			</cfif>
		</cfloop>
		<cfquery name="local.database" datasource="#application.settings.database.read.datasource#" timeout="#application.settings.database.read.timeout#" username="#application.settings.database.read.username#" password="#application.settings.database.read.password#">
		SELECT @@version AS info
		</cfquery>
		<cfif local.database.info Contains "SQL Server">
			<cfset application.wheels.database.type = "sqlserver">
		<cfelse>
			<cfset application.wheels.database.type = "mysql">
		</cfif>
		<cfset application.wheels.adapter = createObject("component", "wheels.model.adapters.#application.wheels.database.type#")>
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
	<cfset var local = structNew()>
	<cfif structKeyExists(URL, "reload") AND (len(application.settings.reload_password) IS 0 OR (structKeyExists(URL, "password") AND URL.password IS application.settings.reload_password))>
		<cflock scope="application" type="exclusive" timeout="30">
			<cfset onApplicationStart()>
		</cflock>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfif application.settings.environment IS "maintenance">
			<cfif structKeyExists(URL, "except")>
				<cfset application.settings.ip_exceptions = URL.except>
			</cfif>
			<cfif len(application.settings.ip_exceptions) IS 0 OR listFind(application.settings.ip_exceptions, CGI.remote_addr) IS 0>
				<cfinclude template="../events/onmaintenance.cfm">
				<cfabort>
			</cfif>
		</cfif>
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
			<cfset structClear(application.wheels.models)>
		</cfif>
		<cfif NOT application.settings.cache_controller_initialization>
			<cfset structClear(application.wheels.controllers)>
		</cfif>
		<cfif NOT application.settings.cache_routes>
			<cfset arrayClear(application.wheels.routes)>
			<cfinclude template="../config/routes.cfm">
		</cfif>
		<cfif NOT application.settings.cache_database_schema>
			<cfset clearCache("sql", "internal")>
		</cfif>
		<cfinclude template="../events/onrequeststart.cfm">
	</cflock>
	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.running_request_start = getTickCount() - request.wheels.execution.components.running_request_start>
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
	<cfset var local = structNew()>
	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.running_request_end = getTickCount()>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../events/onrequestend.cfm">
		<cfif application.settings.show_debug_information>
			<cfset request.wheels.execution.components.running_request_end = getTickCount() - request.wheels.execution.components.running_request_end>
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
	<cfset var local = structNew()>
	<cfsetting requesttimeout="120">
	<cfset local.run_time = dateDiff("s", GetPageContext().GetFusionContext().GetStartTime(), now())>
	<cfsetting requesttimeout="#(local.run_time+10)#">
	<cfif application.settings.send_email_on_error>
		<cfmail to="#application.settings.error_email_address#" from="#application.settings.error_email_address#" subject="#application.applicationname# error" type="html">
			<cfinclude template="error.cfm">
		</cfmail>
	</cfif>
	<cfif application.settings.show_error_information>
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