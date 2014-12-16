<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
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

	<cffunction name="test_supported_boolean_attributes">
		<cfset loc.result = loc.controller.textFieldTag(name="num", checked=true, disabled="true")>
		<cfset loc.correct = '<input checked disabled id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_non_supported_boolean_attributes">
		<cfset loc.result = loc.controller.textFieldTag(name="num", class="true", value="true")>
		<cfset loc.correct = '<input class="true" id="num" name="num" type="text" value="true" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_false_supported_boolean_attribute">
		<cfset loc.result = loc.controller.textFieldTag(name="num", readonly=false)>
		<cfset loc.correct = '<input id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

</cfcomponent>