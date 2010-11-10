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
	
</cfcomponent>