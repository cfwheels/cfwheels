<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_passwordField_valid">
		<cfset loc.controller.passwordField(objectName="User", property="password")>
	</cffunction>

</cfcomponent>