<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_isGet_valid">
		<cfset request.cgi.request_method = "get">
		<cfset assert("loc.controller.isGet() eq true")>
	</cffunction>

	<cffunction name="test_isGet_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("loc.controller.isGet() eq false")>
	</cffunction>

</cfcomponent>
