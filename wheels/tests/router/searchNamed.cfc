<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="helpers.cfm">
	<cfset global.router = createobject("component", "wheelsMapping.Router").init()>
	
	<cffunction name="setup">
		<cfset global.router.$reload()>
	</cffunction>
	
	<cffunction name="test_not_found">
		<cfset loc.e = "Wheels.RouteNotFound">
		<cfset loc.r = raised('loc.router.searchNamed("home")')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_single_route_for_name">
		<cfset loc.router.add(name="home", pattern="", controller="wheels", action="index")>
		<cfset loc.data = loc.router.searchNamed("home")>
		<cfset loc.r = assertRoute(
			loc.data
			,"home"
			,""
			,"wheels"
			,"index"
			,""
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>
	
	<cffunction name="test_multiple_routes_for_name">
		<cfset loc.router.add(name="photos", pattern="/photos/[action]/[id]", controller="photos")>
		<cfset loc.router.add(name="photos", pattern="/photos/gallery/[id]", controller="photos", action="gallery")>
		<cfset loc.data = loc.router.searchNamed(route="photos", id="5")>
		<cfset loc.r = assertRoute(
			loc.data
			,"photos"
			,"/photos/gallery/[id]"
			,"photos"
			,"gallery"
			,"id"
		)>
		<cfset assert('loc.r eq true')>
		<cfset loc.data = loc.router.searchNamed(route="photos", action="index", id="5")>
		<cfset loc.r = assertRoute(
			loc.data
			,"photos"
			,"/photos/[action]/[id]"
			,"photos"
			,""
			,"action,id"
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>

</cfcomponent>