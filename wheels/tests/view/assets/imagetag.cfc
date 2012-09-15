<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.oldViewPath = duplicate(application.wheels.imagePath)>
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.source = "../wheels/tests/_assets/files/cfwheels-logo.png">
		<cfset loc.args.alt = "wheelstestlogo">
		<cfset loc.args.class = "wheelstestlogoclass">
		<cfset loc.args.id = "wheelstestlogoid">
		<cfset loc.imagePath = application.wheels.webPath & application.wheels.imagePath>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset application.wheels.imagePath = loc.oldViewPath>
	</cffunction>

	<cffunction name="test_just_source">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img alt="Cfwheels logo" height="121" src="#loc.imagePath#/#loc.args.source#" width="93" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_an_alt">
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.r = '<img alt="#loc.args.alt#" height="121" src="#loc.imagePath#/#loc.args.source#" width="93" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_supplying_an_id_when_caching_is_on">
		<cfset loc.cacheImages = application.wheels.cacheImages>
		<cfset application.wheels.cacheImages = true>
		<cfset StructDelete(loc.args, "alt")>
		<cfset StructDelete(loc.args, "class")>
		<cfset loc.r = '<img alt="Cfwheels logo" height="121" src="#loc.imagePath#/#loc.args.source#" id="#loc.args.id#" width="93" />'>
		<cfset loc.e = loc.controller.imageTag(argumentCollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
		<cfset application.wheels.cacheImages = loc.cacheImages>
	</cffunction>

	<cffunction name="test_supplying_class_and_id">
		<cfset loc.r = '<img alt="#loc.args.alt#" class="#loc.args.class#" height="121" src="#loc.imagePath#/#loc.args.source#" id="#loc.args.id#" width="93" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_http">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "http://www.cfwheels.org/images/cfwheels-logo.png">
		<cfset loc.r = '<img alt="Cfwheels logo" src="#loc.args.source#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_grabbing_from_https">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.source = "https://www.cfwheels.org/images/cfwheels-logo.png">
		<cfset loc.r = '<img alt="Cfwheels logo" src="#loc.args.source#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_specifying_height_and_width">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.height = 25>
		<cfset loc.args.width = 25>
		<cfset loc.r = '<img alt="Cfwheels logo" height="25" src="#loc.imagePath#/#loc.args.source#" width="25" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_height_only">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.height = 25>
		<cfset loc.r = '<img alt="Cfwheels logo" height="25" src="#loc.imagePath#/#loc.args.source#" width="93" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_width_only">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.width = 25>
		<cfset loc.r = '<img alt="Cfwheels logo" height="121" src="#loc.imagePath#/#loc.args.source#" width="25" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_remove_height_width_attributes_when_set_to_false">
		<cfset structdelete(loc.args, "alt")>
		<cfset structdelete(loc.args, "class")>
		<cfset structdelete(loc.args, "id")>
		<cfset loc.args.height = false>
		<cfset loc.args.width = false>
		<cfset loc.r = '<img alt="Cfwheels logo" src="#loc.imagePath#/#loc.args.source#" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_setting_imagePath_to_external_resource">
		<cfset application.wheels.imagePath = "http://mycdn.example.com">
		<cfset loc.args.source = "/some/client/folder/cfwheels-logo.png">
		<cfset loc.r = '<img alt="wheelstestlogo" class="wheelstestlogoclass" src="http:/mycdn.example.com/some/client/folder/cfwheels-logo.png" id="wheelstestlogoid" />'>
		<cfset loc.e = loc.controller.imageTag(argumentcollection=loc.args)>
		<cfset assert("loc.r IS loc.e")>
	</cffunction>

</cfcomponent>