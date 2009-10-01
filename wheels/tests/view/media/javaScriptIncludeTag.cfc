<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.source = "test.js,test1.js">
	<cfset global.result = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/test1.js" type="text/javascript"></script>'>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.result")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc.args.source = "test,test1.js">
		<cfset loc.e = loc.controller.javaScriptIncludeTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.result")>
	</cffunction>

</cfcomponent>