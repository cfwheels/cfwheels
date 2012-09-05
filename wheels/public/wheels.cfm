<cfif StructKeyExists(params, "view")>
	<cfif application.wheels.environment IS "production">
		<cfabort>
	<cfelse>	
		<cfinclude template="#$fileForInclude(params.view)#">
	</cfif>
<cfelse>
	<cfinclude template="congratulations.cfm">
</cfif>