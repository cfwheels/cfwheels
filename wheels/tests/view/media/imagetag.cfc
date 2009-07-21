<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.source = "../wheels/tests/wheelslogo.jpg">
		<cfset global.args.alt = "wheelstestlogo">
		<cfset global.args.class = "wheelstestlogoclass">
		<cfset global.args.id = "wheelstestlogoid">
		<cfset global.imagePath = application.wheels.webPath & application.wheels.imagePath>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_just_source">
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.r = '<img src="#global.imagePath#/#loc.a.source#" alt="Wheelslogo" width="123" height="90" />'>
		<cfset loc.e = global.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_an_alt">
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.r = '<img src="#global.imagePath#/#loc.a.source#" alt="#loc.a.alt#" width="123" height="90" />'>
		<cfset loc.e = global.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_class_and_id">
		<cfset loc.r = '<img id="#loc.a.id#" src="#global.imagePath#/#loc.a.source#" alt="#loc.a.alt#" width="123" height="90" class="#loc.a.class#" />'>
		<cfset loc.e = global.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_http">
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.a.source = "http://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.a.source#" alt="Logo" />'>
		<cfset loc.e = global.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_https">
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.a.source = "https://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.a.source#" alt="Logo" />'>
		<cfset loc.e = global.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>