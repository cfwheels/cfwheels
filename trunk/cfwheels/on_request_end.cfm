<!--- Load developer on request end code --->
<cfinclude template="#application.pathTo.app#/on_request_end.cfm">

<!--- Set all taken objects to vacant again now that the request is complete --->
<cfif structKeyExists(request.wheels, "taken_objects")>
	<cfloop list="#request.wheels.taken_objects#" index="i">
		<cfset taken_object = structFindKey(application.wheels.pools, i, "one")>
		<cfset taken_object[1].value.status = "is_vacant">
	</cfloop>
</cfif>