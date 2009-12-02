<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_autoLink_valid">
		<cfset loc.controller.autoLink("Download Wheels from http://cfwheels.org/download")>
		<cfset loc.controller.autoLink("Email us at info@cfwheels.org")>
	</cffunction>

</cfcomponent>