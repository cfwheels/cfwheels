<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_textArea_valid">
		<cfset loc.controller.textArea(objectName="user", property="firstname")>
	</cffunction>

</cfcomponent>