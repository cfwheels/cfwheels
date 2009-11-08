<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>

	<cffunction name="test_should_handle_extensions_nonextensions_and_multiple_extensions">
		<cfset loc.args.source = "test,test.js,jquery.dataTables.min,jquery.dataTables.min.js">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset loc.r = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/jquery.dataTables.min.js" type="text/javascript"></script>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>