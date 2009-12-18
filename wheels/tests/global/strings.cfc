<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_hyphenize_normal_variable">
		<cfset loc.result = $hyphenize("wheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'wheels-is-a-framework')")>
	</cffunction>

	<cffunction name="test_hyphenize_variable_starting_with_uppercase">
		<cfset loc.result = $hyphenize("WheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'wheels-is-a-framework')")>
	</cffunction>

	<cffunction name="test_hyphenize_variable_with_abbreviation">
		<cfset loc.result = $hyphenize("aURLVariable")>
		<cfset assert("NOT Compare(loc.result, 'a-u-r-l-variable')")>
	</cffunction>

	<cffunction name="test_hyphenize_variable_with_abbreviation_starting_with_uppercase">
		<cfset loc.result = $hyphenize("URLVariable")>
		<cfset assert("NOT Compare(loc.result, 'u-r-l-variable')")>
	</cffunction>

	<cffunction name="test_humanize_normal_variable">
		<cfset loc.result = humanize("wheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'Wheels Is A Framework')")>
	</cffunction>

	<cffunction name="test_humanize_variable_starting_with_uppercase">
		<cfset loc.result = humanize("WheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'Wheels Is A Framework')")>
	</cffunction>

	<cffunction name="test_humanize_variable_with_abbreviation">
		<cfset loc.result = humanize("aURLVariable")>
		<cfset assert("NOT Compare(loc.result, 'A URL Variable')")>
	</cffunction>

	<cffunction name="test_humanize_variable_with_abbreviation_starting_with_uppercase">
		<cfset loc.result = humanize("URLVariable")>
		<cfset assert("NOT Compare(loc.result, 'URL Variable')")>
	</cffunction>

</cfcomponent>