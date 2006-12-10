<cfcomponent displayname="Application Controller" hint="The base class of all controllers">
	
	<cfset variables.beforeFilters = arrayNew(1)>
	<cfset variables.afterFilters = arrayNew(1)>

	<!--- Include common functions --->
	<cfinclude template="#application.pathTo.functions#/helper_functions.cfm">

	<!--- Include functions that should be available to all controllers --->
	<cfif fileExists(expandPath("#application.filePathTo.controllers#/application_functions.cfm"))>
		<cfinclude template="#application.filePathTo.controllers#/application_functions.cfm">
	</cfif>

	<!--- Include ColdFusion on Wheels controller functions --->
	<cfinclude template="#application.pathTo.functions#/controller_functions.cfm">

</cfcomponent>
