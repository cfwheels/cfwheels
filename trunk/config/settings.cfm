<!--- miscellaneous --->
<cfset application.settings.tableNamePrefix = "">
<cfset application.settings.obfuscateURLs = false>
<cfset application.settings.reloadPassword = "">
<cfset application.settings.defaultSoftDeleteColumn = "deletedAt">
<cfset application.settings.defaultTimeStampOnCreateColumn = "createdAt">
<cfset application.settings.defaultTimeStampOnUpdateColumn = "updatedAt">
<cfset application.settings.ipExceptions = "">

<!--- default for functions --->
<cfset application.settings.findById.parameterize = true>
<cfset application.settings.findById.reload = false>
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

<!--- caching --->
<cfset application.settings.maximumItemsToCache = 1000>
<cfset application.settings.cacheCullPercentage = 10>
<cfset application.settings.cacheCullInterval = 5>
<cfset application.settings.defaultCacheTime = 15>