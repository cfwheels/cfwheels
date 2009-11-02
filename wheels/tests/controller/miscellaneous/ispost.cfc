<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	<cfset request.cgi = global.controller.$cgiscope()>
	
	<cffunction name="test_isPost_valid">
		<cfset request.cgi.request_method = "post">
		<cfset assert('loc.controller.isPost() eq true')>
	</cffunction>
	
	<cffunction name="test_isPost_invalid">
		<cfset request.cgi.request_method = "">
		<cfset assert('loc.controller.isPost() eq false')>
	</cffunction>
	
</cfcomponent>