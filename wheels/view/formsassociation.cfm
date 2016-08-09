<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function hasManyRadioButton(
		required string objectName,
		required string association,
		required string property,
		required string keys,
		required string tagValue,
		boolean checkIfBlank=false,
		string label
	) {
		var loc = {};
		$args(name="hasManyRadioButton", args=arguments);
		arguments.keys = Replace(arguments.keys, ", ", ",", "all");
		loc.checked = false;
		loc.rv = "";
		loc.value = $hasManyFormValue(argumentCollection=arguments);
		loc.included = includedInObject(argumentCollection=arguments);
		if (!loc.included)
		{
			loc.included = "";
		}
		if (loc.value == arguments.tagValue || (arguments.checkIfBlank && loc.value != arguments.tagValue))
		{
			loc.checked = true;
		}
		arguments.objectName = ListLast(arguments.objectName, ".");
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-#arguments.property#-#arguments.tagValue#";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][#arguments.property#]";
		loc.rv = radioButtonTag(name=loc.tagName, id=loc.tagId, value=arguments.tagValue, checked=loc.checked, label=arguments.label);
		return loc.rv;
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
		var loc = {};
		$args(name="hasManyCheckBox", args=arguments);
		arguments.keys = Replace(arguments.keys, ", ", ",", "all");
		loc.checked = true;
		loc.rv = "";
		loc.included = includedInObject(argumentCollection=arguments);
		if (!loc.included)
		{
			loc.included = "";
			loc.checked = false;
		}
		arguments.objectName = ListLast(arguments.objectName, ".");
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-_delete";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][_delete]";
		StructDelete(arguments, "keys");
		StructDelete(arguments, "objectName");
		StructDelete(arguments, "association");
		loc.rv = checkBoxTag(name=loc.tagName, id=loc.tagId, value=0, checked=loc.checked, uncheckedValue=1, argumentCollection=arguments);
		return loc.rv;
	}

	public boolean function includedInObject(
		required string objectName,
		required string association,
		required string keys
	) {
		var loc = {};
		loc.rv = false;
		loc.object = $getObject(arguments.objectName);

		// clean up our key argument if there is a comma on the beginning or end
		arguments.keys = REReplace(arguments.keys, "^,|,$", "", "all");

		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
		{
			return loc.rv;
		}
		if (!Len(arguments.keys))
		{
			return loc.rv;
		}
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (IsObject(loc.assoc) && loc.assoc.key() == arguments.keys)
			{
				loc.rv = loc.i;
				break;
			}
		}
		return loc.rv;
	}

	/**
	* PRIVATE FUNCTIONS
	*/

	public string function $hasManyFormValue(
		required string objectName,
		required string association,
		required string property,
		required string keys
	) {
		var loc = {};
		loc.rv = "";
		loc.object = $getObject(arguments.objectName);
		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
		{
			return loc.rv;
		}
		if (!Len(arguments.keys))
		{
			return loc.rv;
		}
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (isObject(loc.assoc) && loc.assoc.key() == arguments.keys && StructKeyExists(loc.assoc, arguments.property))
			{
				loc.rv = loc.assoc[arguments.property];
				break;
			}
		}
		return loc.rv;
	}
</cfscript>
