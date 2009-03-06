<!--- Miscellaneous --->
<cfset application.settings.URLRewriting = ""> 
<cfset application.settings.tableNamePrefix = "">
<cfset application.settings.obfuscateURLs = false>
<cfset application.settings.reloadPassword = "">
<cfset application.settings.softDeleteProperty = "deletedAt">
<cfset application.settings.timeStampOnCreateProperty = "createdAt">
<cfset application.settings.timeStampOnUpdateProperty = "updatedAt">
<cfset application.settings.ipExceptions = "">

<!---
	The URLRewriting setting can bet set to "On", "Partial" or "Off".
	When left blank Wheels will try to determine the URL rewrite capabilities automatically.
	To run with "Partial" rewriting the "cgi.path_info" variable needs to be supported by the web server.
	To run with rewriting "On" you need to apply the necessary rewrite rules on the web server first.
--->
<cfset application.settings.URLRewriting = ""> 

<!--- Default for functions --->
<cfset application.settings.get.parameterize = true>
<cfset application.settings.get.reload = false>
<cfset application.settings.findOne.parameterize = true>
<cfset application.settings.findOne.reload = false>
<cfset application.settings.findAll.parameterize = true>
<cfset application.settings.findAll.reload = false>
<cfset application.settings.exists.parameterize = true>
<cfset application.settings.exists.reload = false>
<cfset application.settings.updateAll.parameterize = true>
<cfset application.settings.updateAll.instantiate = false>
<cfset application.settings.deleteAll.parameterize = true>
<cfset application.settings.deleteAll.instantiate = false>
<cfset application.settings.update.parameterize = true>
<cfset application.settings.delete.parameterize = true>
<cfset application.settings.save.parameterize = true>
<cfset application.settings.validatesConfirmationOf.message = "[property] should match confirmation">
<cfset application.settings.validatesExclusionOf.message = "[property] is reserved">
<cfset application.settings.validatesFormatOf.message = "[property] is invalid">
<cfset application.settings.validatesInclusionOf.message = "[property] is not included in the list">
<cfset application.settings.validatesLengthOf.message = "[property] is the wrong length">
<cfset application.settings.validatesNumericalityOf.message = "[property] is not a number">
<cfset application.settings.validatesPresenceOf.message = "[property] can't be empty">
<cfset application.settings.validatesUniquenessOf.message = "[property] has already been taken">

<!--- Caching --->
<cfset application.settings.maximumItemsToCache = 1000>
<cfset application.settings.cacheCullPercentage = 10>
<cfset application.settings.cacheCullInterval = 5>
<cfset application.settings.defaultCacheTime = 15>