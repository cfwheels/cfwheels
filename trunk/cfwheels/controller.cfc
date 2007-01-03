<cfcomponent name="Controller">
	
	<cfset variables.before_filters = arrayNew(1)>
	<cfset variables.after_filters = arrayNew(1)>

	<!--- Include controller functions --->
	<cfinclude template="#application.pathTo.functions#/controller_functions.cfm">

	<!--- Include common functions --->
	<cfinclude template="#application.pathTo.functions#/helper_functions.cfm">

	<!--- Include developer functions that should be available to all controllers --->
	<cfinclude template="#application.filePathTo.controllers#/application_functions.cfm">

</cfcomponent>
