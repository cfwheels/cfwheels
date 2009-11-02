<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	<cfset request.cgi = global.controller.$cgiscope()>
	
	<cffunction name="test_isGet_valid">
		<cfset request.cgi.request_method = "get">
		<cfset assert('loc.controller.isGet() eq true')>
	</cffunction>
	
	<cffunction name="test_isGet_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert('loc.controller.isGet() eq false')>
	</cffunction>
	
</cfcomponent>