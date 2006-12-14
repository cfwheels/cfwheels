<!--- 
	IMPORTANT: Only use this file if you have ColdFusion MX 7 or higher
	If you have ColdFusion MX 6.1 you should use Application.cfm instead and can safely delete this file
--->
<cfcomponent>

	<cfset this.name = listLast(getDirectoryFromPath(getBaseTemplatePath()),'/')>
	<cfset this.clientManagement = false>
	<cfset this.sessionManagement = true>
	<cferror exception="cfwheels" template="/app/error.cfm" type="exception">
	
	<!--- Runs the first time the application is started --->
	<cffunction name="onApplicationStart">
		<cfinclude template="/cfwheels/on_application_start.cfm" >
	</cffunction>
	
	
	<!--- Runs when the application ends or the server is shut down --->
	<cffunction name="onApplicationEnd">
	
	</cffunction>
	
	
	<!--- Runs the first time a user comes to the site (when their session begins) --->
	<cffunction name="onSessionStart">
	
	</cffunction>
	
	
	<!--- Runs when a user's session expires --->
	<cffunction name="onSessionEnd">
	
	</cffunction>
	
	
	<!--- Runs before each page load --->
	<cffunction name="onRequestStart">
		<cftrace category="Wheels Request Start"></cftrace>
		<cfinclude template="/cfwheels/on_request_start.cfm">
	</cffunction>
	
	
	<!--- Runs at the end of each page load --->
	<cffunction name="onRequestEnd">
		<cfinclude template="/cfwheels/on_request_end.cfm">
		<cftrace category="Wheels Request End"></cftrace>
	</cffunction>


</cfcomponent>