<cfset $$oldCGIScope = request.cgi>
<cfset params = {controller="dummy", action="dummy"}>
<cfset loc.controller = controller("dummy", params)>
