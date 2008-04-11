<cfset locals.route = {pattern="[controller]/[action]/[id]"}>
<cfset arrayAppend(application.wheels.routes, locals.route)>
<cfset locals.route = {pattern="[controller]/[action]"}>
<cfset arrayAppend(application.wheels.routes, locals.route)>
<cfset locals.route = {pattern="[controller]", action="index"}>
<cfset arrayAppend(application.wheels.routes, locals.route)>
<cfset locals.pos = 0>
<cfloop array="#application.wheels.routes#" index="locals.i">
	<cfset locals.pos++>
	<cfif structKeyExists(locals.i, "name")>
		<cfset application.wheels.namedRoutePositions[locals.i.name] = locals.pos>
	</cfif>
</cfloop>