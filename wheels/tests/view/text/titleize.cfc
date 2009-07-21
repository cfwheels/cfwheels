<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args = {}>
		<cfset global.args.word = "this is a test to see if this works or not.">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_sentence_should_titleize">
		<cfset loc.e = global.controller.titleize(argumentcollection=loc.a)>
		<cfset loc.r = "This Is A Test To See If This Works Or Not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>