<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
		<cfset oldBooleanAttributes = application.wheels.booleanAttributes>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.booleanAttributes = oldBooleanAttributes>
	</cffunction>

	<cffunction name="test_tag_with_disabled_and_readonly_set_to_true">
		<cfset loc.textField = loc.controller.textFieldTag(label="First Name", name="firstName", disabled=true, readonly=true)>
		<cfset loc.expected = '<label for="firstName">First Name<input disabled id="firstName" name="firstName" readonly type="text" value="" /></label>'>
		<cfset assert('loc.expected eq loc.textField')>
	</cffunction>

	<cffunction name="test_tag_with_disabled_and_readonly_set_to_false">
		<cfset loc.textField = loc.controller.textFieldTag(label="First Name", name="firstName", disabled=false, readonly=false)>
		<cfset loc.expected = '<label for="firstName">First Name<input id="firstName" name="firstName" type="text" value="" /></label>'>
		<cfset assert('loc.expected eq loc.textField')>
	</cffunction>

	<cffunction name="test_tag_with_disabled_and_readonly_set_to_string">
		<cfset loc.textField = loc.controller.textFieldTag(label="First Name", name="firstName", disabled="cheese", readonly="crackers")>
		<cfset loc.expected = '<label for="firstName">First Name<input disabled="cheese" id="firstName" name="firstName" readonly="crackers" type="text" value="" /></label>'>
		<cfset assert('loc.expected eq loc.textField')>
	</cffunction>

	<cffunction name="test_supported_attributes_should_be_boolean">
		<cfset loc.result = loc.controller.textFieldTag(name="num", checked=true, disabled="true")>
		<cfset loc.correct = '<input checked disabled id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_non_supported_attributes_should_be_non_boolean">
		<cfset loc.result = loc.controller.textFieldTag(name="num", class="true", value="true")>
		<cfset loc.correct = '<input class="true" id="num" name="num" type="text" value="true" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_supported_attribute_should_be_omitted_when_false">
		<cfset loc.result = loc.controller.textFieldTag(name="num", readonly=false)>
		<cfset loc.correct = '<input id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_supported_attribute_should_be_non_boolean_when_setting_is_off">
		<cfset application.wheels.booleanAttributes = false>
		<cfset loc.result = loc.controller.textFieldTag(name="num", checked=true)>
		<cfset loc.correct = '<input checked="true" id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_non_supported_attribute_should_be_boolean_when_setting_is_on">
		<cfset application.wheels.booleanAttributes = true>
		<cfset loc.result = loc.controller.textFieldTag(name="num", whatever=true)>
		<cfset loc.correct = '<input id="num" name="num" type="text" value="" whatever />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

</cfcomponent>