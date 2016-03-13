<cfif StructKeyExists(server, "railo") OR StructKeyExists(server, "lucee")>
	<cfinclude template="caching.cfm">
	<cfinclude template="filters.cfm">
	<cfinclude template="flash.cfm">
	<cfinclude template="initialization.cfm">
	<cfinclude template="layouts.cfm">
	<cfinclude template="miscellaneous.cfm">
	<cfinclude template="processing.cfm">
	<cfinclude template="provides.cfm">
	<cfinclude template="redirection.cfm">
	<cfinclude template="rendering.cfm">
	<cfinclude template="verifies.cfm">
<cfelse>
	<cfinclude template="wheels/controller/caching.cfm">
	<cfinclude template="wheels/controller/filters.cfm">
	<cfinclude template="wheels/controller/flash.cfm">
	<cfinclude template="wheels/controller/initialization.cfm">
	<cfinclude template="wheels/controller/layouts.cfm">
	<cfinclude template="wheels/controller/miscellaneous.cfm">
	<cfinclude template="wheels/controller/processing.cfm">
	<cfinclude template="wheels/controller/provides.cfm">
	<cfinclude template="wheels/controller/redirection.cfm">
	<cfinclude template="wheels/controller/rendering.cfm">
	<cfinclude template="wheels/controller/verifies.cfm">
</cfif>