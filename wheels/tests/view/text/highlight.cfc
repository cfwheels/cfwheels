<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.text = "CFWheels test to do see if hightlight function works or not.">
		<cfset global.args.phrases = "hightlight function">
		<cfset global.args.class = "cfwheels-hightlight">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_phrase_found">
		<cfset loc.e = global.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if <span class="cfwheels-hightlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc.a.phrases = "xxxxxxxxx">
		<cfset loc.e = global.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_found_no_class_defined">
		<cfset structdelete(loc.a, "class")>
		<cfset loc.a.phrases = "hightlight function">
		<cfset loc.e = global.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if <span class="highlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found_no_class_defined">
		<cfset loc.a.phrases = "xxxxxxxxx">
		<cfset loc.e = global.controller.highlight(argumentcollection=loc.a)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>