<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_textFieldTag_valid">
		<cfset loc.controller.textFieldTag(name="someName")>
	</cffunction>
	
	<cffunction name="test_custom_textfieldTag_type">
		<cfset loc.textField = loc.controller.textFieldTag(name="search", label="Search me", type="search")>
		<cfset loc.foundCustomType = YesNoFormat(FindNoCase('type="search"', loc.textField)) />
		<cfset assert('loc.foundCustomType eq true')>
	</cffunction>

	<cffunction name="test_hyphenized_data_attributes">
		<cfset loc.hyphenizeAttributeNames = application.wheels.hyphenizeAttributeNames>
		<cfset application.wheels.hyphenizeAttributeNames = true>
		<cfset loc.args["dataDomCache"] = true>
		<cfset loc.args["dataRole"] = "button">
		<cfset loc.result = loc.controller.textFieldTag(name="num", type="range", min=5, max=10, argumentCollection=loc.args)>
		<cfset loc.correct = '<input data-dom-cache="true" data-role="button" id="num" max="10" min="5" name="num" type="range" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
		<cfset application.wheels.hyphenizeAttributeNames = loc.hyphenizeAttributeNames>
	</cffunction>

	<cffunction name="test_lowercased_attributes">
		<cfset loc.hyphenizeAttributeNames = application.wheels.hyphenizeAttributeNames>
		<cfset application.wheels.hyphenizeAttributeNames = false>
		<cfset loc.args = StructNew()>
		<cfset loc.args["CLASS"] = "x">
		<cfset loc.result = loc.controller.textFieldTag(name="num", type="range", min=5, max=10, argumentCollection=loc.args)>
		<cfset loc.correct = '<input class="x" id="num" max="10" min="5" name="num" type="range" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
		<cfset application.wheels.hyphenizeAttributeNames = loc.hyphenizeAttributeNames>
	</cffunction>
	
</cfcomponent>