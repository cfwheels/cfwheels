<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.values = "1,2,3,4,5,6">
	<cfset global.args.name = "cycle_test_2">
	<cfset global.container = listtoarray(global.args.values)>

	<cffunction name="test_named">
		<cfloop array="#loc.container#" index="loc.r">
			<cfset loc.controller.cycle(argumentcollection=loc.args)>
		</cfloop>
		<cfset assert("request.wheels.cycle[loc.args.name] eq 6")>
		<cfset loc.controller.resetcycle(loc.args.name)>
		<cfset assert("not structkeyexists(request.wheels.cycle, loc.args.name)")>
	</cffunction>

	<cffunction name="test_not_named">
		<cfset structdelete(loc.args, "name")>
		<cfloop array="#loc.container#" index="loc.r">
			<cfset loc.controller.cycle(argumentcollection=loc.args)>
		</cfloop>
		<cfset assert("request.wheels.cycle['default'] eq 6")>
		<cfset loc.controller.resetcycle()>
		<cfset assert("not isdefined('request.wheels.cycle.default')")>
	</cffunction>

</cfcomponent>