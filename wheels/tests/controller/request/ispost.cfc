<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_isPost_valid">
		<cfset request.cgi.request_method = "post">
		<cfset assert("loc.controller.isPost() eq true")>
	</cffunction>

	<cffunction name="test_isPost_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("loc.controller.isPost() eq false")>
	</cffunction>

</cfcomponent>
