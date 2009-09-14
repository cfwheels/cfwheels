<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.values = "1,2,3,4,5,6">
	<cfset global.args.name = "cycle_test">
	<cfset global.container = listtoarray(global.args.values)>

	<cffunction name="test_named">
		<cfloop array="#loc.container#" index="loc.r">
			<cfset loc.e = loc.controller.cycle(argumentcollection=loc.args)>
			<cfset assert("loc.e eq loc.r")>
		</cfloop>
	</cffunction>

	<cffunction name="test_not_named">
		<cfset structdelete(loc.args, "name")>
		<cfloop array="#loc.container#" index="loc.r">
			<cfset loc.e = loc.controller.cycle(argumentcollection=loc.args)>
			<cfset assert("loc.e eq loc.r")>
		</cfloop>
	</cffunction>

</cfcomponent>
