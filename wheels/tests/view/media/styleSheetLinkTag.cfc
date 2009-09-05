<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.source = "test.css,test1.css">
		<cfset global.result = '<link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test.css" rel="stylesheet" /><link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test1.css" rel="stylesheet" />'>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc.e = global.controller.styleSheetLinkTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq global.result")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc.a.source = "test,test1.css">
		<cfset loc.e = global.controller.styleSheetLinkTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq global.result")>
	</cffunction>

</cfcomponent>