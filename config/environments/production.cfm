<cfset application.settings.send_email_on_error = true>
<cfset application.settings.error_email_address = "webmaster@" & reverse(listGetAt(reverse(CGI.server_name), 2,".")) & "." & reverse(listGetAt(reverse(CGI.server_name), 1, "."))>
<cfset application.settings.perform_caching = true>