<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_passwordFieldTag_valid">
		<cfset loc.controller.passwordFieldTag(name="password")>
	</cffunction>

</cfcomponent>