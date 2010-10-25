<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.values = "1,2,3,4,5,6">
		<cfset loc.args.name = "cycle_test">
		<cfset loc.container = listtoarray(loc.args.values)>
	</cffunction>

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
