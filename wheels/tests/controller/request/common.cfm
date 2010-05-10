<cfinclude template="/wheelsMapping/global/functions.cfm">

<cfset params = {controller="dummy", action="dummy"}>
<cfset controller = $controller(name="dummy").$createControllerObject(params)>

<cffunction name="setup">
	<cfset $$oldCGIScope = request.cgi>
</cffunction>

<cffunction name="teardown">
	<cfset request.cgi = $$oldCGIScope>
</cffunction>