<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="common.cfm">

	<cffunction name="test_isSecure_valid">
		<cfset request.cgi.server_port_secure = "yes">
		<cfset assert("loc.controller.isSecure() eq true")>
	</cffunction>
	
	<cffunction name="test_isSecure_invalid">
		<cfset request.cgi.server_port_secure = "">
		<cfset assert("loc.controller.isSecure() eq false")>
		<cfset request.cgi.server_port_secure = "no">
		<cfset assert("loc.controller.isSecure() eq false")>
	</cffunction>

</cfcomponent>