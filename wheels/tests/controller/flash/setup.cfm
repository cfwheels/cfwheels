<cffunction name="setup">
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller(name="dummy").new(params)>
	<cfset loc.controller.$setFlashStorage("cookie")>
	<cfset loc.controller.flashClear()>
	<cfset loc.controller.$setFlashStorage("session")>
	<cfset loc.controller.flashClear()>
</cffunction>