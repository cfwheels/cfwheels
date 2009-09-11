<cfset application.wheels.modelPath = listprepend("wheels/tests", application.wheels.rootPath, "/")>
<cfset application.wheels.modelComponentPath = listchangedelims(listprepend("wheels.tests", application.wheels.rootcomponentPath, '.'), '.', '.')>
<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset application.wheels.dataSourceUserName = "wheelstestdb">
<cfset application.wheels.dataSourcePassword = "wheelstestdb">