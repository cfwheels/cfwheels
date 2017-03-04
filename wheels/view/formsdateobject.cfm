<cfscript>

public string function dateSelect(
	any objectName="",
	string property="",
	string association,
	string position,
	string order,
	string separator,
	numeric startYear,
	numeric endYear,
	string monthDisplay,
	string monthNames,
	string monthAbbreviations,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	string errorElement,
	string errorClass,
	boolean combine
) {
	$args(name="dateSelect", args=arguments);
	arguments.objectName = $objectName(argumentCollection=arguments);
	arguments.$functionName = "dateSelect";
	return $dateOrTimeSelect(argumentCollection=arguments);
}

public string function timeSelect(
	any objectName="",
	string property="",
	string association,
	string position,
	string order,
	string separator,
	numeric minuteStep,
	numeric secondStep,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	string errorElement,
	string errorClass,
	boolean combine,
	boolean twelveHour
) {
	$args(name="timeSelect", args=arguments);
	arguments.objectName = $objectName(argumentCollection=arguments);
	arguments.$functionName = "timeSelect";
	return $dateOrTimeSelect(argumentCollection=arguments);
}

public string function dateTimeSelect(
	required string objectName,
	required string property,
	string association,
	string position,
	string dateOrder,
	string dateSeparator,
	numeric startYear,
	numeric endYear,
	string monthDisplay,
	string monthNames,
	string monthAbbreviations,
	string timeOrder,
	string timeSeparator,
	numeric minuteStep,
	numeric secondStep,
	string separator,
	any includeBlank,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	string errorElement,
	string errorClass,
	boolean combine,
	boolean twelveHour
) {
	$args(name="dateTimeSelect", reserved="name", args=arguments);
	arguments.objectName = $objectName(argumentCollection=arguments);
	arguments.name = $tagName(arguments.objectName, arguments.property);
	arguments.$functionName = "dateTimeSelect";
	return dateTimeSelectTags(argumentCollection=arguments);
}

</cfscript>
