<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_isSecure_valid">
		<cfset request.cgi.server_port_secure = "yes">
		<cfset assert("controller.isSecure() eq true")>
	</cffunction>
	
	<cffunction name="test_isSecure_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("controller.isSecure() eq false")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
	</cffunction>

</cfcomponent>