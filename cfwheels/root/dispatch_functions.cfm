<cffunction name="dispatch" access="remote" output="true">
	<cfset var methodName = "">
	<cfset var controllerName = "">
	<cfset var core = application.core>
	<cfset var requestString = url.wheelsaction>
	<cfset var routes = arrayNew(1)>
	<cfset var routeParams = arrayNew(1)>
	<cfset var foundRoute = structNew()>
	<cfset var params = structNew()>
	<cfset var thisPattern = "">
	<cfset var thisRoute = structNew()>
	<cfset var routeFileLocation = "">
	<cfset var routeFileHash = "">
	<cfset var datesStruct = structNew()>

	<cfinclude template="#application.pathTo.cfwheels#/dispatch.cfm">
		
</cffunction>
