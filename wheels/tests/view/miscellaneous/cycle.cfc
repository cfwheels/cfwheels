<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.values = "1,2,3,4,5,6">
		<cfset args.name = "cycle_test">
		<cfset container = listtoarray(args.values)>
	</cffunction>

	<cffunction name="test_named">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfloop array="#container#" index="loc.r">
			<cfset loc.e = controller.cycle(argumentcollection=loc.a)>
			<cfset assert("loc.e eq loc.r")>
		</cfloop>
	</cffunction>

	<cffunction name="test_not_named">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "name")>
		<cfloop array="#container#" index="loc.r">
			<cfset loc.e = controller.cycle(argumentcollection=loc.a)>
			<cfset assert("loc.e eq loc.r")>
		</cfloop>
	</cffunction>

</cfcomponent>
