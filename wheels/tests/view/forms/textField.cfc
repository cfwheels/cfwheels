<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_textField_valid">
		<cfset global.controller.textField(label="First Name", objectName="ModelUsers1", property="firstName")>
	</cffunction>

</cfcomponent>