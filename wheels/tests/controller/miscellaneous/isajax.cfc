<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset oldCGIScope = request.cgi>
	</cffunction>

	<cffunction name="test_isAjax_valid">
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		<cfset assert("controller.isAjax() eq true")>
	</cffunction>

	<cffunction name="test_isAjax_invalid">
		<cfset request.cgi.http_x_requested_with = "">
		<cfset assert("controller.isAjax() eq false")>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi = oldCGIScope>
	</cffunction>

</cfcomponent>