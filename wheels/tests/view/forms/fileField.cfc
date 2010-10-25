<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_fileField_valid">
		<cfset loc.controller.fileField(objectName="user", property="firstname")>
	</cffunction>

</cfcomponent>