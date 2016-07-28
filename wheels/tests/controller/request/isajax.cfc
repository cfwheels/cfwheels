<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_isAjax_valid">
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		<cfset assert("loc.controller.isAjax() eq true")>
	</cffunction>

	<cffunction name="test_isAjax_invalid">
		<cfset request.cgi.http_x_requested_with = "">
		<cfset assert("loc.controller.isAjax() eq false")>
	</cffunction>

</cfcomponent>
