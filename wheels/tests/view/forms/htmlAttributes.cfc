<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_tag_with_disabled_and_readonly_set_to_true">
		<cfset loc.textField = loc.controller.textFieldTag(label="First Name", name="firstName", disabled=true, readonly=true)>
		<cfset loc.expected = '<label for="firstName">First Name<input disabled="disabled" id="firstName" name="firstName" readonly="readonly" type="text" value="" /></label>'>
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

</cfcomponent>