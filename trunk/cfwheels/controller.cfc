<cfcomponent displayname="Application Controller" hint="The base class of all controllers">
	
	<cfset variables.beforeFilters = arrayNew(1)>
	<cfset variables.afterFilters = arrayNew(1)>

	<!--- Include ColdFusion on Wheels controller functions --->
	<cfinclude template="#application.pathTo.functions#/controller_functions.cfm">

	<!--- Include common functions --->
	<cfinclude template="#application.pathTo.functions#/helper_functions.cfm">

	<!--- Include developer functions that should be available to all controllers --->
	<cfinclude template="#application.filePathTo.controllers#/application_functions.cfm">

</cfcomponent>
