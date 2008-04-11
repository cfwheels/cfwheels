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
<cfif CGI.SERVER_NAME Contains ".">
	<cfset application.settings.sendEmailOnError = true>
	<cfset application.settings.errorEmailAddress = "webmaster@" & reverse(listGetAt(reverse(CGI.SERVER_NAME), 2,".")) & "." & reverse(listGetAt(reverse(CGI.SERVER_NAME), 1, "."))>
<cfelse>
	<cfset application.settings.sendEmailOnError = false>
</cfif>