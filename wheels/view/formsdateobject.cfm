<cfscript>

/**
* Builds and returns a string containing three select form controls for month, day, and year based on the supplied objectName and property.
*
* [section: View Helpers]
* [category: Form Object Functions]
*
* @objectName The variable name of the object to build the form control for.
* @property The name of the property to use in the form control.
* @association The name of the association that the property is located on. Used for building nested forms that work with nested properties. If you are building a form with deep nesting, simply pass in a list to the nested object, and Wheels will figure it out.
* @position The position used when referencing a hasMany relationship in the association argument. Used for building nested forms that work with nested properties. If you are building a form with deep nestings, simply pass in a list of positions, and Wheels will figure it out.
* @order Use to change the order of or exclude date select tags.
* @seperator Use to change the character that is displayed between the date select tags.
* @startYear First year in select list.
* @endYear Last year in select list.
* @monthDisplay Pass in names, numbers, or abbreviations to control display.
* @includeBlank Whether to include a blank option in the select form control. Pass true to include a blank line or a string that should represent what display text should appear for the empty value (for example, "- Select One -").
* @label The label text to use in the form control.
* @labelPlacement Whether to place the label before, after, or wrapped around the form control. Label text placement can be controlled using aroundLeft or aroundRight.
* @prepend String to prepend to the form control. Useful to wrap the form control with HTML tags.
* @append String to append to the form control. Useful to wrap the form control with HTML tags.
* @prependToLabel String to prepend to the form control's label. Useful to wrap the form control with HTML tags.
* @appendToLabel String to append to the form control's label. Useful to wrap the form control with HTML tags.
* @errorElement HTML tag to wrap the form control with when the object contains errors.
* @errorClass The class name of the HTML tag that wraps the form control when there are errors.
* @combine
*/
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

/**
* Builds and returns a string containing three select form controls for hour, minute, and second based on the supplied objectName and property.
*
* [section: View Helpers]
* [category: Form Object Functions]
*
* @objectName See documentation for textField.
* @property See documentation for textField.
* @association See documentation for textfield.
* @position See documentation for textfield.
* @order Use to change the order of or exclude time select tags.
* @separator Use to change the character that is displayed between the time select tags.
* @minuteStep Pass in 10 to only show minute 10, 20, 30, etc.
* @secondStep Pass in 10 to only show seconds 10, 20, 30, etc.
* @includeBlank See documentation for select.
* @label See documentation for dateSelect.
* @labelPlacement See documentation for textField.
* @prepend See documentation for textField.
* @append See documentation for textField.
* @prependToLabel See documentation for textField.
* @appendToLabel See documentation for textField.
* @errorElement See documentation for textField.
* @errorClass See documentation for textField.
* @combine See documentation for dateSelect.
* @twelveHour whether to display the hours in 24 or 12 hour format. 12 hour format has AM/PM drop downs
*/
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

/**
* Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on a name.
*
* [section: View Helpers]
* [category: Form Object Functions]
*
* @name See documentation for textFieldTag.
* @selected See documentation for selectTag.
* @dateOrder See documentation for dateTimeSelect.
* @dateSeparator See documentation for dateTimeSelect.
* @startYear See documentation for dateSelect.
* @endYear See documentation for dateSelect.
* @monthDisplay See documentation for dateSelect.
* @monthNames See documentation for dateSelect.
* @monthAbbreviations See documentation for dateSelect.
* @timeOrder See documentation for dateTimeSelect.
* @timeSeparator See documentation for dateTimeSelect.
* @minuteStep See documentation for timeSelect.
* @secondStep See documentation for timeSelect.
* @separator See documentation for dateTimeSelect.
* @includeBlank See documentation for select.
* @label See documentation for dateSelect.
* @labelPlacement See documentation for textField.
* @prepend See documentation for textField.
* @append See documentation for textField.
* @prependToLabel See documentation for textField.
* @appendToLabel See documentation for textField.
* @combine See documentation for dateSelect.
* @twelveHour false See documentation for timeSelect.
*/
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
