<cfset application.wheelsMapping.modelPath = listprepend("wheels/tests", application.wheels.rootPath, "/")>
<cfset application.wheelsMapping.modelComponentPath = listchangedelims(listprepend("wheelsMapping.tests", application.wheels.rootcomponentPath, '.'), '.', '.')>
<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset application.wheels.dataSourceUserName = "wheelstestdb">
<cfset application.wheels.dataSourcePassword = "wheelstestdb">
<!--- unload all plugins before running core tests --->
<cfset application.wheels.plugins = {}>
<cfset application.wheels.mixins = {}>