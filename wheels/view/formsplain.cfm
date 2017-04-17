<cfscript>

/**
 * Builds and returns a string containing a text field form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name Name to populate in tag's name attribute.
 * @value Value to populate in tag's value attribute.
 * @label See documentation for [doc:textField].
 * @labelPlacement around See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 * @type See documentation for [doc:textField].
 */
public string function textFieldTag(
	required string name,
	string value="",
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	string type="text"
) {
	$args(name="textFieldTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.value;
	StructDelete(arguments, "name");
	StructDelete(arguments, "value");
	return textField(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a password field form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @value See documentation for [doc:textFieldTag].
 * @label See documentation for [doc:textField].
 * @labelPlacement around See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 */
public string function passwordFieldTag(
	required string name,
	string value="",
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="passwordFieldTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.value;
	StructDelete(arguments, "name");
	StructDelete(arguments, "value");
	return passwordField(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a hidden field form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @value See documentation for [doc:textFieldTag].
 */
public string function hiddenFieldTag(
	required string name,
	string value=""
) {
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.value;
	StructDelete(arguments, "name");
	StructDelete(arguments, "value");
	return hiddenField(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a file form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @label See documentation for [doc:textField].
 * @labelPlacement around See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 */
public string function fileFieldTag(
	required string name,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="fileFieldTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = "";
	StructDelete(arguments, "name");
	return fileField(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a text area form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @content Content to display in textarea on page load.
 * @label See documentation for [doc:textField].
 * @labelPlacement around See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 */
public string function textAreaTag(
	required string name,
	string content="",
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="textAreaTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.content;
	StructDelete(arguments, "name");
	StructDelete(arguments, "content");
	return textArea(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a radio button form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @value See documentation for [doc:textFieldTag].
 * @checked Whether or not to check the radio button by default.
 * @label See documentation for [doc:textField].
 * @labelPlacement See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].*
 */
public string function radioButtonTag(
	required string name,
	required string value,
	boolean checked=false,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="radioButtonTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.tagValue = arguments.value;
	if (arguments.checked) {
		arguments.objectName[arguments.name] = arguments.value;
	} else {

		// Space added to allow a blank value while still not having the form control checked.
		arguments.objectName[arguments.name] = " ";

	}
	StructDelete(arguments, "name");
	StructDelete(arguments, "value");
	StructDelete(arguments, "checked");
	return radioButton(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a check box form control based on the supplied name.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @checked Whether or not the check box should be checked by default.
 * @value Value of check box in its checked state.
 * @uncheckedValue The value of the check box when it's on the unchecked state.
 * @label See documentation for [doc:textField].
 * @labelPlacement See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 */
public string function checkBoxTag(
	required string name,
	boolean checked=false,
	string value,
	string uncheckedValue="",
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="checkBoxTag", args=arguments);
	arguments.checkedValue = arguments.value;
	arguments.property = arguments.name;
	arguments.objectName = {};
	if (arguments.checked) {
		arguments.objectName[arguments.name] = arguments.value;
	} else {

		// Space added to allow a blank value while still not having the form control checked.
		arguments.objectName[arguments.name] = " ";

	}
	if (!StructKeyExists(arguments, "id")) {
		local.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.checkedValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
		arguments.id = $tagId(arguments.objectName, arguments.property);
		if (len(local.valueToAppend)) {
			arguments.id &= "-" & local.valueToAppend;
		}
	}
	StructDelete(arguments, "name");
	StructDelete(arguments, "value");
	StructDelete(arguments, "checked");
	return checkBox(argumentCollection=arguments);
}

/**
 * Builds and returns a string containing a select form control based on the supplied name and options.
 * Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.
 *
 * [section: View Helpers]
 * [category: Form Tag Functions]
 *
 * @name See documentation for [doc:textFieldTag].
 * @options See documentation for [doc:select].
 * @selected Value of option that should be selected by default.
 * @includeBlank See documentation for [doc:select].
 * @multiple Whether to allow multiple selection of options in the select form control.
 * @valueField See documentation for [doc:select].
 * @textField See documentation for [doc:select].
 * @label See documentation for [doc:textField].
 * @labelPlacement around See documentation for [doc:textField].
 * @prepend See documentation for [doc:textField].
 * @append See documentation for [doc:textField].
 * @prependToLabel See documentation for [doc:textField].
 * @appendToLabel See documentation for [doc:textField].
 */
public string function selectTag(
	required string name,
	required any options,
	string selected="",
	any includeBlank,
	boolean multiple,
	string valueField,
	string textField,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel
) {
	$args(name="selectTag", args=arguments);
	arguments.property = arguments.name;
	arguments.objectName = {};
	arguments.objectName[arguments.name] = arguments.selected;
	StructDelete(arguments, "name");
	StructDelete(arguments, "selected");
	return select(argumentCollection=arguments);
}

</cfscript>
