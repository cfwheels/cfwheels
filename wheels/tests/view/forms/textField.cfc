<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_x_textField_valid">
		<cfset loc.controller.textField(label="First Name", objectName="user", property="firstName")>
	</cffunction>

	<cffunction name="test_maxlength_textfield_valid">
		<cfset loc.textField = loc.controller.textField(label="First Name", objectName="user", property="firstName")>
		<cfset loc.foundMaxLength = YesNoFormat(FindNoCase('maxlength="50"', loc.textField)) />
		<cfset assert('loc.foundMaxLength eq true')>
	</cffunction>

</cfcomponent>