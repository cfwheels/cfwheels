<!--- Possible values are "development" and "production" --->
<cfset application.settings.environment = "development">

<!--- When set to true your webserver must use URL rewriting --->
<cfset application.settings.rewriteURLs = true>

<!--- Path to the cfwheels folder relative from the web root (if you have ColdFusion MX 7 you can also use a mapping) --->
<cfset application.settings.folderLocation = "../cfwheels">
