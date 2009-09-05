<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.source = "test.js,test1.js">
		<cfset global.result = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/test1.js" type="text/javascript"></script>'>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc.e = global.controller.javaScriptIncludeTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq global.result")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc.a.source = "test,test1.js">
		<cfset loc.e = global.controller.javaScriptIncludeTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq global.result")>
	</cffunction>

</cfcomponent>