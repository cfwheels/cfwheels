<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.dispatch = createobject("component", "wheelsMapping.dispatch")>
		<cfset SavedRoutes = duplicate(application.wheels.routes)>
		<cfset application.wheels.routes = []>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.routes = SavedRoutes>
	</cffunction>

	<cffunction name="test_empty_route">
		<cfset addRoute(name="", pattern="", controller="pages", action="index")>
		<cfset loc.r = loc.dispatch.$findMatchingRoute(route="", format="")>
		<cfset assert('loc.r.controller eq "pages"')>
		<cfset assert('loc.r.action eq "index"')>
	</cffunction>

	<cffunction name="test_controller_only">
		<cfset addRoute(name="", pattern="pages", controller="pages", action="index")>
		<cfset loc.r = loc.dispatch.$findMatchingRoute(route="/pages", format="")>
		<cfset assert('loc.r.controller eq "pages"')>
		<cfset assert('loc.r.action eq "index"')>
	</cffunction>

	<cffunction name="test_controller_and_action_required">
		<cfset addRoute(name="", pattern="pages/blah", controller="pages", action="index")>
 		<cfset loc.r = raised('loc.dispatch.$findMatchingRoute(route="/pages", format="")')>
		<cfset assert('loc.r eq "Wheels.RouteNotFound"')>
		<cfset loc.r = loc.dispatch.$findMatchingRoute(route="/pages/blah", format="")>
		<cfset assert('loc.r.controller eq "pages"')>
		<cfset assert('loc.r.action eq "index"')>
	</cffunction>

	<cffunction name="test_extra_variables_passed">
		<cfset addRoute(name="", pattern="pages/blah/[firstname]/[lastname]", controller="pages", action="index")>
		<cfset loc.r = loc.dispatch.$findMatchingRoute(route="/pages/blah/tony/petruzzi", format="")>
		<cfset assert('loc.r.controller eq "pages"')>
		<cfset assert('loc.r.action eq "index"')>
		<cfset assert('loc.r.variables eq "firstname,lastname"')>
	</cffunction>
	
	<cffunction name="test_wildcard_route">
		<cfset addRoute(name="", pattern="*", controller="pages", action="index")>
		<cfset loc.r = loc.dispatch.$findMatchingRoute(route="/thisismyroute/therearemanylikeit/butthisoneismine", format="")>
		<cfset assert('loc.r.controller eq "pages"')>
		<cfset assert('loc.r.action eq "index"')>
	</cffunction>

</cfcomponent>