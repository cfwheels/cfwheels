<cfcomponent output="false">
	<cfif StructKeyExists(server, "bluedragon")>
		<cfset this.datasource = "wheelstestdb">
	</cfif>
	<cfinclude template="wheels/functions.cfm">
</cfcomponent>