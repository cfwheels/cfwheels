<cfset application.wheelsMapping.modelPath = listchangedelims(listprepend("wheels/tests/_assets/models", application.wheels.rootPath, "/"), "/", "/")>
<cfset application.wheelsMapping.modelComponentPath = listchangedelims(listprepend("wheelsMapping.tests._assets_models", application.wheels.rootcomponentPath, '.'), '.', '.')>
<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset application.wheels.dataSourceUserName = "wheelstestdb">
<cfset application.wheels.dataSourcePassword = "wheelstestdb">
<!--- unload all plugins before running core tests --->
<cfset application.wheels.plugins = {}>
<cfset application.wheels.mixins = {}>