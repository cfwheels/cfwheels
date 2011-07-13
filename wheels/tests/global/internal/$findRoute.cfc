<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.dispatch = createobject("component", "wheelsMapping.Dispatch")>
		<cfset SavedRoutes = duplicate(application.wheels.routes)>
		<cfset application.wheels.routes = []>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.routes = SavedRoutes>
	</cffunction>
	
	<cffunction name="test_findRoute_should_raise_route_not_found_error">
		<cfset addRoute(name="testFail", pattern="testFail/[bob1]", controller="test", action="fail")>
		<cfset addRoute(name="testFail", pattern="testFail/[bob2]", controller="test", action="fail")>
		<cfset $setNamedRoutePositions()>
		<cfset loc.r = raised('$findRoute(route="testFail")')>
		<cfset assert('loc.r eq "Wheels.RouteMatchNotFound"')>
	</cffunction>

</cfcomponent>