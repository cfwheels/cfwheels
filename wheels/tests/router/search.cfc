<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="helpers.cfm">
	<cfset global.router = createobject("component", "wheelsMapping.Router").init()>
	
	<cffunction name="setup">
		<cfset global.router.$reload()>
	</cffunction>

	<cffunction name="test_not_found">
		<cfset loc.e = "Wheels.RouteNotFound">
		<cfset loc.r = raised('loc.router.search("/invalidroute")')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_implicit_controller_implicit_action_implicit_id">
		<cfset loc.router.add(pattern="/[controller]/[action]/[id]", controller="photos")>
		<cfset loc.r = assertRoute(
			loc.router.search('/photos/index/1')
			,""
			,"/[controller]/[action]/[id]"
			,""
			,""
			,"controller,action,id"
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>
	
	<cffunction name="test_explicit_controller_implicit_action_implicit_id">
		<cfset loc.router.add(pattern="/photos/[action]/[id]", controller="photos")>
		<cfset loc.r = assertRoute(
			loc.router.search('/photos/index/1')
			,""
			,"/photos/[action]/[id]"
			,"photos"
			,""
			,"action,id"
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>
	
	<cffunction name="test_explicit_controller_explicit_action_explicit_id">
		<cfset loc.router.add(pattern="/photos/index/1", controller="photos", action="index")>
		<cfset loc.r = assertRoute(
			loc.router.search('/photos/index/1')
			,""
			,"/photos/index/1"
			,"photos"
			,"index"
			,""
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>
	
	<cffunction name="test_explicit_controller_explicit_action_explicit_id_with_extra">
		<cfset loc.router.add(pattern="/photos/index/1", controller="photos", action="index")>
		<cfset loc.r = assertRoute(
			loc.router.search('/photos/index/1/a/b')
			,""
			,"/photos/index/1"
			,"photos"
			,"index"
			,""
		)>
		<cfset assert('loc.r eq true')>
	</cffunction>
	
</cfcomponent>