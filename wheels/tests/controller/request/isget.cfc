<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="common.cfm">

	<cffunction name="test_isGet_valid">
		<cfset request.cgi.request_method = "get">
		<cfset assert("controller.isGet() eq true")>
	</cffunction>
	
	<cffunction name="test_isGet_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert("controller.isGet() eq false")>
	</cffunction>

</cfcomponent>