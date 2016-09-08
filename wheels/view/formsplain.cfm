<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
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
		local.rv = textField(argumentCollection=arguments);
		return local.rv;
	}

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
		local.rv = passwordField(argumentCollection=arguments);
		return local.rv;
	}

	public string function hiddenFieldTag(
		required string name,
		string value=""
	) {
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		local.rv = hiddenField(argumentCollection=arguments);
		return local.rv;
	}

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
		local.rv = fileField(argumentCollection=arguments);
		return local.rv;
	}

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
		local.rv = textArea(argumentCollection=arguments);
		return local.rv;
	}

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
		if (arguments.checked)
		{
			arguments.objectName[arguments.name] = arguments.value;
		}
		else
		{
			// space added to allow a blank value while still not having the form control checked
			arguments.objectName[arguments.name] = " ";
		}
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		local.rv = radioButton(argumentCollection=arguments);
		return local.rv;
	}

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
		if (arguments.checked)
		{
			arguments.objectName[arguments.name] = arguments.value;
		}
		else
		{
			// space added to allow a blank value while still not having the form control checked
			arguments.objectName[arguments.name] = " ";
		}
		if (!StructKeyExists(arguments, "id"))
		{
			local.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.checkedValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(local.valueToAppend))
			{
				arguments.id &= "-" & local.valueToAppend;
			}
		}
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		local.rv = checkBox(argumentCollection=arguments);
		return local.rv;
	}

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
		local.rv = select(argumentCollection=arguments);
		return local.rv;
	}
</cfscript>
