<cfif StructKeyExists(server, "railo")>
	<cfinclude template="internal.cfm">
	<cfinclude template="public.cfm">
<cfelse>
	<cfinclude template="wheels/global/internal.cfm">
	<cfinclude template="wheels/global/public.cfm">
</cfif>