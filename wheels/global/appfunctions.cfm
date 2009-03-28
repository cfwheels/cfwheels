<cfif StructKeyExists(server, "railo")>
	<cfinclude template="internal.cfm">
	<cfinclude template="public.cfm">
	<cfinclude template="cfml.cfm">
<cfelseif StructKeyExists(server, "bluedragon")>
	<cfinclude template="internal.cfm">
	<cfinclude template="public.cfm">
	<cfinclude template="cfml.cfm">
<cfelse>
	<cfinclude template="wheels/global/internal.cfm">
	<cfinclude template="wheels/global/public.cfm">
	<cfinclude template="wheels/global/cfml.cfm">
</cfif>