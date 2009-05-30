<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.text = "CFWheels test to do see if hightlight function works or not.">
		<cfset args.phrases = "hightlight function">
		<cfset args.class = "cfwheels-hightlight">
	</cffunction>

	<cffunction name="test_phrase_found">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.e = variables.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if <span class="cfwheels-hightlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.phrases = "xxxxxxxxx">
		<cfset loc.e = variables.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_found_no_class_defined">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "class")>
		<cfset loc.a.phrases = "hightlight function">
		<cfset loc.e = variables.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if <span class="highlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found_no_class_defined">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.phrases = "xxxxxxxxx">
		<cfset loc.e = variables.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>