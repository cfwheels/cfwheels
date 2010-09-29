<cffunction name="setup">
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>
	<cfset loc.controller.$setFlashStorage("cookie")>
	<cfset loc.controller.flashClear()>
	<cfset loc.controller.$setFlashStorage("session")>
	<cfset loc.controller.flashClear()>
</cffunction>