<cfscript>
	/**
	* PUBLIC VIEW HELPER FUNCTIONS
	*/

	public string function textField(
		required any objectName,
		required string property,
		string association,
		string position,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass,
		string type="text"
	) {
		$args(name="textField", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		local.maxLength = $maxLength(argumentCollection=arguments);
		if (StructKeyExists(local, "maxLength"))
		{
			arguments.maxLength = local.maxLength;
		}
		if (!StructKeyExists(arguments, "value") || !Len(arguments.value))
		{
			arguments.value = $formValue(argumentCollection=arguments);
		}
		local.rv = local.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & local.after;
		return local.rv;
	}

	public string function passwordField(
		required any objectName,
		required string property,
		string association,
		string position,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="passwordField", reserved="type,name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "password";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		local.maxlength = $maxLength(argumentCollection=arguments);
		if (StructKeyExists(local, "maxlength"))
		{
			arguments.maxlength = local.maxlength;
		}
		if (!StructKeyExists(arguments, "value") || !Len(arguments.value))
		{
			arguments.value = $formValue(argumentCollection=arguments);
		}
		local.rv = local.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & local.after;
		return local.rv;
	}

	public string function hiddenField(
		required any objectName,
		required string property,
		string association,
		string position
	) {
		$args(name="hiddenField", reserved="type,name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		arguments.type = "hidden";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		if (!StructKeyExists(arguments, "value") || !Len(arguments.value))
		{
			arguments.value = $formValue(argumentCollection=arguments);
		}
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
		{
			arguments.value = obfuscateParam(arguments.value);
		}
		local.rv = $tag(name="input", close=true, skip="objectName,property,association,position", attributes=arguments);
		return local.rv;
	}

	public string function fileField(
		required any objectName,
		required string property,
		string association,
		string position,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="fileField", reserved="type,name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "file";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		local.rv = local.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & local.after;
		return local.rv;
	}

	public string function textArea(
		required any objectName,
		required string property,
		string association,
		string position,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="textArea", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		local.content = $formValue(argumentCollection=arguments);
		local.rv = local.before & $element(name="textarea", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", content=local.content, attributes=arguments) & local.after;
		return local.rv;
	}

	public string function radioButton(
		required any objectName,
		required string property,
		string association,
		string position,
		string tagValue,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="radioButton", reserved="type,name,value,checked", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		local.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.tagValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(local.valueToAppend))
			{
				arguments.id &= "-" & local.valueToAppend;
			}
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "radio";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.value = arguments.tagValue;
		if (arguments.tagValue == $formValue(argumentCollection=arguments))
		{
			arguments.checked = "checked";
		}
		local.rv = local.before & $tag(name="input", close=true, skip="objectName,property,tagValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & local.after;
		return local.rv;
	}

	public string function checkBox(
		required any objectName,
		required string property,
		string association,
		string position,
		string checkedValue,
		string uncheckedValue,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="checkBox", reserved="type,name,value,checked", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "checkbox";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.value = arguments.checkedValue;
		local.value = $formValue(argumentCollection=arguments);
		if (local.value == arguments.value || IsNumeric(local.value) && local.value == 1 || !IsNumeric(local.value) && IsBoolean(local.value) && local.value)
		{
			arguments.checked = "checked";
		}
		local.rv = local.before & $tag(name="input", close=true, skip="objectName,property,checkedValue,uncheckedValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments);
		if (Len(arguments.uncheckedValue))
		{
			local.hiddenAttributes = {};
			local.hiddenAttributes.type = "hidden";
			local.hiddenAttributes.id = arguments.id & "-checkbox";
			local.hiddenAttributes.name = arguments.name & "($checkbox)";
			local.hiddenAttributes.value = arguments.uncheckedValue;
			local.rv &= $tag(name="input", close=true, attributes=local.hiddenAttributes);
		}
		local.rv &= local.after;
		return local.rv;
	}

	public string function select(
		required any objectName,
		required string property,
		string association,
		string position,
		any options,
		any includeBlank,
		string valueField,
		string textField,
		string label,
		string labelPlacement,
		string prepend,
		string append,
		string prependToLabel,
		string appendToLabel,
		string errorElement,
		string errorClass
	) {
		$args(name="select", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		local.before = $formBeforeElement(argumentCollection=arguments);
		local.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (StructKeyExists(arguments, "multiple") && IsBoolean(arguments.multiple))
		{
			if (arguments.multiple)
			{
				arguments.multiple = "multiple";
			}
			else
			{
				StructDelete(arguments, "multiple");
			}
		}
		local.content = $optionsForSelect(argumentCollection=arguments);
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			if (!IsBoolean(arguments.includeBlank))
			{
				local.blankOptionText = arguments.includeBlank;
			}
			else
			{
				local.blankOptionText = "";
			}
			local.blankOptionAttributes = {value=""};
			local.content = $element(name="option", content=local.blankOptionText, attributes=local.blankOptionAttributes) & local.content;
		}
		local.rv = local.before & $element(name="select", skip="objectName,property,options,includeBlank,valueField,textField,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", content=local.content, attributes=arguments) & local.after;
		return local.rv;
	}

	/**
	* PRIVATE FUNCTIONS
	*/

	public string function $optionsForSelect(
		required any options,
		required string valueField,
		required string textField
	) {
		local.value = $formValue(argumentCollection=arguments);
		local.rv = "";
		if (IsQuery(arguments.options))
		{
			if (!Len(arguments.valueField) || !Len(arguments.textField))
			{
				// order the columns according to their ordinal position in the database table
				local.columns = "";
				local.info = GetMetaData(arguments.options);
				local.iEnd = ArrayLen(local.info);
				for (local.i=1; local.i <= local.iEnd; local.i++)
				{
					local.columns = ListAppend(local.columns, local.info[local.i].name);
				}
				if (!Len(local.columns))
				{
					arguments.valueField = "";
					arguments.textField = "";
				}
				else if (ListLen(local.columns) == 1)
				{
					arguments.valueField = ListGetAt(local.columns, 1);
					arguments.textField = ListGetAt(local.columns, 1);
				}
				else
				{
					// take the first numeric field in the query as the value field and the first non numeric as the text field
					local.iEnd = arguments.options.RecordCount;
					for (local.i=1; local.i <= local.iEnd; local.i++)
					{
						local.jEnd = ListLen(local.columns);
						for (local.j=1; local.j <= local.jEnd; local.j++)
						{
							if (!Len(arguments.valueField) && IsNumeric(arguments.options[ListGetAt(local.columns, local.j)][local.i]))
							{
								arguments.valueField = ListGetAt(local.columns, local.j);
							}
							if (!Len(arguments.textField) && !IsNumeric(arguments.options[ListGetAt(local.columns, local.j)][local.i]))
							{
								arguments.textField = ListGetAt(local.columns, local.j);
							}
						}
					}
					if (!Len(arguments.valueField) || !Len(arguments.textField))
					{
						// the query does not contain both a numeric and a text column so we'll just use the first and second column instead
						arguments.valueField = ListGetAt(local.columns, 1);
						arguments.textField = ListGetAt(local.columns, 2);
					}
				}
			}
			local.iEnd = arguments.options.RecordCount;
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.rv &= $option(objectValue=local.value, optionValue=arguments.options[arguments.valueField][local.i], optionText=arguments.options[arguments.textField][local.i]);
			}
		}
		else if (IsStruct(arguments.options))
		{
			local.sortedKeys = ListSort(StructKeyList(arguments.options), "textnocase"); // sort struct keys alphabetically
			local.iEnd = ListLen(local.sortedKeys);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.key = ListGetAt(local.sortedKeys, local.i);
				local.rv &= $option(objectValue=local.value, optionValue=LCase(local.key), optionText=arguments.options[local.key]);
			}
		}
		else
		{
			// convert the options to an array so we don't duplicate logic
			if (IsSimpleValue(arguments.options))
			{
				arguments.options = ListToArray(arguments.options);
			}

			local.iEnd = ArrayLen(arguments.options);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.optionValue = "";
				local.optionText = "";
				// see if the value in the array cell is an array, which means the programmer is using multidimensional arrays. if it is, use the first dimension for the key and the second for the value if it exists.
				if (IsSimpleValue(arguments.options[local.i]))
				{
					local.optionValue = arguments.options[local.i];
					local.optionText = humanize(arguments.options[local.i]);
				}
				else if (IsArray(arguments.options[local.i]) && ArrayLen(arguments.options[local.i]) >= 2)
				{
					local.optionValue = arguments.options[local.i][1];
					local.optionText = arguments.options[local.i][2];
				}
				else if (IsStruct(arguments.options[local.i]) && StructKeyExists(arguments.options[local.i], "value") && StructKeyExists(arguments.options[local.i], "text"))
				{
					local.optionValue = arguments.options[local.i]["value"];
					local.optionText = arguments.options[local.i]["text"];
				}
				else if (IsObject(arguments.options[local.i]))
				{
					local.object = arguments.options[local.i];
					if (!Len(arguments.valueField) || !Len(arguments.textField))
					{
						local.propertyNames = local.object.propertyNames();
						local.jEnd = ListLen(local.propertyNames);
						for (local.j=1; local.j <= local.jEnd; local.j++)
						{
							local.propertyName = ListGetAt(local.propertyNames, local.j);
							if (StructKeyExists(local.object, local.propertyName))
							{
								local.propertyValue = local.object[local.propertyName];
								if (!Len(arguments.valueField) && IsNumeric(local.propertyValue))
								{
									arguments.valueField = local.propertyName;
								}
								if (!Len(arguments.textField) && !IsNumeric(local.propertyValue))
								{
									arguments.textField = local.propertyName;
								}
							}
						}
					}
					if (StructKeyExists(local.object, arguments.valueField))
					{
						local.optionValue = local.object[arguments.valueField];
					}
					if (StructKeyExists(local.object, arguments.textField))
					{
						local.optionText = local.object[arguments.textField];
					}
				}
				else if (IsStruct(arguments.options[local.i]))
				{
					local.object = arguments.options[local.i];
					// if the struct only has one element then use the key/value pair
					if(StructCount(local.object) eq 1)
					{
						local.key = StructKeyList(local.object);
						local.optionValue = LCase(local.key);
						local.optionText = local.object[local.key];
					}
					else
					{
						if (StructKeyExists(local.object, arguments.valueField))
						{
							local.optionValue = local.object[arguments.valueField];
						}
						if (StructKeyExists(local.object, arguments.textField))
						{
							local.optionText = local.object[arguments.textField];
						}
					}
				}
				local.rv &= $option(objectValue=local.value, optionValue=local.optionValue, optionText=local.optionText);
			}
		}
		return local.rv;
	}

	public string function $option(
		required string objectValue,
		required string optionValue,
		required string optionText,
		boolean applyHtmlEditFormat=true
	) {
		if (arguments.applyHtmlEditFormat)
		{
			arguments.optionValue = XMLFormat(arguments.optionValue);
			arguments.optionText = XMLFormat(arguments.optionText);
		}
		local.optionAttributes = {value=arguments.optionValue};
		if (arguments.optionValue == arguments.objectValue || ListFindNoCase(arguments.objectValue, arguments.optionValue))
		{
			local.optionAttributes.selected = "selected";
		}
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
		{
			local.optionAttributes.value = obfuscateParam(local.optionAttributes.value);
		}
		local.rv = $element(name="option", content=arguments.optionText, attributes=local.optionAttributes);
		return local.rv;
	}
</cfscript>
