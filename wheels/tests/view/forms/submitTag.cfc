<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_submitTag_valid">
		<cfset global.controller.submitTag()>
	</cffunction>

</cfcomponent>