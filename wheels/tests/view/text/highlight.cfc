<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.text = "CFWheels test to do see if hightlight function works or not.">
		<cfset loc.args.phrases = "hightlight function">
		<cfset loc.args.class = "cfwheels-hightlight">
	</cffunction>

	<cffunction name="test_phrase_found">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels test to do see if <span class="cfwheels-hightlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found">
		<cfset loc.args.phrases = "xxxxxxxxx">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_found_no_class_defined">
		<cfset structdelete(loc.args, "class")>
		<cfset loc.args.phrases = "hightlight function">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels test to do see if <span class="highlight">hightlight function</span> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_phrase_not_found_no_class_defined">
		<cfset loc.args.phrases = "xxxxxxxxx">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels test to do see if hightlight function works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_delimiter">
		<cfset loc.args.delimiter = "|">
		<cfset loc.args.phrases = "test to|function|or not">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels <span class="cfwheels-hightlight">test to</span> do see if hightlight <span class="cfwheels-hightlight">function</span> works <span class="cfwheels-hightlight">or not</span>.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_mark_tag">
		<cfset loc.args.tag = "mark">
		<cfset loc.e = loc.controller.highlight(argumentcollection=loc.args)>
		<cfset loc.r = 'CFWheels test to do see if <mark class="cfwheels-hightlight">hightlight function</mark> works or not.'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>