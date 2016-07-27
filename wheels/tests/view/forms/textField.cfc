<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_override_value">
		<cfset loc.textField = loc.controller.textField(label="First Name", objectName="user", property="firstName", value="override")>
		<cfset loc.foundValue = YesNoFormat(FindNoCase('value="override"', loc.textField))>
		<cfset assert('loc.foundValue eq true')>
	</cffunction>

	<cffunction name="test_maxlength_textfield_valid">
		<cfset loc.textField = loc.controller.textField(label="First Name", objectName="user", property="firstName")>
		<cfset loc.foundMaxLength = YesNoFormat(FindNoCase('maxlength="50"', loc.textField)) />
		<cfset assert('loc.foundMaxLength eq true')>
	</cffunction>

</cfcomponent>