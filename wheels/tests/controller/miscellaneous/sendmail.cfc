<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />

	<cffunction name="test_sendMail_valid">
		<!--- not sure how we are going to test this when the end point is to send an email --->
		<cfset fail()>
	</cffunction>

</cfcomponent>