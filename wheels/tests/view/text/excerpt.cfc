<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.text = "CFWheels: testing the excerpt view helper to see if it works or not.">
		<cfset loc.args.phrase = "CFWheels: testing the excerpt">
		<cfset loc.args.radius = "0">
		<cfset loc.args.excerptString = "[more]">
	</cffunction>

	<cffunction name="test_find_phrase_at_beginning">
		<cfset loc.args.phrase = "CFWheels: testing">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "CFWheels: testing[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_find_phrase_at_end">
		<cfset loc.args.phrase = "works or not.">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_find_phrase_within">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]excerpt view helper[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc.args.radius = "25">
		<cfset loc.args.phrase = "jklsduiermobk">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_radius_does_not_reach_start_or_end">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.args.radius = "10">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]sting the excerpt view helper to see if[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_radius_reaches_start">
		<cfset loc.args.phrase = "testing the">
		<cfset loc.args.radius = "15">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "CFWheels: testing the excerpt view h[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_radius_reaches_end">
		<cfset loc.args.radius = "10">
		<cfset loc.args.phrase = "see if it works">
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]helper to see if it works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_text_has_html_tags">
		<cfset loc.args.text = "CFWheels: <p>testing the</p> <b>excerpt</b> <i><b>view</b></i> helper to see if it works or not.">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.args.stripTags = true>
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]excerpt view helper[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_span_to_whole_words">
		<cfset loc.args.phrase = "excerpt view helper">
		<cfset loc.args.radius = 5>
		<cfset loc.args.wholeWords = true>
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]the excerpt view helper to see[more]">
		<cfset assert("loc.e eq loc.r")>
		
		<cfset loc.args.phrase = "works or not.">
		<cfset loc.args.radius = 5>
		<cfset loc.args.wholeWords = true>
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "[more]if it works or not.">
		<cfset assert("loc.e eq loc.r")>
		
		<cfset loc.args.phrase = "CFWheels: testing">
		<cfset loc.args.radius = 5>
		<cfset loc.args.wholeWords = true>
		<cfset loc.e = loc.controller.excerpt(argumentcollection=loc.args)>
		<cfset loc.r = "CFWheels: testing the excerpt[more]">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>