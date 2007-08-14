<!---
	IMPORTANT: Only use this file if you have ColdFusion MX 7 or higher
	If you have ColdFusion MX 6.1 you should use Application.cfm instead and can safely delete this file
--->
<cfcomponent>
<!--- URL rewrite code.. --->
<cfif cgi.script_name is "/snap">
	<cfif cgi.path_info IS NOT cgi.script_name>
		<cfset URL.wheels = cgi.path_info>
	</cfif>
</cfif>


<cfif left(path_info,3) IS "/r/"> <!--- r for recording --->
	<!--- http://production.singsnap.com/snap/r/c937522f15242723 --->
	<cfset r = reverse(left(reverse(path_info),len(path_info)-3))>
	<cflocation url="http://#cgi.server_name#/snap/watchAndListen/play/#r#" addtoken="No">
</cfif>

<cfif left(path_info,3) IS "/e/"> <!--- e for embedded player --->
	<cfset e = reverse(left(reverse(path_info),len(path_info)-3))>
	<cfheader statuscode="303" statustext="See Other">
	<cfheader name="Location" value="http://#cgi.server_name#/snap/watchAndListen/embeddedPlay/#e#">
	<cfcontent type="text/plain">
	<cfabort>
</cfif>


	<cfset this.name = listLast(getDirectoryFromPath(getBaseTemplatePath()),'\')>
	<cfset this.clientManagement = false>
	<cfset this.sessionManagement = true>


	<cffunction name="onApplicationStart">
		<cfinclude template="/cfwheels/on_application_start.cfm">
		<cfset request.wheels.run_on_application_start = true>
		<cfreturn true>
	</cffunction>


	<cffunction name="onSessionStart">

		<!--- Check for banned users --->
		<cfquery name="banned_ip_check" datasource="ss_userlevel">
		SELECT ip_address FROM banned_ips WHERE ip_address = '#CGI.remote_addr#'
		</cfquery>
		<cfif banned_ip_check.recordcount IS NOT 0>
			<cfif structKeyExists(cookie, "screen_name")>
				<cfcookie name="screen_name" expires="now">
			</cfif>
		</cfif>

	</cffunction>


	<cffunction name="onRequestStart">
		<cftrace category="Wheels Request Start"></cftrace>
		<cfinclude template="/cfwheels/on_request_start.cfm">
	</cffunction>


	<cffunction name="onRequestEnd">
		<cfinclude template="/cfwheels/on_request_end.cfm">
		<cftrace category="Wheels Request End"></cftrace>
	</cffunction>

</cfcomponent>