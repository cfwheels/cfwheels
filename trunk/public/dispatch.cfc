<cfcomponent displayname="Dispatcher" hint="Takes the URL request and forwards it to the proper controller for processing">

	<cffunction name="dispatch" access="remote" output="true">

		<cfset var methodName = "">
		<cfset var controllerName = "">
		<cfset var core = application.core>
		<cfset var requestString = url.cf_request>
		<cfset var routes = arrayNew(1)>
		<cfset var routeParams = arrayNew(1)>
		<cfset var foundRoute = structNew()>
		<cfset var params = structNew()>
		<cfset var thisPattern = "">
		<cfset var thisRoute = structNew()>
		<cfset var routeFileLocation = "">
		<cfset var routeFileHash = "">
		<cfset var datesStruct = structNew()>

		<cfinclude template="/cfwheels/dispatch.cfm">
		
	</cffunction>

</cfcomponent>