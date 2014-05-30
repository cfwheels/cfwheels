<!--- reload default settings --->
<cfinclude template="/wheelsMapping/events/onapplicationstart/settings.cfm">

<cfset application.wheels.controllerPath = "wheels/tests/_assets/controllers">
<cfset application.wheels.modelPath = "/wheelsMapping/tests/_assets/models">
<cfset application.wheels.modelComponentPath = "wheelsMapping.tests._assets.models">

<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset connection = createobject("component", "wheelsMapping.Connection").init(application.wheels.dataSourceName)>
<cfset application.wheels.dataAdapter = connection.name()>

<!--- unload all plugins before running core tests --->
<cfset application.wheels.plugins = {}>
<cfset application.wheels.mixins = {}>

<!--- turn off default validations for testing --->
<cfset application.wheels.automaticValidations = false />
<cfset application.wheels.assetQueryString = false />
<cfset application.wheels.assetPaths = false />

<!--- redirections should always be delayed when testing --->
<cfset application.wheels.functions.redirectTo.delay = true>

<!--- turn off transactions by default --->
<cfset application.wheels.transactionMode = "none">

<!--- turn off request query caching --->
<cfset application.wheels.cacheQueriesDuringRequest = false>