<cfif left(cgi.script_name, 5) IS "/app/" OR left(cgi.script_name, 10) IS "/cfwheels/" OR left(cgi.script_name, 8) IS "/config/">
	<cfthrow type="wheels.unauthorized_access" message="Unauthorized Access: This file is in a folder that cannot be accessed from the web." detail="Create a new folder and place the file you want to access there.">
<cfelseif application.settings.environment IS "development" AND left(cgi.script_name, 11) IS "/generator/">
	<cfthrow type="wheels.unauthorized_access" message="Unauthorized Access: The ColdFusion on Wheels Generator cannot be accessed from the web in production mode." detail="Switch to development mode, restart the ColdFusion service and try again.">
</cfif>

<cfif structKeyExists(url, "reload")>
	<cfset structDelete(application, "wheels")>
	<cfinclude template="#application.pathTo.cfwheels#/on_application_start.cfm">
</cfif>

<cfset request.wheels = structNew()>
<cfset request.wheels.taken_objects = "">

<!--- Load developer on request start code --->
<cfinclude template="#application.pathTo.app#/on_request_start.cfm">

<cfinclude template="#application.pathTo.functions#/helper_functions.cfm">