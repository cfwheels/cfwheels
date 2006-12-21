<!--- 
	IMPORTANT: Only use this file if you have ColdFusion MX 6.1
	If you have ColdFusion MX 7 or higher you should use Application.cfc instead and can safely delete this file
--->

<cfapplication name="#listLast(getDirectoryFromPath(getBaseTemplatePath()),'\')#" clientmanagement="false" sessionmanagement="true">

<cfif NOT structKeyExists(application, "initialized") OR NOT application.initialized>
	<cflock scope="application" type="exclusive" timeout="30">
		<cfif NOT structKeyExists(application, "initialized") OR NOT application.initialized>
			<cfinclude template="/cfwheels/on_application_start.cfm">
			<cfset request.wheels.run_on_application_start = true>
		</cfif>
	</cflock>
	<cfset application.initialized = true>
</cfif>

<cftrace category="Wheels Request Start"></cftrace>
<cfinclude template="/cfwheels/on_request_start.cfm">