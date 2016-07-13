<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="common.cfm">

	<cffunction name="test_isPost_valid">
		<cfset request.cgi.request_method = "post">
		<cfset assert("loc.controller.isPost() eq true")>
	</cffunction>
	
	<cffunction name="test_isPost_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("loc.controller.isPost() eq false")>
	</cffunction>

</cfcomponent>