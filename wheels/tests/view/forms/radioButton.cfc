<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_radioButton_valid">
		<cfset global.controller.radioButton(objectName="user", property="gender", tagValue="m", label="Male")>
	</cffunction>

</cfcomponent>