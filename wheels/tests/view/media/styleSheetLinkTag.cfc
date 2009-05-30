<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset structappend(args, application.wheels.styleSheetLinkTag)>
		<cfset args.source = "test.css,test1.css">
		<cfset result = '<link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test.css" rel="stylesheet" /><link media="all" type="text/css" href="#application.wheels.webpath#stylesheets/test1.css" rel="stylesheet" />'>
	</cffunction>

	<cffunction name="test_both_templates_have_extensions">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.r = result>
		<cfset loc.e = variables.controller.styleSheetLinkTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_one_template_does_not_have_an_extension">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.source = "test,test1.css">
		<cfset loc.r = result>
		<cfset loc.e = variables.controller.styleSheetLinkTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>