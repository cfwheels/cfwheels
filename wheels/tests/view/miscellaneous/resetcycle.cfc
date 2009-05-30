<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.values = "1,2,3,4,5,6">
		<cfset args.name = "cycle_test_2">
		<cfset container = listtoarray(args.values)>
	</cffunction>

	<cffunction name="test_named">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfloop array="#container#" index="loc.r">
			<cfset controller.cycle(argumentcollection=loc.a)>
		</cfloop>
		<cfset assert("request.wheels.cycle[loc.a.name] eq 6")>
		<cfset controller.resetcycle(loc.a.name)>
		<cfset assert("not structkeyexists(request.wheels.cycle, loc.a.name)")>
	</cffunction>

	<cffunction name="test_not_named">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "name")>
		<cfloop array="#container#" index="loc.r">
			<cfset controller.cycle(argumentcollection=loc.a)>
		</cfloop>
		<cfset assert("request.wheels.cycle['default'] eq 6")>
		<cfset controller.resetcycle()>
		<cfset assert("not isdefined('request.wheels.cycle.default')")>
	</cffunction>

</cfcomponent>