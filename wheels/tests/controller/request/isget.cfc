<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="common.cfm">

	<cffunction name="test_isGet_valid">
		<cfset request.cgi.request_method = "get">
		<cfset assert("loc.controller.isGet() eq true")>
	</cffunction>
	
	<cffunction name="test_isGet_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("loc.controller.isGet() eq false")>
	</cffunction>

</cfcomponent>