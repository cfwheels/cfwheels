<cfinclude template="controller/functions.cfm">
<cfinclude template="global/functions.cfm">
<cfinclude template="view/functions.cfm">
<cfinclude template="plugins/injection.cfm">
<cfif StructKeyExists(application, "wheels")>
	<cfinclude template="../#application.wheels.viewPath#/helpers.cfm">
</cfif>