<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset structappend(args, application.wheels.javaScriptIncludeTag)>
		<cfset args.source = "test.js,test1.js">
		<cfset result = '<script src="#application.wheels.webpath#javascripts/test.js" type="text/javascript"></script><script src="#application.wheels.webpath#javascripts/test1.js" type="text/javascript"></script>'>
	</cffunction>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.r = result>
		<cfset loc.e = variables.controller.javaScriptIncludeTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.source = "test,test1.js">
		<cfset loc.r = result>
		<cfset loc.e = variables.controller.javaScriptIncludeTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>