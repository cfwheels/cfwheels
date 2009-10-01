<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.word = "this is a test to see if this works or not.">

	<cffunction name="test_sentence_should_titleize">
		<cfset loc.e = loc.controller.titleize(argumentcollection=loc.args)>
		<cfset loc.r = "This Is A Test To See If This Works Or Not.">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>