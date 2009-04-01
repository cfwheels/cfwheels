<cfset this.rootDir = GetDirectoryFromPath(GetBaseTemplatePath())>
<cfset this.name = Hash(this.rootDir & cgi.http_host)>
<cfset this.mappings["/wheels"] = this.rootDir & "wheels">
<cfset this.sessionManagement = true>
<cfif StructKeyExists(server, "railo")>
	<cfinclude template="global/appfunctions.cfm">
	<cfinclude template="controller/appfunctions.cfm">
	<cfinclude template="events/onapplicationstart.cfm">
	<cfinclude template="events/onsessionstart.cfm">
	<cfinclude template="events/onrequeststart.cfm">
	<cfinclude template="events/onrequest.cfm">
	<cfinclude template="events/onrequestend.cfm">
	<cfinclude template="events/onsessionend.cfm">
	<cfinclude template="events/onapplicationend.cfm">
	<cfinclude template="events/onmissingtemplate.cfm">
	<cfinclude template="events/onerror.cfm">
	<cfinclude template="../events/functions.cfm">
<cfelse>
	<cfinclude template="wheels/global/appfunctions.cfm">
	<cfinclude template="wheels/controller/appfunctions.cfm">
	<cfinclude template="wheels/events/onapplicationstart.cfm">
	<cfinclude template="wheels/events/onsessionstart.cfm">
	<cfinclude template="wheels/events/onrequeststart.cfm">
	<cfinclude template="wheels/events/onrequest.cfm">
	<cfinclude template="wheels/events/onrequestend.cfm">
	<cfinclude template="wheels/events/onsessionend.cfm">
	<cfinclude template="wheels/events/onapplicationend.cfm">
	<cfinclude template="wheels/events/onmissingtemplate.cfm">
	<cfinclude template="wheels/events/onerror.cfm">
	<cfinclude template="events/functions.cfm">
</cfif>