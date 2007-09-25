<cfif CGI.server_name Contains ".">
	<cfset application.settings.send_email_on_error = true>
	<cfset application.settings.error_email_address = "webmaster@" & reverse(listGetAt(reverse(CGI.server_name), 2,".")) & "." & reverse(listGetAt(reverse(CGI.server_name), 1, "."))>
<cfelse>
	<cfset application.settings.send_email_on_error = false>
</cfif>

<cfset application.settings.perform_caching = true>