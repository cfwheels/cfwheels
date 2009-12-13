<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	<cfset request.cgi = global.controller.$cgiscope()>
	
	<cffunction name="test_isSecure_valid">
		<cfset request.cgi.server_port_secure = "yes">
		<cfset assert('loc.controller.isSecure() eq true')>
	</cffunction>
	
	<cffunction name="test_isSecure_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert('loc.controller.isSecure() eq false')>
	</cffunction>
	
</cfcomponent>