<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
	</cffunction>

	<cffunction name="test_should_handle_extensions_nonextensions_and_multiple_extensions">
		<cfset loc.args.source = "test,test.css,jquery.dataTables.min,jquery.dataTables.min.css">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_no_automatic_extention_when_cfm">
		<cfset loc.args.source = "test.cfm,test.css.cfm">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="#application.wheels.webpath#stylesheets/test.cfm" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css.cfm" media="all" rel="stylesheet" type="text/css" />#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_support_external_links">
		<cfset loc.args.source = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css,test.css,https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_allow_specification_of_delimiter">
		<cfset loc.args.source = "test|test.css|http://fonts.googleapis.com/css?family=Istok+Web:400,700">
		<cfset loc.args.delim = "|">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="http://fonts.googleapis.com/css?family=Istok+Web:400,700" media="all" rel="stylesheet" type="text/css" />#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

<cffunction name="test_type_media_arguments">
		<cfset loc.args.source = "test.css">
		<cfset loc.args.media = "">
		<cfset loc.args.type = "">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="#application.wheels.webpath#stylesheets/test.css" rel="stylesheet" />#chr(10)#'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>