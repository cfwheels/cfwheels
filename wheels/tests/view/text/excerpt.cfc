<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.text = "CFWheels: testing the excerpt view helper to see if it works or not.">
		<cfset loc.args.phrase = "CFWheels: testing the excerpt">
		<cfset loc.args.radius = "0">
		<cfset loc.args.excerptString = "[more]">
	</cffunction>

	<cffunction name="test_phrase_at_the_beginning">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "CFWheels: testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning">
		<cfset loc.args.phrase = "testing the excerpt">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start_or_end">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.args.radius = "10">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]sting the excerpt view helper to see if[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_start">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.args.radius = "25">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "CFWheels: testing the excerpt view helper to see if it works or no[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_at_the_beginning_radius_does_not_reach_end">
		<cfset loc.args.radius = "25">
		<cfset loc.args.phrase = "see if it works">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]e excerpt view helper to see if it works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc.args.radius = "25">
		<cfset loc.args.phrase = "jklsduiermobk">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>