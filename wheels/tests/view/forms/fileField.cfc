<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_fileField_valid">
		<cfset global.controller.fileField(objectName="user", property="firstname")>
	</cffunction>

</cfcomponent>