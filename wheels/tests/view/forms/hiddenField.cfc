<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_hiddenField_valid">
		<cfset loc.controller.hiddenField(objectName="user", property="firstname")>
	</cffunction>

</cfcomponent>