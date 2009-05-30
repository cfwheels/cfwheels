<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.source = "../wheels/tests/wheelslogo.jpg">
		<cfset args.alt = "wheelstestlogo">
		<cfset args.class = "wheelstestlogoclass">
		<cfset args.id = "wheelstestlogoid">
		<cfset imagePath = application.wheels.webPath & application.wheels.imagePath>
	</cffunction>

	<cffunction name="test_just_source">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.r = '<img src="#imagePath#/#loc.a.source#" alt="Wheelslogo" width="123" height="90" />'>
		<cfset loc.e = variables.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset halt(false, "variables.controller.imageTag(argumentcollection=loc.a)")>
	</cffunction>

	<cffunction name="test_supplying_an_alt">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.r = '<img src="#imagePath#/#loc.a.source#" alt="#loc.a.alt#" width="123" height="90" />'>
		<cfset loc.e = variables.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset halt(false, "variables.controller.imageTag(argumentcollection=loc.a)")>
	</cffunction>

	<cffunction name="test_supplying_class_and_id">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.r = '<img id="#loc.a.id#" src="#imagePath#/#loc.a.source#" alt="#loc.a.alt#" width="123" height="90" class="#loc.a.class#" />'>
		<cfset loc.e = variables.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset halt(false, "variables.controller.imageTag(argumentcollection=loc.a)")>
	</cffunction>

	<cffunction name="test_grabbing_from_http">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.a.source = "http://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.a.source#" alt="Logo" />'>
		<cfset loc.e = variables.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset halt(false, "variables.controller.imageTag(argumentcollection=loc.a)")>
	</cffunction>

	<cffunction name="test_grabbing_from_https">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "alt")>
		<cfset structdelete(loc.a, "class")>
		<cfset structdelete(loc.a, "id")>
		<cfset loc.a.source = "https://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img src="#loc.a.source#" alt="Logo" />'>
		<cfset loc.e = variables.controller.imageTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
		<cfset halt(false, "variables.controller.imageTag(argumentcollection=loc.a)")>
	</cffunction>

</cfcomponent>