<cfset loc.route = {pattern="[controller]/[action]/[key]"}>
<cfset arrayAppend(application.wheels.routes, loc.route)>
<cfset loc.route = {pattern="[controller]/[action]"}>
<cfset arrayAppend(application.wheels.routes, loc.route)>
<cfset loc.route = {pattern="[controller]", action="index"}>
<cfset arrayAppend(application.wheels.routes, loc.route)>
<cfset loc.pos = 0>
<cfloop array="#application.wheels.routes#" index="loc.i">
	<cfset loc.pos = loc.pos + 1>
	<cfif StructKeyExists(loc.i, "name")>
		<cfset application.wheels.namedRoutePositions[loc.i.name] = loc.pos>
	</cfif>
</cfloop>