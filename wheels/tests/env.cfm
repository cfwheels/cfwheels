<cfset application.wheels.modelPath = "/wheelsMapping/tests/_assets/models">
<cfset application.wheels.modelComponentPath = "wheelsMapping.tests._assets.models">
<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset application.wheels.dataSourceUserName = "wheelstestdb">
<cfset application.wheels.dataSourcePassword = "wheelstestdb">
<!--- unload all plugins before running core tests --->
<cfset application.wheels.plugins = {}>
<cfset application.wheels.mixins = {}>

<!--- turn off default validations for testing --->
<cfset application.wheels.setDefaultValidations = false />
<cfset application.wheels.assetQueryString = false />
<cfset application.wheels.assetPaths = false />