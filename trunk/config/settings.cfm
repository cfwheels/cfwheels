<!--- miscellaneous --->
<cfset application.settings.obfuscateURLs = false>
<cfset application.settings.reloadPassword = "">

<!--- validation --->
<cfset application.settings.validatesConfirmationOf.message = "[fieldName] should match confirmation">
<cfset application.settings.validatesExclusionOf.message = "[fieldName] is reserved">
<cfset application.settings.validatesFormatOf.message = "[fieldName] is invalid">
<cfset application.settings.validatesInclusionOf.message = "[fieldName] is not included in the list">
<cfset application.settings.validatesLengthOf.message = "[fieldName] is the wrong length">
<cfset application.settings.validatesNumericalityOf.message = "[fieldName] is not a number">
<cfset application.settings.validatesPresenceOf.message = "[fieldName] can't be empty">
<cfset application.settings.validatesUniquenessOf.message = "[fieldName] has already been taken">

<!--- caching --->
<cfset application.settings.maximumItemsToCache = 1000>
<cfset application.settings.cacheCullPercentage = 10>
<cfset application.settings.cacheCullInterval = 5>
<cfset application.settings.defaultCacheTime = 15>

<!--- paths --->
<cfset application.settings.paths.files = "files">
<cfset application.settings.paths.images = "images">
<cfset application.settings.paths.javascripts = "javascripts">
<cfset application.settings.paths.stylesheets = "stylesheets">
