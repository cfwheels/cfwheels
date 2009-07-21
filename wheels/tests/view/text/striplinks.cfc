<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.html = 'this <a href="http://www.google.com" title="google">is</a> a <a href="mailto:someone@example.com" title="invalid email">test</a> to <a name="anchortag">see</a> if this works or not.'>
	</cffunction>
	
	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_all_links_should_be_stripped">
		<cfset loc.e = global.controller.striplinks(argumentcollection=loc.a)>
		<cfset loc.r = "this is a test to see if this works or not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>