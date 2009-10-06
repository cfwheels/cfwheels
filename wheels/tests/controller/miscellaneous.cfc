<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_isGet_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_isPost_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_isAjax_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_sendMail_valid">
		<!--- not sure how we are going to test this when the end point is to send an email --->
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_sendFile_valid">
		<!--- not sure how we are going to test this when the end point is to deliver a file --->
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>