<cfset this.name = listLast(replace(getDirectoryFromPath(getBaseTemplatePath()), "\", "/", "all"), "/")>
<cfset this.sessionmanagement = true>
<cfset this.mappings["/wheels"] = getDirectoryFromPath(getCurrentTemplatePath())>

<cffunction name="onApplicationStart" output="false">
	<cfset var local = structNew()>
	<cfinclude template="events/onapplicationstart.cfm">
	<cfinclude template="../events/onapplicationstart.cfm">
</cffunction>

<cffunction name="onSessionStart" output="false">
	<cfset var local = structNew()>
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="events/onsessionstart.cfm">
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
			<cfinclude template="events/onmaintenance.cfm">
			<cfif structKeyExists(URL, "except")>
				<cfset application.settings.ip_exceptions = URL.except>
			</cfif>
			<cfif len(application.settings.ip_exceptions) IS 0 OR listFind(application.settings.ip_exceptions, CGI.remote_addr) IS 0>
				<cfinclude template="../events/onmaintenance.cfm">
				<cfabort>
			</cfif>
		</cfif>
		<cfinclude template="events/onrequeststart.cfm">
		<cfinclude template="../events/onrequeststart.cfm">
	</cflock>
	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.running_request_start = getTickCount() - request.wheels.execution.components.running_request_start>
	</cfif>
</cffunction>

<cffunction name="onRequest" output="true">
	<cfargument name="targetpage">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="events/onrequest.cfm">
	</cflock>
</cffunction>

<cffunction name="onRequestEnd" output="true">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfif application.settings.show_debug_information>
		<cfset request.wheels.execution.components.running_request_end = getTickCount()>
	</cfif>
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="events/onrequestend.cfm">
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
	<cfset var local = structNew()>
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="events/onsessionend.cfm">
		<cfinclude template="../events/onsessionend.cfm">
	</cflock>
</cffunction>

<cffunction name="onApplicationEnd" output="false">
	<cfargument name="applicationscope">
	<cfset var local = structNew()>
	<cfinclude template="events/onapplicationend.cfm">
	<cfinclude template="../events/onapplicationend.cfm">
</cffunction>

<cffunction name="onMissingTemplate" output="true">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfinclude template="events/onmissingtemplate.cfm">
	<cfinclude template="../events/onmissingtemplate.cfm">
</cffunction>

<cffunction name="onError" output="true">
	<cfargument name="exception">
	<cfargument name="eventname">
	<cfset var local = structNew()>
	<cfsetting requesttimeout="120">
	<cfset local.run_time = dateDiff("s", GetPageContext().GetFusionContext().GetStartTime(), now())>
	<cfsetting requesttimeout="#(local.run_time+10)#">
	<cfinclude template="events/onerror.cfm">
	<cfif application.settings.show_error_information>
		<cfthrow object="#arguments.exception#">
	<cfelse>
		<cfinclude template="../events/onerror.cfm">
	</cfif>
</cffunction>