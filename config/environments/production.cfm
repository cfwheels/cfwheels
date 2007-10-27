<cfset application.settings.cache_images = true>
<cfset application.settings.cache_model_initialization = true>
<cfset application.settings.cache_controller_initialization = true>
<cfset application.settings.cache_routes = true>
<cfset application.settings.cache_requests = true>
<cfset application.settings.cache_actions = true>
<cfset application.settings.cache_pages = true>
<cfset application.settings.cache_partials = true>
<cfset application.settings.cache_queries = true>
<cfset application.settings.show_debug_information = false>
<cfset application.settings.show_error_information = false>
<cfif CGI.server_name Contains ".">
	<cfset application.settings.send_email_on_error = true>
	<cfset application.settings.error_email_address = "webmaster@" & reverse(listGetAt(reverse(CGI.server_name), 2,".")) & "." & reverse(listGetAt(reverse(CGI.server_name), 1, "."))>
<cfelse>
	<cfset application.settings.send_email_on_error = false>
</cfif>