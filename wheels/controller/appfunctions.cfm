<cfif StructKeyExists(server, "railo")>
	<cfinclude template="initialization.cfm">
	<cfinclude template="filters.cfm">
	<cfinclude template="flash.cfm">
	<cfinclude template="caching.cfm">
	<cfinclude template="rendering.cfm">
	<cfinclude template="redirection.cfm">
	<cfinclude template="miscellaneous.cfm">
<cfelse>
	<cfinclude template="wheels/controller/initialization.cfm">
	<cfinclude template="wheels/controller/filters.cfm">
	<cfinclude template="wheels/controller/flash.cfm">
	<cfinclude template="wheels/controller/caching.cfm">
	<cfinclude template="wheels/controller/rendering.cfm">
	<cfinclude template="wheels/controller/redirection.cfm">
	<cfinclude template="wheels/controller/miscellaneous.cfm">
</cfif>