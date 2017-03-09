<cfscript>
/**
 * Builds and returns a list (ul tag with a default class of errorMessages) containing all the error messages for all the properties of the object (if any). Returns an empty string otherwise.
 *
 * [section: View Helpers]
 * [category: Error Functions]
 *
 * @objectName string Yes The variable name of the object to display error messages for.
 * @class string No errorMessage CSS class to set on the ul element.
 * @showDuplicates boolean No true Whether or not to show duplicate error messages.
 *
 */
public string function errorMessagesFor(required string objectName, string class, boolean showDuplicates) {
	$args(name="errorMessagesFor", args=arguments);
	local.object = $getObject(arguments.objectName);
	if (get("showErrorInformation") && !IsObject(local.object)) {
		$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
	}
	local.errors = local.object.allErrors();
	local.rv = "";
	if (!ArrayIsEmpty(local.errors)) {
		local.used = "";
		local.listItems = "";
		local.iEnd = ArrayLen(local.errors);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.msg = local.errors[local.i].message;
			if (arguments.showDuplicates) {
				local.listItems &= $element(name="li", content=local.msg);
			} else {
				if (!ListFind(local.used, local.msg, Chr(7))) {
					local.listItems &= $element(name="li", content=local.msg);
					local.used = ListAppend(local.used, local.msg, Chr(7));
				}
			}
		}
		local.rv = $element(name="ul", skip="objectName,showDuplicates", content=local.listItems, attributes=arguments);
	}
	return local.rv;
}
/**
 * Returns the error message, if one exists, on the object's property. If multiple error messages exist, the first one is returned.
 *
 * [section: View Helpers]
 * [category: Error Functions]
 *
 * @objectName string Yes The variable name of the object to display the error message for.
 * @property string Yes The name of the property to display the error message for.
 * @prependText string No String to prepend to the error message.
 * @appendText string No String to append to the error message.
 * @wrapperElement string No span HTML element to wrap the error message in.
 * @class string No errorMessage CSS class to set on the wrapper element.
 *
 */
public string function errorMessageOn(
	required string objectName,
	required string property,
	string prependText,
	string appendText,
	string wrapperElement,
	string class
) {
	$args(name="errorMessageOn", args=arguments);
	local.object = $getObject(arguments.objectName);
	if (get("showErrorInformation") && !IsObject(local.object)) {
		$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
	}
	local.error = local.object.errorsOn(arguments.property);
	local.rv = "";
	if (!ArrayIsEmpty(local.error)) {
		local.content = arguments.prependText & local.error[1].message & arguments.appendText;
		local.rv = $element(
			attributes=arguments,
			content=local.content,
			name=arguments.wrapperElement,
			skip="objectName,property,prependText,appendText,wrapperElement"
		);
	}
	return local.rv;
}

</cfscript>
