<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_hiddenField_valid">
		<cfset loc.controller.hiddenField(objectName="user", property="firstname")>
	</cffunction>

</cfcomponent>