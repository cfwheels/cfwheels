<cfif StructKeyExists(server, "railo")>
	<cfinclude template="internal.cfm">
	<cfinclude template="public.cfm">
	<cfinclude template="cfml.cfm">
	<cfinclude template="../../events/functions.cfm">
<cfelse>
	<cfinclude template="wheels/global/internal.cfm">
	<cfinclude template="wheels/global/public.cfm">
	<cfinclude template="wheels/global/cfml.cfm">
	<cfinclude template="events/functions.cfm">
</cfif>