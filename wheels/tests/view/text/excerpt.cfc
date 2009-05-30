<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.text = "CFWheels: testing the excerpt view helper to see if it works or not.">
		<cfset args.phrase = "CFWheels: testing the excerpt">
		<cfset args.radius = "0">
		<cfset args.excerptString = "[more]">
	</cffunction>

	<cffunction name="test_phrase_at_the_beginning">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "CFWheels: testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.phrase = "testing the excerpt">
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start_or_end">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.phrase = "excerpt view helper">
		<cfset loc.a.radius = "10">
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]sting the excerpt view helper to see if[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.phrase = "excerpt view helper">
		<cfset loc.a.radius = "25">
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "CFWheels: testing the excerpt view helper to see if it works or no[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_end">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.radius = "25">
		<cfset loc.a.phrase = "see if it works">
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "[more]e excerpt view helper to see if it works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.radius = "25">
		<cfset loc.a.phrase = "jklsduiermobk">
		<cfset loc.e = variables.controller.excerpt(argumentcollection=loc.a)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>