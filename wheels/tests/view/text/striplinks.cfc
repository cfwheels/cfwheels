<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>
	<cfset global.args = {}>
	<cfset global.args.html = 'this <a href="http://www.google.com" title="google">is</a> a <a href="mailto:someone@example.com" title="invalid email">test</a> to <a name="anchortag">see</a> if this works or not.'>

	<cffunction name="test_all_links_should_be_stripped">
		<cfset loc.e = loc.controller.striplinks(argumentcollection=loc.args)>
		<cfset loc.r = "this is a test to see if this works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>