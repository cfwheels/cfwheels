<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.source = "../wheels/tests/_assets/files/wheelslogo.jpg">
		<cfset loc.args.alt = "wheelstestlogo">
		<cfset loc.args.class = "wheelstestlogoclass">
		<cfset loc.args.id = "wheelstestlogoid">
		<cfset loc.imagePath = application.wheels.webPath & application.wheels.imagePath>
	</cffunction>

	<cffunction name="test_just_source">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img alt="Wheelslogo" height="90" src="#loc.imagePath#/#loc.args.source#" width="123" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_an_alt">
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img alt="#loc.args.alt#" height="90" src="#loc.imagePath#/#loc.args.source#" width="123" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_class_and_id">
		<cfset loc.r = '<img alt="#loc.args.alt#" class="#loc.args.class#" height="90" id="#loc.args.id#" src="#loc.imagePath#/#loc.args.source#" width="123" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_http">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "http://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img alt="Logo" src="#loc.args.source#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_https">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "https://www.cfwheels.org/images/logo.jpg">
		<cfset loc.r = '<img alt="Logo" src="#loc.args.source#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_specifying_height_and_width">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.height = 25>
		<cfset loc.args.width = 25>
		<cfset loc.r = '<img alt="Wheelslogo" height="25" src="#loc.imagePath#/#loc.args.source#" width="25" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_height_only">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.height = 25>
		<cfset loc.r = '<img alt="Wheelslogo" height="25" src="#loc.imagePath#/#loc.args.source#" width="123" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_width_only">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.width = 25>
		<cfset loc.r = '<img alt="Wheelslogo" height="90" src="#loc.imagePath#/#loc.args.source#" width="25" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>