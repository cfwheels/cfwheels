<cfset application.wheels.modelPath = listchangedelims(application.wheels.rootPath & "/wheels/tests", '/', '/')>
<cfset application.wheels.modelComponentPath = listchangedelims(application.wheels.rootcomponentPath & ".wheels.tests", '.', '.')>
<cfset application.wheels.dataSourceName = "wheelstestdb">
<cfset application.wheels.dataSourceUserName = "wheelstestdb">
<cfset application.wheels.dataSourcePassword = "wheelstestdb">