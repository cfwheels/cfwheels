<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_isPost_valid">
		<cfset request.cgi.request_method = "post">
		<cfset assert("controller.isPost() eq true")>
	</cffunction>
	
	<cffunction name="test_isPost_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("controller.isPost() eq false")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
	</cffunction>

</cfcomponent>