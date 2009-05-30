<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.html = 'this <a href="http://www.google.com" title="google">is</a> a <a href="mailto:someone@example.com" title="invalid email">test</a> to <a name="anchortag">see</a> if this works or not.'>
	</cffunction>

	<cffunction name="test_all_links_should_be_stripped">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.e = variables.controller.striplinks(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test to see if this works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>