<cffunction name="setup">
	<!--- make sure we remove flashkeep from the request --->
	<cfif structKeyExists(request, "wheels")>
		<cfset structDelete(request.wheels, "flashkeep")>
	</cfif>
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>
	<cfset loc.controller.$setFlashStorage("cookie")>
	<cfset loc.controller.flashClear()>
	<cfset loc.controller.$setFlashStorage("session")>
	<cfset loc.controller.flashClear()>
</cffunction>