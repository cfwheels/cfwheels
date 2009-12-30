<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>

	<cffunction name="test_should_handle_extensions_nonextensions_and_multiple_extensions">
		<cfset loc.args.source = "test,test.css,jquery.dataTables.min,jquery.dataTables.min.css">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset loc.r = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css" />#chr(10)#'>
		<cfset halt(halt=false, expression='htmleditformat(loc.e)', format="text")>
		<cfset halt(halt=false, expression='htmleditformat(loc.r)', format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>