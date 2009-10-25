<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_hiddenField_valid">
		<cfset global.controller.hiddenField(objectName="ModelUsers1", property="firstname")>
	</cffunction>

</cfcomponent>