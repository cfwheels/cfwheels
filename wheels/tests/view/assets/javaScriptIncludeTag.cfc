<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
	</cffunction>

	<cffunction name="test_should_handle_extensions_nonextensions_and_multiple_extensions">
		<cfset loc.args.source = "test,test.js,jquery.dataTables.min,jquery.dataTables.min.js">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script>#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_no_automatic_extention_when_cfm">
		<cfset loc.args.source = "test.cfm,test.js.cfm">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.cfm" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js.cfm" type="text/javascript"></script>#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_support_external_links">
		<cfset loc.args.source = "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js,test,https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_allow_specification_of_delimiter">
		<cfset loc.args.source = "test|test.js|http://fonts.googleapis.com/css?family=Istok+Web:400,700">
		<cfset loc.args.delim = "|">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="http://fonts.googleapis.com/css?family=Istok+Web:400,700" type="text/javascript"></script>#chr(10)#'>
		<cfset debug(expression='htmleditformat(loc.e)', display=false, format="text")>
		<cfset debug(expression='htmleditformat(loc.r)', display=false, format="text")>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_removing_type_argument">
		<cfset loc.args.source = "test.js">
		<cfset loc.args.type = "">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.js"></script>#chr(10)#'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_overloaded_arguments">
		<cfset loc.args.source = "test.js">
		<cfset loc.args.type = "">
		<cfset loc.args.async = "async">
		<cfset loc.args.defer = "defer">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script async="async" defer="defer" src="#application.wheels.webpath#javascripts/test.js"></script>#chr(10)#'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>