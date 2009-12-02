<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_passwordFieldTag_valid">
		<cfset loc.controller.passwordFieldTag(name="password")>
	</cffunction>

</cfcomponent>