<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_passwordField_valid">
		<cfset global.controller.passwordField(objectName="ModelUsers1", property="pass")>
	</cffunction>

</cfcomponent>