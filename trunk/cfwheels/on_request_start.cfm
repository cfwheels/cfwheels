<cfif left(cgi.script_name, 5) IS "/app/" OR left(cgi.script_name, 10) IS "/cfwheels/">
	<cfthrow type="wheels.unauthorized_access" message="Unauthorized Access: The 'app' and 'cfwheels' folders cannot be accessed from the web." detail="Create a new folder and place the file you want to access there instead.">
</cfif>

<cfif structKeyExists(url, "reload")>
	<cfset structDelete(application, "wheels")>
	<cfinclude template="/wheels/on_application_start.cfm">
</cfif>

<cfset request.wheels = structNew()>
<cfset request.wheels.taken_objects = "">

<cfinclude template="#application.pathTo.includes#/request_functions.cfm">