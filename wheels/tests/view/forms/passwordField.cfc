<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_passwordField_valid">
		<cfset loc.controller.passwordField(objectName="user", property="pass")>
	</cffunction>

</cfcomponent>