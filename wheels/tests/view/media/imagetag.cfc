<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.source = "../wheels/tests/wheelslogo.jpg">
	<cfset global.args.alt = "wheelstestlogo">
	<cfset global.args.class = "wheelstestlogoclass">
	<cfset global.args.id = "wheelstestlogoid">
	<cfset global.imagePath = application.wheels.webPath & application.wheels.imagePath>

	<cffunction name="test_just_source">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img src="#loc.imagePath#/#loc.args.source#" alt="Wheelslogo" width="123" height="90" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_an_alt">
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img src="#loc.imagePath#/#loc.args.source#" alt="#loc.args.alt#" width="123" height="90" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_class_and_id">
		<cfset loc.r = '<img id="#loc.args.id#" src="#loc.imagePath#/#loc.args.source#" alt="#loc.args.alt#" width="123" height="90" class="#loc.args.class#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_http">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "http://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.args.source#" alt="Logo" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_https">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "https://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.args.source#" alt="Logo" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>