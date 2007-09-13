<cfset this.name = listLast(replace(getDirectoryFromPath(getBaseTemplatePath()), "\", "/", "all"), "/")>
<cfset this.sessionmanagement = true>

<cfinclude template="wheels/global/functions_from_root.cfm">

<cffunction name="onApplicationStart" output="false">
	<cfset var local = structNew()>
	<cfinclude template="events/onapplicationstart.cfm">
	<cfinclude template="../events/onapplicationstart.cfm">
</cffunction>

<cffunction name="onSessionStart" output="false">
	<cfset var local = structNew()>
	<cfinclude template="events/onsessionstart.cfm">
	<cfinclude template="../events/onsessionstart.cfm">
</cffunction>

<cffunction name="onRequestStart" output="false">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfinclude template="events/onrequeststart.cfm">
	<cfinclude template="../events/onrequeststart.cfm">
</cffunction>

<cffunction name="onRequest" output="true">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfinclude template="events/onrequest.cfm">
</cffunction>

<cffunction name="onRequestEnd" output="false">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfinclude template="events/onrequestend.cfm">
	<cfinclude template="../events/onrequestend.cfm">
</cffunction>

<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionscope">
  <cfargument name="applicationscope">
	<cfset var local = structNew()>
	<cfinclude template="events/onsessionend.cfm">
	<cfinclude template="../events/onsessionend.cfm">
</cffunction>

<cffunction name="onApplicationEnd" output="false">
	<cfargument name="applicationscope">
	<cfset var local = structNew()>
	<cfinclude template="events/onapplicationend.cfm">
	<cfinclude template="../events/onapplicationend.cfm">
</cffunction>

<cffunction name="onMissingTemplate" output="false">
	<cfargument name="targetpage">
	<cfset var local = structNew()>
	<cfinclude template="events/onmissingtemplate.cfm">
	<cfinclude template="../events/onmissingtemplate.cfm">
	<cfabort>
</cffunction>