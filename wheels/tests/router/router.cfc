<cfcomponent extends="wheelsMapping.Test">

	<cfset global.router = createobject("component", "wheelsMapping.Router").init()>

	<cffunction name="test_containers_created">
		<cfset loc.data = loc.router.$inspect()>
		<cfset assert('structkeyexists(loc.data, "routes")')>
		<cfset assert('isstruct(loc.data.routes)')>
		<cfset assert('isstruct(loc.data.routes.named)')>
		<cfset assert('isarray(loc.data.routes.mapped)')>
	</cffunction>
	
	<cffunction name="test_reloading">
		<cfset loc.router.add(pattern="", controller="wheels", action="index")>
		<cfset loc.data = loc.router.$inspect()>
		<cfset assert('arraylen(loc.data.routes.mapped) eq 1')>
		<cfset loc.router.$reload()>
		<cfset loc.data = loc.router.$inspect()>
		<cfset assert('arraylen(loc.data.routes.mapped) eq 0')>
	</cffunction>
	
	<cffunction name="test_errors_thrown">
		<cfset loc.e = "Wheels.IncorrectArguments">
		<cfset loc.r = raised('loc.router.add(pattern="", action="index")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = raised('loc.router.add(pattern="", controller="wheels")')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>