<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>

	<cffunction name="test_x_textField_valid">
		<cfset global.controller.textField(label="First Name", objectName="user", property="firstName")>
	</cffunction>
	
	<cffunction name="test_maxlength_textfield_valid">
		<cfset loc.textField = global.controller.textField(label="First Name", objectName="user", property="firstName")>
		<cfset loc.foundMaxLength = YesNoFormat(FindNoCase('maxlength="50"', loc.textField)) />
		<cfset assert('loc.foundMaxLength eq true')>
	</cffunction>

</cfcomponent>