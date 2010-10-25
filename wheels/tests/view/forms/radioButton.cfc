<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_radioButton_valid">
		<cfset loc.controller.radioButton(objectName="user", property="gender", tagValue="m", label="Male")>
	</cffunction>

</cfcomponent>