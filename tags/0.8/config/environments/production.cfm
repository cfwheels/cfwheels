<cfset application.settings.cacheDatabaseSchema = true>
<cfset application.settings.cacheImages = true>
<cfset application.settings.cacheModelInitialization = true>
<cfset application.settings.cacheControllerInitialization = true>
<cfset application.settings.cacheRoutes = true>
<cfset application.settings.cacheActions = true>
<cfset application.settings.cachePages = true>
<cfset application.settings.cachePartials = true>
<cfset application.settings.cacheQueries = true>
<cfset application.settings.showDebugInformation = false>
<cfset application.settings.showErrorInformation = false>
<cfif cgi.server_name Contains ".">
	<cfset application.settings.sendEmailOnError = true>
	<cfset application.settings.errorEmailAddress = "webmaster@" & Reverse(ListGetAt(Reverse(cgi.server_name), 2,".")) & "." & Reverse(ListGetAt(Reverse(cgi.server_name), 1, "."))>
<cfelse>
	<cfset application.settings.sendEmailOnError = false>
</cfif>