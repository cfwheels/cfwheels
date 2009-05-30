<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset variables.controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.word = "this is a test to see if this works or not.">
	</cffunction>

	<cffunction name="test_sentence_should_titleize">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.e = variables.controller.titleize(argumentcollection=loc.a)>
		<cfset loc.r = "This Is A Test To See If This Works Or Not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>