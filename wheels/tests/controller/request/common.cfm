<cfset params = {controller="dummy", action="dummy"}>
<cfset loc.controller = controller("dummy", params)>

<cffunction name="setup">
	<cfset $$oldCGIScope = request.cgi>
</cffunction>

<cffunction name="teardown">
	<cfset request.cgi = $$oldCGIScope>
</cffunction>