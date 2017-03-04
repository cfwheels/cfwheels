<cfscript>

public string function hasManyRadioButton(
	required string objectName,
	required string association,
	required string property,
	required string keys,
	required string tagValue,
	boolean checkIfBlank=false,
	string label
) {
	$args(name="hasManyRadioButton", args=arguments);
	arguments.keys = Replace(arguments.keys, ", ", ",", "all");
	local.checked = false;
	local.rv = "";
	local.value = $hasManyFormValue(argumentCollection=arguments);
	local.included = includedInObject(argumentCollection=arguments);
	if (!local.included) {
		local.included = "";
	}
	if (local.value == arguments.tagValue || (arguments.checkIfBlank && local.value != arguments.tagValue)) {
		local.checked = true;
	}
	arguments.objectName = ListLast(arguments.objectName, ".");
	local.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-#arguments.property#-#arguments.tagValue#";
	local.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][#arguments.property#]";
	return radioButtonTag(name=local.tagName, id=local.tagId, value=arguments.tagValue, checked=local.checked, label=arguments.label);
}

public string function hasManyCheckBox(
	required string objectName,
	required string association,
	required string keys,
	string label,
	string labelPlacement,
	string prepend,
	string append,
	string prependToLabel,
	string appendToLabel,
	string errorElement,
	string errorClass
) {
	$args(name="hasManyCheckBox", args=arguments);
	arguments.keys = Replace(arguments.keys, ", ", ",", "all");
	local.checked = true;
	local.rv = "";
	local.included = includedInObject(argumentCollection=arguments);
	if (!local.included) {
		local.included = "";
		local.checked = false;
	}
	arguments.objectName = ListLast(arguments.objectName, ".");
	local.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-_delete";
	local.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][_delete]";
	StructDelete(arguments, "keys");
	StructDelete(arguments, "objectName");
	StructDelete(arguments, "association");
	return checkBoxTag(name=local.tagName, id=local.tagId, value=0, checked=local.checked, uncheckedValue=1, argumentCollection=arguments);
}

public boolean function includedInObject(
	required string objectName,
	required string association,
	required string keys
) {
	local.rv = false;
	local.object = $getObject(arguments.objectName);

	// clean up our key argument if there is a comma on the beginning or end
	arguments.keys = REReplace(arguments.keys, "^,|,$", "", "all");

	if (!StructKeyExists(local.object, arguments.association) || !IsArray(local.object[arguments.association])) {
		return local.rv;
	}
	if (!Len(arguments.keys)) {
		return local.rv;
	}
	local.iEnd = ArrayLen(local.object[arguments.association]);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.assoc = local.object[arguments.association][local.i];
		if (IsObject(local.assoc) && local.assoc.key() == arguments.keys) {
			local.rv = local.i;
			break;
		}
	}
	return local.rv;
}

public string function $hasManyFormValue(
	required string objectName,
	required string association,
	required string property,
	required string keys
) {
	local.rv = "";
	local.object = $getObject(arguments.objectName);
	if (!StructKeyExists(local.object, arguments.association) || !IsArray(local.object[arguments.association])) {
		return local.rv;
	}
	if (!Len(arguments.keys)) {
		return local.rv;
	}
	local.iEnd = ArrayLen(local.object[arguments.association]);
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		local.assoc = local.object[arguments.association][local.i];
		if (isObject(local.assoc) && local.assoc.key() == arguments.keys && StructKeyExists(local.assoc, arguments.property)) {
			local.rv = local.assoc[arguments.property];
			break;
		}
	}
	return local.rv;
}

</cfscript>
