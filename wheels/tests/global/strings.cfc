<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_singularize">
		<cfset loc.result = singularize("statuses")>
		<cfset assert("NOT Compare(loc.result, 'status')")>
	</cffunction>

	<cffunction name="test_singularize_starting_with_upper_case">
		<cfset loc.result = singularize("Instances")>
		<cfset assert("NOT Compare(loc.result, 'Instance')")>
	</cffunction>

	<cffunction name="test_singularize_two_words">
		<cfset loc.result = singularize("statusUpdates")>
		<cfset assert("NOT Compare(loc.result, 'statusUpdate')")>
	</cffunction>

	<cffunction name="test_singularize_multiple_words">
		<cfset loc.result = singularize("fancyChristmasTrees")>
		<cfset assert("NOT Compare(loc.result, 'fancyChristmasTree')")>
	</cffunction>

	<cffunction name="test_pluralize">
		<cfset loc.result = pluralize("status")>
		<cfset assert("NOT Compare(loc.result, 'statuses')")>
	</cffunction>

	<cffunction name="test_pluralize_with_count">
		<cfset loc.result = pluralize("statusUpdate", 0)>
		<cfset assert("NOT Compare(loc.result, '0 statusUpdates')")>
		<cfset loc.result = pluralize("statusUpdate", 1)>
		<cfset assert("NOT Compare(loc.result, '1 statusUpdate')")>
		<cfset loc.result = pluralize("statusUpdate", 2)>
		<cfset assert("NOT Compare(loc.result, '2 statusUpdates')")>
	</cffunction>

	<cffunction name="test_pluralize_starting_with_upper_case">
		<cfset loc.result = pluralize("Instance")>
		<cfset assert("NOT Compare(loc.result, 'Instances')")>
	</cffunction>

	<cffunction name="test_pluralize_two_words">
		<cfset loc.result = pluralize("statusUpdate")>
		<cfset assert("NOT Compare(loc.result, 'statusUpdates')")>
	</cffunction>
	
	<cffunction name="test_pluralize_issue_450">
		<cfset loc.result = pluralize("statuscode")>
		<cfset assert("NOT Compare(loc.result, 'statuscodes')")>
	</cffunction>

	<cffunction name="test_pluralize_multiple_words">
		<cfset loc.result = pluralize("fancyChristmasTree")>
		<cfset assert("NOT Compare(loc.result, 'fancyChristmasTrees')")>
	</cffunction>

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