<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.values = "1,2,3,4,5,6">
		<cfset global.args.name = "cycle_test_2">
		<cfset global.container = listtoarray(global.args.values)>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_named">
		<cfloop array="#global.container#" index="loc.r">
			<cfset global.controller.cycle(argumentcollection=loc.a)>
		</cfloop>
		<cfset assert("request.wheels.cycle[loc.a.name] eq 6")>
		<cfset global.controller.resetcycle(loc.a.name)>
		<cfset assert("not structkeyexists(request.wheels.cycle, loc.a.name)")>
	</cffunction>

	<cffunction name="test_not_named">
		<cfset structdelete(loc.a, "name")>
		<cfloop array="#global.container#" index="loc.r">
			<cfset global.controller.cycle(argumentcollection=loc.a)>
		</cfloop>
		<cfset assert("request.wheels.cycle['default'] eq 6")>
		<cfset global.controller.resetcycle()>
		<cfset assert("not isdefined('request.wheels.cycle.default')")>
	</cffunction>

</cfcomponent>