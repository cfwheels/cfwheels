<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
		<cfset loc.args = {}>
	</cffunction>

	<cffunction name="test_should_handle_extensions_nonextensions_and_multiple_extensions">
		<cfset loc.args.source = "test,test.js,jquery.dataTables.min,jquery.dataTables.min.js">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script>#chr(10)#'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_no_automatic_extention_when_cfm">
		<cfset loc.args.source = "test.cfm,test.js.cfm">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.cfm" type="text/javascript"></script>#chr(10)#<script src="#application.wheels.webpath#javascripts/test.js.cfm" type="text/javascript"></script>#chr(10)#'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>