<cfset application.wheels = structNew()>
<cfset application.wheels.version = "0.7">
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
<cfif structKeyExists(URL, "reload") AND NOT isBoolean(URL.reload)>
	<cfset application.settings.environment = URL.reload>
<cfelse>
	<cfinclude template="../../config/environment.cfm">
</cfif>
<cfinclude template="../../config/settings.cfm">
<cfinclude template="../../config/environments/#application.settings.environment#.cfm">

<!--- Load routes --->
<cfinclude template="../../config/routes.cfm">

<cfset application.wheels.web_path = replace(CGI.script_name, reverse(spanExcluding(reverse(CGI.script_name), "/")), "")>
<cfif application.wheels.web_path IS "/">
	<cfset application.wheels.cfc_path = "">
<cfelse>
	<cfset application.wheels.cfc_path = replace(right(application.wheels.web_path, len(application.wheels.web_path)-1), "/", ".", "all")>
</cfif>

<cfif len(application.settings.dsn) GT 0>
	<!--- determine and set database brand --->
	<cfquery name="local.database" datasource="#application.settings.dsn#" timeout="10" username="#application.settings.username#" password="#application.settings.password#">
	SELECT @@version AS info
	</cfquery>
	<cfif local.database.info Contains "SQL Server">
		<cfset application.wheels.database.type = "sqlserver">
	<cfelse>
		<cfset application.wheels.database.type = "mysql">
	</cfif>
	<cfset application.wheels.adapter = createObject("component", "#application.wheels.cfc_path#wheels.model.adapters.#application.wheels.database.type#")>
</cfif>

<cfset application.wheels.dispatch = createObject("component", "#application.wheels.cfc_path#Dispatch")>
<cfset application.wheels.java_awt_toolkit = createObject("java", "java.awt.Toolkit")>