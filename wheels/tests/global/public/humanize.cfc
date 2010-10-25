<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_normal_variable">
		<cfset loc.result = humanize("wheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'Wheels Is A Framework')")>
	</cffunction>

	<cffunction name="test_variable_starting_with_uppercase">
		<cfset loc.result = humanize("WheelsIsAFramework")>
		<cfset assert("NOT Compare(loc.result, 'Wheels Is A Framework')")>
	</cffunction>

	<cffunction name="test_abbreviation">
		<cfset loc.result = humanize("CFML")>
		<cfset assert("NOT Compare(loc.result, 'CFML')")>
	</cffunction>

	<cffunction name="test_abbreviation_as_exception">
		<cfset loc.result = humanize(text="ACfmlFramework", except="CFML")>
		<cfset assert("NOT Compare(loc.result, 'A CFML Framework')")>
	</cffunction>

	<cffunction name="test_exception_within_string">
		<cfset loc.result = humanize(text="ACfmlFramecfmlwork", except="CFML")>
		<cfset assert("NOT Compare(loc.result, 'A CFML Framecfmlwork')")>
	</cffunction>

	<cffunction name="test_abbreviation_without_exception_cannot_be_done">
		<cfset loc.result = humanize("wheelsIsACFMLFramework")>
		<cfset assert("NOT Compare(loc.result, 'Wheels Is ACFML Framework')")>
	</cffunction>

</cfcomponent>