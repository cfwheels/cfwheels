<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.source = "test.css,test1.css">
	<cfset global.result = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css" /><link href="#application.wheels.webpath#stylesheets/test1.css" media="all" rel="stylesheet" type="text/css" />'>

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