<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.text = "CFWheels: testing the excerpt view helper to see if it works or not.">
		<cfset global.args.phrase = "CFWheels: testing the excerpt">
		<cfset global.args.radius = "0">
		<cfset global.args.excerptString = "[more]">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_phrase_at_the_beginning">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "CFWheels: testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning">
		<cfset loc.a.phrase = "testing the excerpt">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start_or_end">
		<cfset loc.a.phrase = "excerpt view helper">
		<cfset loc.a.radius = "10">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]sting the excerpt view helper to see if[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start">
		<cfset loc.a.phrase = "excerpt view helper">
		<cfset loc.a.radius = "25">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "CFWheels: testing the excerpt view helper to see if it works or no[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_end">
		<cfset loc.a.radius = "25">
		<cfset loc.a.phrase = "see if it works">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]e excerpt view helper to see if it works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc.a.radius = "25">
		<cfset loc.a.phrase = "jklsduiermobk">
		<cfset loc.e = global.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>