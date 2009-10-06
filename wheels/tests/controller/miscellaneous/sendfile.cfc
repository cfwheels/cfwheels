<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_sendFile_valid">
		<!--- not sure how we are going to test this when the end point is to deliver a file --->
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>