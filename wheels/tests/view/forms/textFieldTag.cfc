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

	<cffunction name="test_data_attribute_underscore_conversion">
		<cfset loc.delim = application.wheels.dataAttributeDelimiter>
		<cfset application.wheels.dataAttributeDelimiter = "_">
		<cfset loc.result = loc.controller.textFieldTag(name="num", type="range", min=5, max=10, data_dom_cache="cache", data_role="button")>
		<cfset loc.correct = '<input data-dom-cache="cache" data-role="button" id="num" max="10" min="5" name="num" type="range" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
		<cfset application.wheels.dataAttributeDelimiter = loc.delim>
	</cffunction>

	<cffunction name="test_data_attribute_camelcase_conversion">
		<cfset loc.delim = application.wheels.dataAttributeDelimiter>
		<cfset application.wheels.dataAttributeDelimiter = "A-Z">
		<cfset loc.args = StructNew()>
		<cfset loc.args["dataDomCache"] = "cache">
		<cfset loc.args["dataRole"] = "button">
		<cfset loc.result = loc.controller.textFieldTag(name="num", type="range", min=5, max=10, argumentCollection=loc.args)>
		<cfset loc.correct = '<input data-dom-cache="cache" data-role="button" id="num" max="10" min="5" name="num" type="range" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
		<cfset application.wheels.dataAttributeDelimiter = loc.delim>
	</cffunction>

	<cffunction name="test_data_attribute_set_to_true">
		<cfset loc.args = StructNew()>
		<cfset loc.args["data-dom-cache"] = "true">
		<cfset loc.result = loc.controller.textFieldTag(name="num", argumentCollection=loc.args)>
		<cfset loc.correct = '<input data-dom-cache="true" id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>

	<cffunction name="test_boolean_attribute">
		<cfset loc.result = loc.controller.textFieldTag(name="num", controls1=true, controls2="true")>
		<cfset loc.correct = '<input controls1 controls2 id="num" name="num" type="text" value="" />'>
		<cfset assert('loc.result IS loc.correct')>
	</cffunction>
	
</cfcomponent>