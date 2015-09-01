<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="textField" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfargument name="type" type="string" required="false" default="text">
	<cfscript>
		var loc = {};
		$args(name="textField", reserved="name,value", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		loc.maxLength = $maxLength(argumentCollection=arguments);
		if (StructKeyExists(loc, "maxLength"))
		{
			arguments.maxLength = loc.maxLength;
		}
		arguments.value = $formValue(argumentCollection=arguments);
		loc.rv = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="passwordField" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="passwordField", reserved="type,name,value", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "password";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		loc.maxlength = $maxLength(argumentCollection=arguments);
		if (StructKeyExists(loc, "maxlength"))
		{
			arguments.maxlength = loc.maxlength;
		}
		arguments.value = $formValue(argumentCollection=arguments);
		loc.rv = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hiddenField" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="hiddenField", reserved="type,name,value", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		arguments.type = "hidden";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		arguments.value = $formValue(argumentCollection=arguments);
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
		{
			arguments.value = obfuscateParam(arguments.value);
		}
		loc.rv = $tag(name="input", close=true, skip="objectName,property,association,position", attributes=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="fileField" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="fileField", reserved="type,name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "file";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		loc.rv = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="textArea" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="textArea", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		loc.content = $formValue(argumentCollection=arguments);
		loc.rv = loc.before & $element(name="textarea", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="radioButton" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="tagValue" type="string" required="true">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="radioButton", reserved="type,name,value,checked", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		loc.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.tagValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(loc.valueToAppend))
			{
				arguments.id &= "-" & loc.valueToAppend;
			}
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "radio";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.value = arguments.tagValue;
		if (arguments.tagValue == $formValue(argumentCollection=arguments))
		{
			arguments.checked = "checked";
		}
		loc.rv = loc.before & $tag(name="input", close=true, skip="objectName,property,tagValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="checkBox" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="checkedValue" type="string" required="false">
	<cfargument name="uncheckedValue" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="checkBox", reserved="type,name,value,checked", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "checkbox";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.value = arguments.checkedValue;
		loc.value = $formValue(argumentCollection=arguments);
		if (loc.value == arguments.value || IsNumeric(loc.value) && loc.value == 1 || !IsNumeric(loc.value) && IsBoolean(loc.value) && loc.value)
		{
			arguments.checked = "checked";
		}
		loc.rv = loc.before & $tag(name="input", close=true, skip="objectName,property,checkedValue,uncheckedValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", attributes=arguments);
		if (Len(arguments.uncheckedValue))
		{
			loc.hiddenAttributes = {};
			loc.hiddenAttributes.type = "hidden";
			loc.hiddenAttributes.id = arguments.id & "-checkbox";
			loc.hiddenAttributes.name = arguments.name & "($checkbox)";
			loc.hiddenAttributes.value = arguments.uncheckedValue;
			loc.rv &= $tag(name="input", close=true, attributes=loc.hiddenAttributes);
		}
		loc.rv &= loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="select" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="association" type="string" required="false">
	<cfargument name="position" type="string" required="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="valueField" type="string" required="false">
	<cfargument name="textField" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="errorElement" type="string" required="false">
	<cfargument name="errorClass" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="select", reserved="name", args=arguments);
		arguments.objectName = $objectName(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
		}
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
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
		loc.content = $optionsForSelect(argumentCollection=arguments);
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			if (!IsBoolean(arguments.includeBlank))
			{
				loc.blankOptionText = arguments.includeBlank;
			}
			else
			{
				loc.blankOptionText = "";
			}
			loc.blankOptionAttributes = {value=""};
			loc.content = $element(name="option", content=loc.blankOptionText, attributes=loc.blankOptionAttributes) & loc.content;
		}
		loc.rv = loc.before & $element(name="select", skip="objectName,property,options,includeBlank,valueField,textField,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,errorClass,association,position", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$optionsForSelect" returntype="string" access="public" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="string" required="true">
	<cfargument name="textField" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.value = $formValue(argumentCollection=arguments);
		loc.rv = "";
		if (IsQuery(arguments.options))
		{
			if (!Len(arguments.valueField) || !Len(arguments.textField))
			{
				// order the columns according to their ordinal position in the database table
				loc.columns = "";
				loc.info = GetMetaData(arguments.options);
				loc.iEnd = ArrayLen(loc.info);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.columns = ListAppend(loc.columns, loc.info[loc.i].name);
				}
				if (!Len(loc.columns))
				{
					arguments.valueField = "";
					arguments.textField = "";
				}
				else if (ListLen(loc.columns) == 1)
				{
					arguments.valueField = ListGetAt(loc.columns, 1);
					arguments.textField = ListGetAt(loc.columns, 1);
				}
				else
				{
					// take the first numeric field in the query as the value field and the first non numeric as the text field
					loc.iEnd = arguments.options.RecordCount;
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						loc.jEnd = ListLen(loc.columns);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							if (!Len(arguments.valueField) && IsNumeric(arguments.options[ListGetAt(loc.columns, loc.j)][loc.i]))
							{
								arguments.valueField = ListGetAt(loc.columns, loc.j);
							}
							if (!Len(arguments.textField) && !IsNumeric(arguments.options[ListGetAt(loc.columns, loc.j)][loc.i]))
							{
								arguments.textField = ListGetAt(loc.columns, loc.j);
							}
						}
					}
					if (!Len(arguments.valueField) || !Len(arguments.textField))
					{
						// the query does not contain both a numeric and a text column so we'll just use the first and second column instead
						arguments.valueField = ListGetAt(loc.columns, 1);
						arguments.textField = ListGetAt(loc.columns, 2);
					}
				}
			}
			loc.iEnd = arguments.options.RecordCount;
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.rv &= $option(objectValue=loc.value, optionValue=arguments.options[arguments.valueField][loc.i], optionText=arguments.options[arguments.textField][loc.i]);
			}
		}
		else if (IsStruct(arguments.options))
		{
			loc.sortedKeys = ListSort(StructKeyList(arguments.options), "textnocase"); // sort struct keys alphabetically
			loc.iEnd = ListLen(loc.sortedKeys);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.key = ListGetAt(loc.sortedKeys, loc.i);
				loc.rv &= $option(objectValue=loc.value, optionValue=LCase(loc.key), optionText=arguments.options[loc.key]);
			}
		}
		else
		{
			// convert the options to an array so we don't duplicate logic
			if (IsSimpleValue(arguments.options))
			{
				arguments.options = ListToArray(arguments.options);
			}

			loc.iEnd = ArrayLen(arguments.options);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.optionValue = "";
				loc.optionText = "";
				// see if the value in the array cell is an array, which means the programmer is using multidimensional arrays. if it is, use the first dimension for the key and the second for the value if it exists.
				if (IsSimpleValue(arguments.options[loc.i]))
				{
					loc.optionValue = arguments.options[loc.i];
					loc.optionText = humanize(arguments.options[loc.i]);
				}
				else if (IsArray(arguments.options[loc.i]) && ArrayLen(arguments.options[loc.i]) >= 2)
				{
					loc.optionValue = arguments.options[loc.i][1];
					loc.optionText = arguments.options[loc.i][2];
				}
				else if (IsStruct(arguments.options[loc.i]) && StructKeyExists(arguments.options[loc.i], "value") && StructKeyExists(arguments.options[loc.i], "text"))
				{
					loc.optionValue = arguments.options[loc.i]["value"];
					loc.optionText = arguments.options[loc.i]["text"];
				}
				else if (IsObject(arguments.options[loc.i]))
				{
					loc.object = arguments.options[loc.i];
					if (!Len(arguments.valueField) || !Len(arguments.textField))
					{
						loc.propertyNames = loc.object.propertyNames();
						loc.jEnd = ListLen(loc.propertyNames);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.propertyName = ListGetAt(loc.propertyNames, loc.j);
							if (StructKeyExists(loc.object, loc.propertyName))
							{
								loc.propertyValue = loc.object[loc.propertyName];
								if (!Len(arguments.valueField) && IsNumeric(loc.propertyValue))
								{
									arguments.valueField = loc.propertyName;
								}
								if (!Len(arguments.textField) && !IsNumeric(loc.propertyValue))
								{
									arguments.textField = loc.propertyName;
								}
							}
						}
					}
					if (StructKeyExists(loc.object, arguments.valueField))
					{
						loc.optionValue = loc.object[arguments.valueField];
					}
					if (StructKeyExists(loc.object, arguments.textField))
					{
						loc.optionText = loc.object[arguments.textField];
					}
				}
				else if (IsStruct(arguments.options[loc.i]))
				{
					loc.object = arguments.options[loc.i];
					// if the struct only has one element then use the key/value pair
					if(StructCount(loc.object) eq 1)
					{
						loc.key = StructKeyList(loc.object);
						loc.optionValue = LCase(loc.key);
						loc.optionText = loc.object[loc.key];
					}
					else
					{
						if (StructKeyExists(loc.object, arguments.valueField))
						{
							loc.optionValue = loc.object[arguments.valueField];
						}
						if (StructKeyExists(loc.object, arguments.textField))
						{
							loc.optionText = loc.object[arguments.textField];
						}
					}
				}
				loc.rv &= $option(objectValue=loc.value, optionValue=loc.optionValue, optionText=loc.optionText);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$option" returntype="string" access="public" output="false">
	<cfargument name="objectValue" type="string" required="true">
	<cfargument name="optionValue" type="string" required="true">
	<cfargument name="optionText" type="string" required="true">
	<cfargument name="applyHtmlEditFormat" type="boolean" required="false" default="true" />
	<cfscript>
		var loc = {};
		if (arguments.applyHtmlEditFormat)
		{
			arguments.optionValue = XMLFormat(arguments.optionValue);
			arguments.optionText = XMLFormat(arguments.optionText);
		}
		loc.optionAttributes = {value=arguments.optionValue};
		if (arguments.optionValue == arguments.objectValue || ListFindNoCase(arguments.objectValue, arguments.optionValue))
		{
			loc.optionAttributes.selected = "selected";
		}
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
		{
			loc.optionAttributes.value = obfuscateParam(loc.optionAttributes.value);
		}
		loc.rv = $element(name="option", content=arguments.optionText, attributes=loc.optionAttributes);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>