<cfcomponent extends="wheelsMapping.test">
	
	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_autoLink_valid">
		<cfset loc.controller.autoLink("Download Wheels from http://cfwheels.org/download")>
		<cfset loc.controller.autoLink("Email us at info@cfwheels.org")>
	</cffunction>

</cfcomponent>