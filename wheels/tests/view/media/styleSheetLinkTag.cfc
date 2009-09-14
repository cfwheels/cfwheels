<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.source = "test.css,test1.css">
	<cfset global.result = '<link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test.css" rel="stylesheet" /><link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test1.css" rel="stylesheet" />'>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.result")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc.args.source = "test,test1.css">
		<cfset loc.e = loc.controller.styleSheetLinkTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.result")>
	</cffunction>

</cfcomponent>