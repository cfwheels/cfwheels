<cffunction name="startFormTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`.">
	<cfargument name="method" type="string" required="false" default="#application.wheels.startFormTag.method#" hint="The type of method to use in the form tag, `get` and `post` are the options">
	<cfargument name="multipart" type="boolean" required="false" default="#application.wheels.startFormTag.multipart#" hint="Set to `true` if the form should be able to upload files">
	<cfargument name="spamProtection" type="boolean" required="false" default="#application.wheels.startFormTag.spamProtection#" hint="Set to `true` to protect the form against spammers (done with Javascript)">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.startFormTag.onlyPath#" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="#application.wheels.startFormTag.host#" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.startFormTag.protocol#" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.startFormTag.port#" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="startFormTag", input=arguments);
	
		// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
		request.wheels.currentFormMethod = arguments.method;
	
		// set the form's action attribute to the URL that we want to send to
		arguments.action = URLFor(argumentCollection=arguments);
		
		// make sure we return XHMTL compliant code
		arguments.action = Replace(arguments.action, "&", "&amp;", "all"); 
	
		// deletes the action attribute and instead adds some tricky javascript spam protection to the onsubmit attribute
		if (arguments.spamProtection)
		{
			loc.onsubmit = "this.action='#Left(arguments.action, int((Len(arguments.action)/2)))#'+'#Right(arguments.action, ceiling((Len(arguments.action)/2)))#';";
			arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
			StructDelete(arguments, "action");
		}
	
		// set the form to be able to handle file uploads
		if (not(StructKeyExists(arguments, "enctype") and arguments.multipart))
			arguments.enctype = "multipart/form-data";
		
		loc.returnValue = $tag(name="form", skip="multipart,spamProtection,route,controller,key,params,anchor,onlyPath,host,protocol,port", attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="endFormTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing the closing `form` tag.">
	<cfscript>
		if (StructKeyExists(request.wheels, "currentFormMethod"))
			StructDelete(request.wheels, "currentFormMethod");
	</cfscript>
	<cfreturn "</form>">
</cffunction>

<cffunction name="submitTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a submit button `form` control.">
	<cfargument name="value" type="string" required="false" default="#application.wheels.submitTag.value#" hint="Message to display in the button form control">
	<cfargument name="image" type="string" required="false" default="#application.wheels.submitTag.image#" hint="File name of the image file to use in the button form control">
	<cfargument name="disable" type="any" required="false" default="#application.wheels.submitTag.disable#" hint="Whether to disable the button upon clicking (prevents double-clicking)">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="submitTag", reserved="type,src", input=arguments);
		if (Len(arguments.disable))
		{
			loc.onclick = "this.disabled=true;";
			if (not(Len(arguments.image)) and not(IsBoolean(arguments.disable)))
				loc.onclick = loc.onclick & "this.value='#arguments.disable#';";
			loc.onclick = loc.onclick & "this.form.submit();";
			arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments);
		}
		if (Len(arguments.image))
		{
			// create an img tag and then just replace "img" with "input"
			arguments.type = "image";
			arguments.source = arguments.image;
			StructDelete(arguments, "value");
			StructDelete(arguments, "image");
			StructDelete(arguments, "disable");
			loc.returnValue = imageTag(argumentCollection=arguments);
			loc.returnValue = Replace(loc.returnValue, "<img", "<input");
		}
		else
		{
			arguments.type = "submit";
			loc.returnValue = $tag(name="input", close=true, skip="image,disable", attributes=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to build the form control for">
	<cfargument name="property" type="string" required="true" hint="The name of the property (database column) to use in the form control">
	<cfargument name="label" type="string" required="false" default="#application.wheels.textField.label#" hint="The label text to use in the form control">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.textField.wrapLabel#" hint="Whether or not to wrap the label around the form control">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.textField.prepend#" hint="String to prepend to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="append" type="string" required="false" default="#application.wheels.textField.append#" hint="String to append to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.textField.prependToLabel#" hint="String to prepend to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.textField.appendToLabel#" hint="String to append to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.textField.errorElement#" hint="HTML tag to wrap the form control with when the object contains errors">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="textField", reserved="type,name,id,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "text";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = HTMLEditFormat($formValue(argumentCollection=arguments));
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButton" returntype="string" access="public" output="false" hint="Builds and returns a string containing a radio button form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="tagValue" type="string" required="true" hint="The value of the radio button when `selected`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.radioButton.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.radioButton.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.radioButton.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.radioButton.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.radioButton.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.radioButton.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.radioButton.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="radioButton", reserved="type,name,id,value,checked", input=arguments);
		loc.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.tagValue, "[^a-z0-9 ]", "", "all"), " ", "-", "all"));
		arguments.$appendToFor = loc.valueToAppend;
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "radio";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property) & "-" & loc.valueToAppend;
		arguments.value = arguments.tagValue;
		if (arguments.tagValue eq $formValue(argumentCollection=arguments))
			arguments.checked = "checked";
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,tagValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="checkBox" returntype="string" access="public" output="false" hint="Builds and returns a string containing a check box form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="checkedValue" type="string" required="false" default="#application.wheels.checkBox.checkedValue#" hint="The value of the check box when its on the `checked` state">
	<cfargument name="uncheckedValue" type="string" required="false" default="#application.wheels.checkBox.uncheckedValue#" hint="The value of the check box when its on the `unchecked` state">
	<cfargument name="label" type="string" required="false" default="#application.wheels.checkBox.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.checkBox.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.checkBox.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.checkBox.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.checkBox.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.checkBox.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.checkBox.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="checkBox", reserved="type,name,id,value,checked", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "checkbox";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = arguments.checkedValue;
		loc.value = $formValue(argumentCollection=arguments);
		if ((IsBoolean(loc.value) and loc.value) or (isNumeric(loc.value) and loc.value gte 1))
			arguments.checked = "checked";
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,checkedValue,uncheckedValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments);
		loc.hiddenAttributes = StructNew();
		loc.hiddenAttributes.type = "hidden";
		loc.hiddenAttributes.name = arguments.name & "($checkbox)";
		loc.hiddenAttributes.value = arguments.uncheckedValue;
		loc.returnValue = loc.returnValue & $tag(name="input", close=true, attributes=loc.hiddenAttributes) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="passwordField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a password field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.passwordField.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.passwordField.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.passwordField.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.passwordField.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.passwordField.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.passwordField.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.passwordField.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="passwordField", reserved="type,name,id,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "password";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = HTMLEditFormat($formValue(argumentCollection=arguments));
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="hiddenField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a hidden field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="hiddenField", reserved="type,name,id,value", input=arguments);
		arguments.type = "hidden";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = $formValue(argumentCollection=arguments);
		if (application.wheels.obfuscateUrls and StructKeyExists(request.wheels, "currentFormMethod") and request.wheels.currentFormMethod IS "get")
			arguments.value = obfuscateParam(arguments.value);
		arguments.value = HTMLEditFormat(arguments.value);
		loc.returnValue = $tag(name="input", close=true, skip="objectName,property", attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textArea" returntype="string" access="public" output="false" hint="Builds and returns a string containing a password field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.textArea.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.textArea.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.textArea.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.textArea.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.textArea.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.textArea.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.textArea.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="textArea", reserved="name,id", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		loc.content = $formValue(argumentCollection=arguments);
		loc.returnValue = loc.before & $element(name="textarea", skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="fileField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a file field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.passwordField.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.passwordField.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.passwordField.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.passwordField.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.passwordField.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.passwordField.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.passwordField.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="fileField", reserved="type,name,id", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "file";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="select" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="options" type="any" required="true" hint="A collection to populate the select form control with">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.select.includeBlank#" hint="Whether to include a blank option in the select form control">
	<cfargument name="multiple" type="boolean" required="false" default="#application.wheels.select.multiple#" hint="Whether to allow multiple selection of options in the select form control">
	<cfargument name="valueField" type="string" required="false" default="#application.wheels.select.valueField#" hint="The column to use for the value of each list element, used only when a query has been supplied in the `options` argument">
	<cfargument name="textField" type="string" required="false" default="#application.wheels.select.textField#" hint="The column to use for the value of each list element that the end user will see, used only when a query has been supplied in the `options` argument">
	<cfargument name="label" type="string" required="false" default="#application.wheels.select.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.select.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.select.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.select.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.select.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.select.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.select.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="select", reserved="name,id", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		if (arguments.multiple)
			arguments.multiple = "multiple";
		else
			StructDelete(arguments, "multiple");		
		loc.content = $optionsForSelect(argumentCollection=arguments);
		if (not(IsBoolean(arguments.includeBlank)) or arguments.includeBlank)
		{
			if (not(IsBoolean(arguments.includeBlank)))
				loc.blankOptionText = arguments.includeBlank;
			else
				loc.blankOptionText = "";
			loc.blankOptionAttributes = {value=""};
			loc.content = $element(name="option", content=loc.blankOptionText, attributes=loc.blankOptionAttributes) & loc.content; 
		}
		loc.returnValue = loc.before & $element(name="select", skip="objectName,property,options,includeBlank,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="dateTimeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="dateOrder" type="string" required="false" default="#application.wheels.dateTimeSelect.dateOrder#" hint="See documentation for `dateSelect`">
	<cfargument name="dateSeparator" type="string" required="false" default="#application.wheels.dateTimeSelect.dateSeparator#" hint="See documentation for `dateSelect`">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.dateTimeSelect.startYear#" hint="See documentation for `dateSelect`">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.dateTimeSelect.endYear#" hint="See documentation for `dateSelect`">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.dateTimeSelect.monthDisplay#" hint="See documentation for `dateSelect`">
	<cfargument name="timeOrder" type="string" required="false" default="#application.wheels.dateTimeSelect.timeOrder#" hint="See documentation for `timeSelect`">
	<cfargument name="timeSeparator" type="string" required="false" default="#application.wheels.dateTimeSelect.timeSeparator#" hint="See documentation for `timeSelect`">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.dateTimeSelect.minuteStep#" hint="See documentation for `timeSelect`">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.dateTimeSelect.separator#" hint="Use to change the character that is displayed between the first and second set of select tags">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.dateTimeSelect.includeBlank#" hint="See documentation for `select`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.dateTimeSelect.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.dateTimeSelect.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.dateTimeSelect.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.dateTimeSelect.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.dateTimeSelect.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.dateTimeSelect.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.dateTimeSelect.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="dateTimeSelect", reserved="name,id", input=arguments);
		arguments.$functionName = "dateTimeSelect";
	</cfscript>
	<cfreturn $dateTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a date based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="order" type="string" required="false" default="#application.wheels.dateSelect.order#" hint="Use to change the order of or exclude date select tags">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.dateSelect.separator#" hint="Use to change the character that is displayed between the date select tags">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.dateSelect.startYear#" hint="First year in select list">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.dateSelect.endYear#" hint="Last year in select list">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.dateSelect.monthDisplay#" hint="Pass in `names`, `numbers` or `abbreviations` to control display">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.dateSelect.includeBlank#" hint="See documentation for `select`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.dateSelect.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.dateSelect.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.dateSelect.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.dateSelect.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.dateSelect.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.dateSelect.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.dateSelect.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="dateSelect", reserved="name,id", input=arguments);
		arguments.$functionName = "dateSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="order" type="string" required="false" default="#application.wheels.timeSelect.order#" hint="Use to change the order of or exclude time select tags">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.timeSelect.separator#" hint="Use to change the character that is displayed between the time select tags">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.timeSelect.minuteStep#" hint="Pass in `10` to only show minute 10, 20,30 etc">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.timeSelect.includeBlank#" hint="See documentation for `select`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.timeSelect.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.wheels.timeSelect.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.timeSelect.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.wheels.timeSelect.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.timeSelect.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.timeSelect.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.timeSelect.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = StructNew();
		arguments = $insertDefaults(name="timeSelect", reserved="name,id", input=arguments);
		arguments.$functionName = "timeSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$yearSelectTag" returntype="string" access="public" output="false">
	<cfargument name="startYear" type="numeric" required="true">
	<cfargument name="endYear" type="numeric" required="true">
	<cfscript>
		arguments.$loopFrom = arguments.startYear;
		arguments.$loopTo = arguments.endYear;
		arguments.$type = "year";
		arguments.$step = 1;
		StructDelete(arguments, "startYear");
		StructDelete(arguments, "endYear");
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$monthSelectTag" returntype="string" access="public" output="false">
	<cfargument name="monthDisplay" type="string" required="true">
	<cfscript>
		arguments.$loopFrom = 1;
		arguments.$loopTo = 12;
		arguments.$type = "month";
		arguments.$step = 1;
		if (arguments.monthDisplay eq "abbreviations")
			arguments.$optionNames = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec";
		else if (arguments.monthDisplay eq "names")
			arguments.$optionNames = "January,February,March,April,May,June,July,August,September,October,November,December";
		StructDelete(arguments, "monthDisplay");
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$daySelectTag" returntype="string" access="public" output="false">
	<cfscript>
		arguments.$loopFrom = 1;
		arguments.$loopTo = 31;
		arguments.$type = "day";
		arguments.$step = 1;
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$hourSelectTag" returntype="string" access="public" output="false">
	<cfscript>
		arguments.$loopFrom = 0;
		arguments.$loopTo = 23;
		arguments.$type = "hour";
		arguments.$step = 1;
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$minuteSelectTag" returntype="string" access="public" output="false">
	<cfargument name="minuteStep" type="numeric" required="true">
	<cfscript>
		arguments.$loopFrom = 0;
		arguments.$loopTo = 59;
		arguments.$type = "minute";
		arguments.$step = arguments.minuteStep;
		StructDelete(arguments, "minuteStep");
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$secondSelectTag" returntype="string" access="public" output="false">
	<cfscript>
		arguments.$loopFrom = 0;
		arguments.$loopTo = 59;
		arguments.$type = "second";
		arguments.$step = 1;
	</cfscript>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateTimeSelect" returntype="string" access="public" output="false">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = "";
		loc.separator = arguments.separator;
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		if (arguments.$functionName eq "dateTimeSelect")
			loc.returnValue = loc.returnValue & dateSelect(argumentCollection=arguments);
		else if (arguments.$functionName eq "dateTimeSelectTag")
			loc.returnValue = loc.returnValue & $dateSelectTag(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & loc.separator;
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		if (arguments.$functionName eq "dateTimeSelect")
			loc.returnValue = loc.returnValue & timeSelect(argumentCollection=arguments);
		else if (arguments.$functionName eq "dateTimeSelectTag")
			loc.returnValue = loc.returnValue & $timeSelectTag(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$dateSelectTag" returntype="string" access="public" output="false">
	<cfargument name="order" type="string" required="true">
	<cfargument name="separator" type="string" required="true">
	<cfset arguments.$functionName = "dateSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$timeSelectTag" returntype="string" access="public" output="false">
	<cfargument name="order" type="string" required="true">
	<cfargument name="separator" type="string" required="true">
	<cfset arguments.$functionName = "timeSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateOrTimeSelect" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="$functionName" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.name = $tagName(arguments.objectName, arguments.property);
		arguments.$id = $tagId(arguments.objectName, arguments.property);
		loc.value = $formValue(argumentCollection=arguments);
		loc.returnValue = "";
		loc.firstDone = false;
		loc.iEnd = ListLen(arguments.order);
		for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
		{
			loc.item = ListGetAt(arguments.order, loc.i);
			arguments.name = loc.name & "($" & loc.item & ")";
			if (Len(loc.value))
				arguments.value = Evaluate("#loc.item#(loc.value)");
			else
				arguments.value = "";
			if (loc.firstDone)
				loc.returnValue = loc.returnValue & arguments.separator;
			loc.returnValue = loc.returnValue & Evaluate("$#loc.item#SelectTag(argumentCollection=arguments)");
			loc.firstDone = true;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$yearMonthHourMinuteSecondSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="true">
	<cfargument name="includeBlank" type="any" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="wrapLabel" type="boolean" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfargument name="$type" type="string" required="true">
	<cfargument name="$loopFrom" type="numeric" required="true">
	<cfargument name="$loopTo" type="numeric" required="true">
	<cfargument name="$id" type="string" required="true">
	<cfargument name="$step" type="numeric" required="true">
	<cfargument name="$optionNames" type="string" required="false" default="">
	<cfscript>
		var loc = StructNew();
		if (not(Len(arguments.value)) and (not(IsBoolean(arguments.includeBlank)) or not(arguments.includeBlank)))
			arguments.value = Evaluate("#arguments.$type#(Now())");
		arguments.$appendToFor = arguments.$type;
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		loc.content = "";
		if (not(IsBoolean(arguments.includeBlank)) or arguments.includeBlank)
		{
			loc.args = StructNew();
			loc.args.value = "";
			if (not(IsBoolean(arguments.includeBlank)))
				loc.optionContent = arguments.includeBlank;
			else
				loc.optionContent = "";
			loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
		}
		for (loc.i=arguments.$loopFrom; loc.i lte arguments.$loopTo; loc.i=loc.i+arguments.$step)
		{
			loc.args = StructNew();
			loc.args.value = loc.i;
			if (arguments.value eq loc.i)
				loc.args.selected = "selected";
			if (Len(arguments.$optionNames))
				loc.optionContent = ListGetAt(arguments.$optionNames, loc.i);
			else
				loc.optionContent = loc.i;
			if (arguments.$type eq "minute" or arguments.$type eq "second")
				loc.optionContent = NumberFormat(loc.optionContent, "09");
			loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
		}
		arguments.id = arguments.$id & "-" & arguments.$type;
		loc.returnValue = loc.before & $element(name="select", skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement,value,includeBlank,order,separator,startYear,endYear,monthDisplay,dateSeparator,dateOrder,timeSeparator,timeOrder,minuteStep", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$optionsForSelect" returntype="string" access="public" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="string" required="true">
	<cfargument name="textField" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.value = $formValue(argumentCollection=arguments);
		loc.returnValue = "";
		if (IsQuery(arguments.options))
		{
			loc.iEnd = arguments.options.RecordCount;
			// if no value or text field has been passed in we take the first numeric field in the query as the value field and the first non numeric as the text field
			if (not(Len(arguments.valueField)) or not(Len(arguments.textField)))
			{
				for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
				{
					loc.jEnd = ListLen(arguments.options.columnList);
					for (loc.j=1; loc.j lte loc.jEnd; loc.j=loc.j+1)
					{
						if (not(Len(arguments.valueField)) and IsNumeric(arguments.options[ListGetAt(arguments.options.columnList, loc.j)][loc.i]))
							arguments.valueField = ListGetAt(arguments.options.columnList, loc.j);
						if (not(Len(arguments.textField)) and not(IsNumeric(arguments.options[ListGetAt(arguments.options.columnList, loc.j)][loc.i])))
							arguments.textField = ListGetAt(arguments.options.columnList, loc.j);
					}
				}
			}
			for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
			{
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=arguments.options[arguments.valueField][loc.i], optionText=arguments.options[arguments.textField][loc.i]);
			}
		}
		else if (IsStruct(arguments.options))
		{
			for (loc.key in arguments.options)
			{
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=loc.key, optionText=arguments.options[loc.key]);
			}
		}
		else if (IsArray(arguments.options))
		{
			loc.iEnd = ArrayLen(arguments.options);
			for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
			{
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=loc.i, optionText=arguments.options[loc.i]);
			}
		}
		else
		{
			loc.iEnd = ListLen(arguments.options);
			for (loc.i=1; loc.i lte loc.iEnd; loc.i=loc.i+1)
			{
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=loc.i, optionText=ListGetAt(arguments.options, loc.i));
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$option" returntype="string" access="public" output="false">
	<cfargument name="objectValue" type="string" required="true">
	<cfargument name="optionValue" type="string" required="true">
	<cfargument name="optionText" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.optionAttributes = {value=arguments.optionValue};
		if (arguments.optionValue eq arguments.objectValue)
			loc.optionAttributes.selected = "selected";
		if (application.wheels.obfuscateUrls and StructKeyExists(request.wheels, "currentFormMethod") and request.wheels.currentFormMethod IS "get")
			loc.optionAttributes.value = obfuscateParam(loc.optionAttributes.value);
		loc.returnValue = $element(name="option", content=arguments.optionText, attributes=loc.optionAttributes);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.object = Evaluate(arguments.objectName);
		if (StructKeyExists(loc.object, arguments.property))
			loc.returnValue = loc.object[arguments.property];
		else
			loc.returnValue = "";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formHasError" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = false;
		loc.object = Evaluate(arguments.objectName);
		if (ArrayLen(loc.object.errorsOn(arguments.property)))
			loc.returnValue = true;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formBeforeElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="wrapLabel" type="boolean" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfargument name="$appendToFor" type="string" required="false" default="">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = "";
		if ($formHasError(argumentCollection=arguments))
			loc.returnValue = loc.returnValue & $tag(name=arguments.errorElement, class="field-with-errors");
		if (Len(arguments.label))
		{
			loc.returnValue = loc.returnValue & arguments.prependToLabel;
			loc.attributes = StructNew();
			for (loc.key in arguments)
			{
			 if (Left(loc.key, 5) eq "label" and Len(loc.key) gt 5)
				loc.attributes[Replace(loc.key, "label", "")] = arguments[loc.key];
			}
			loc.attributes.for = $tagId(arguments.objectName, arguments.property);
			if (Len(arguments.$appendToFor))
				loc.attributes.for = loc.attributes.for & "-" & arguments.$appendToFor;
			loc.returnValue = loc.returnValue & $tag(name="label", attributes=loc.attributes);
			loc.returnValue = loc.returnValue & arguments.label;
			if (not(arguments.wrapLabel))
				loc.returnValue = loc.returnValue & "</label>" & arguments.appendToLabel;
		}
		loc.returnValue = loc.returnValue & arguments.prepend;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formAfterElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="wrapLabel" type="boolean" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = arguments.append;
		if (Len(arguments.label) and arguments.wrapLabel)
		{
			loc.returnValue = loc.returnValue & "</label>";
			loc.returnValue = loc.returnValue & arguments.appendToLabel;
		}
		if ($formHasError(argumentCollection=arguments))
			loc.returnValue = loc.returnValue & "</" & arguments.errorElement & ">";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
