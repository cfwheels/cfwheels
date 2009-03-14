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
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for `URLFor`">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for `URLFor`">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for `URLFor`">
	<cfscript>
		var loc = {};
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
			loc.addToOnSubmit = "this.action='#Left(arguments.action, int((Len(arguments.action)/2)))#'+'#Right(arguments.action, ceiling((Len(arguments.action)/2)))#';";
			if (StructKeyExists(arguments, "onsubmit"))
			{
				if (Right(arguments.onsubmit, 1) != ";")
					arguments.onsubmit = arguments.onsubmit & ";";
				arguments.onsubmit = arguments.onsubmit & loc.addToOnSubmit;
			}
			else
			{
				arguments.onsubmit = loc.addToOnSubmit;
			}
			StructDelete(arguments, "action");
		}
	
		// set the form to be able to handle file uploads
		if (!StructKeyExists(arguments, "enctype") && arguments.multipart)
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
		var loc = {};
		arguments = $insertDefaults(name="submitTag", reserved="type,src", input=arguments);
		if (Len(arguments.disable))
		{
			arguments.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
				arguments.onclick = arguments.onclick & "this.value='#arguments.disable#';";
			arguments.onclick = arguments.onclick & "this.form.submit();";
		}
		if (Len(arguments.image))
		{
			arguments.type = "image";
			arguments.src = application.wheels.webPath & application.wheels.imagePath & "/" & arguments.image;
		}
		else
		{
			arguments.type = "submit";
		}
		loc.returnValue = $tag(name="input", close=true, skip="image,disable", attributes=arguments);
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
		var loc = {};
		arguments = $insertDefaults(name="textField", reserved="type,name,id,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "text";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = HTMLEditFormat($formValue(argumentCollection=arguments));
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButton" returntype="string" access="public" output="false" hint="Builds and returns a string containing a radio button form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="tagValue" type="string" required="true" hint="The value of the radio button when `selected`">
	<cfargument name="label" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="div" hint="See documentation for `textField`">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "objectName,property,tagValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.name = ListLast(arguments.objectName, ".") & "[" & arguments.property & "]">
	<cfset loc.id = ListLast(arguments.objectName, ".") & "-" & arguments.property & "-" & LCase(Replace(ReReplaceNoCase(arguments.tagValue, "[^a-z0-9 ]", "", "all"), " ", "-", "all"))>
	<cfset arguments.name = loc.id>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			#$formBeforeElement(argumentCollection=arguments)#
			<input type="radio" name="#loc.name#" id="#loc.id#" value="#arguments.tagValue#"<cfif arguments.tagValue IS $formValue(argumentCollection=arguments)> checked="checked"</cfif>#loc.attributes# />
			#$formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="checkBox" returntype="string" access="public" output="false" hint="Builds and returns a string containing a check box form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="div" hint="See documentation for `textField`">
	<cfargument name="checkedValue" type="string" required="false" default="1" hint="The value of the check box when its on the `checked` state">
	<cfargument name="uncheckedValue" type="string" required="false" default="0" hint="The value of the check box when its on the `unchecked` state">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "objectName,property,checkedValue,uncheckedValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfif (IsBoolean(loc.value) AND loc.value) OR (isNumeric(loc.value) AND loc.value GTE 1)>
		<cfset loc.checked = true>
	<cfelse>
		<cfset loc.checked = false>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			#$formBeforeElement(argumentCollection=arguments)#
			<input type="checkbox" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#-#arguments.property#" value="#arguments.checkedValue#"<cfif loc.checked> checked="checked"</cfif>#loc.attributes# />
	    <input name="#listLast(arguments.objectName,".")#[#arguments.property#]($checkbox)" type="hidden" value="#arguments.uncheckedValue#" />
			#$formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
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
		var loc = {};
		arguments = $insertDefaults(name="passwordField", reserved="type,name,id,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "password";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = HTMLEditFormat($formValue(argumentCollection=arguments));
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="hiddenField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a hidden field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfscript>
		var loc = {};
		arguments = $insertDefaults(name="hiddenField", reserved="type,name,id,value", input=arguments);
		arguments.type = "hidden";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = $formValue(argumentCollection=arguments);
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod IS "get")
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
		var loc = {};
		arguments = $insertDefaults(name="textArea", reserved="name,id", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		loc.content = $formValue(argumentCollection=arguments);
		loc.returnValue = loc.before & $element(name="textarea", skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", content=loc.content, attributes=arguments) & loc.after;
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
		var loc = {};
		arguments = $insertDefaults(name="fileField", reserved="type,name,id,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "file";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = "";
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="select" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="options" type="any" required="true" hint="A collection to populate the select form control with">
	<cfargument name="label" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="div" hint="See documentation for `textField`">
	<cfargument name="includeBlank" type="any" required="false" default="false" hint="Whether to include a blank option in the select form control">
	<cfargument name="multiple" type="boolean" required="false" default="false" hint="Whether to allow multiple selection of options in the select form control">
	<cfargument name="valueField" type="string" required="false" default="id" hint="The column to use for the value of each list element, used only when a query has been supplied in the `options` argument">
	<cfargument name="textField" type="string" required="false" default="name" hint="The column to use for the value of each list element that the end user will see, used only when a query has been supplied in the `options` argument">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "objectName,property,options,includeBlank,multiple,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.output = "">
	<cfset loc.output = loc.output & $formBeforeElement(argumentCollection=arguments)>
	<cfset loc.output = loc.output & "<select name=""#listLast(arguments.objectName,'.')#[#arguments.property#]"" id=""#listLast(arguments.objectName,'.')#-#arguments.property#""">
	<cfif arguments.multiple>
		<cfset loc.output = loc.output & " multiple">
	</cfif>
	<cfset loc.output = loc.output & loc.attributes & ">">
	<cfif NOT IsBoolean(arguments.includeBlank) OR arguments.includeBlank>
		<cfif NOT IsBoolean(arguments.includeBlank)>
			<cfset loc.text = arguments.includeBlank>
		<cfelse>
			<cfset loc.text = "">
		</cfif>
		<cfset loc.output = loc.output & "<option value="""">#loc.text#</option>">
	</cfif>
	<cfset loc.output = loc.output & $optionsForSelect(argumentCollection=arguments)>
	<cfset loc.output = loc.output & "</select>">
	<cfset loc.output = loc.output & $formAfterElement(argumentCollection=arguments)>

	<cfreturn loc.output>
</cffunction>

<cffunction name="dateTimeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="dateOrder" type="string" required="false" default="month,day,year" hint="See documentation for `dateSelect`">
	<cfargument name="dateSeparator" type="string" required="false" default=" " hint="See documentation for `dateSelect`">
	<cfargument name="startYear" type="numeric" required="false" default="#Year(Now())-5#" hint="See documentation for `dateSelect`">
	<cfargument name="endYear" type="numeric" required="false" default="#Year(Now())+5#" hint="See documentation for `dateSelect`">
	<cfargument name="monthDisplay" type="string" required="false" default="names" hint="See documentation for `dateSelect`">
	<cfargument name="timeOrder" type="string" required="false" default="hour,minute,second" hint="See documentation for `timeSelect`">
	<cfargument name="timeSeparator" type="string" required="false" default=":" hint="See documentation for `timeSelect`">
	<cfargument name="minuteStep" type="numeric" required="false" default="1" hint="See documentation for `timeSelect`">
	<cfargument name="separator" type="string" required="false" default=" - " hint="Use to change the character that is displayed between the first and second set of select tags">
	<cfset arguments.$functionName = "dateTimeSelect">
	<cfreturn $dateTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a date based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="order" type="string" required="false" default="month,day,year" hint="Use to change the order of or exclude date select tags">
	<cfargument name="separator" type="string" required="false" default=" " hint="Use to change the character that is displayed between the date select tags">
	<cfargument name="startYear" type="numeric" required="false" default="#Year(Now())-5#" hint="First year in select list">
	<cfargument name="endYear" type="numeric" required="false" default="#Year(Now())+5#" hint="Last year in select list">
	<cfargument name="monthDisplay" type="string" required="false" default="names" hint="Pass in `names`, `numbers` or `abbreviations` to control display">
	<cfset arguments.$functionName = "dateSelect">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="string" access="public" output="false" hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="order" type="string" required="false" default="hour,minute,second" hint="Use to change the order of or exclude time select tags">
	<cfargument name="separator" type="string" required="false" default=":" hint="Use to change the character that is displayed between the time select tags">
	<cfargument name="minuteStep" type="numeric" required="false" default="1" hint="Pass in `10` to only show minute 10, 20,30 etc">
	<cfset arguments.$functionName = "timeSelect">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$yearSelectTag" returntype="string" access="public" output="false">
	<cfargument name="startYear" type="numeric" required="false" default="#Year(Now())-5#">
	<cfargument name="endYear" type="numeric" required="false" default="#Year(Now())+5#">
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
	<cfargument name="monthDisplay" type="string" required="false" default="names">
	<cfscript>
		arguments.$loopFrom = 1;
		arguments.$loopTo = 12;
		arguments.$type = "month";
		arguments.$step = 1;
		if (arguments.monthDisplay == "abbreviations")
			arguments.$optionNames = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec";
		else if (arguments.monthDisplay == "names")
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
	<cfargument name="minuteStep" type="numeric" required="false" default="1">
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
		var loc = {};
		loc.returnValue = "";
		loc.separator = arguments.separator;
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		if (arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & dateSelect(argumentCollection=arguments);
		else if (arguments.$functionName == "dateTimeSelectTag")
			loc.returnValue = loc.returnValue & $dateSelectTag(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & loc.separator;
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		if (arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & timeSelect(argumentCollection=arguments);
		else if (arguments.$functionName == "dateTimeSelectTag")
			loc.returnValue = loc.returnValue & $timeSelectTag(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$dateSelectTag" returntype="string" access="public" output="false">
	<cfargument name="order" type="string" required="false" default="month,day,year">
	<cfargument name="separator" type="string" required="false" default=" ">
	<cfset arguments.$functionName = "dateSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$timeSelectTag" returntype="string" access="public" output="false">
	<cfargument name="order" type="string" required="false" default="hour,minute,second">
	<cfargument name="separator" type="string" required="false" default=":">
	<cfset arguments.$functionName = "timeSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateOrTimeSelect" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="objectName" type="string" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="$functionName" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Len(arguments.objectName))
		{
			loc.name = $tagName(arguments.objectName, arguments.property);
			arguments.$id = $tagId(arguments.objectName, arguments.property);
			loc.value = $formValue(argumentCollection=arguments);
		}
		else
		{
			loc.name = arguments.name;
			arguments.$id = arguments.name;
			loc.value = arguments.value;
		}
		loc.returnValue = "";
		loc.firstDone = false;
		loc.iEnd = ListLen(arguments.order);
		for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
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
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false" default="false">
	<cfargument name="label" type="string" required="false" default="">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true">
	<cfargument name="prepend" type="string" required="false" default="">
	<cfargument name="append" type="string" required="false" default="">
	<cfargument name="prependToLabel" type="string" required="false" default="">
	<cfargument name="appendToLabel" type="string" required="false" default="">
	<cfargument name="$type" type="string" required="true">
	<cfargument name="$loopFrom" type="numeric" required="true">
	<cfargument name="$loopTo" type="numeric" required="true">
	<cfargument name="$id" type="string" required="false" default="#arguments.name#">
	<cfargument name="$optionNames" type="string" required="false" default="">
	<cfargument name="$step" type="numeric" required="false" default="">
	<cfscript>
		var loc = {};
		arguments.$namedArguments = "name,value,includeBlank,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,$type,$loopFrom,$loopTo,$id,$optionNames,$step";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		if (!Len(arguments.value) && (!IsBoolean(arguments.includeBlank) || !arguments.includeBlank))
			arguments.value = Evaluate("#arguments.$type#(now())");
		loc.returnValue = "";
		loc.returnValue = loc.returnValue & $formBeforeElement(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & "<select name=""#arguments.name#"" id=""#arguments.$id#""#loc.attributes#>";
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			if (!IsBoolean(arguments.includeBlank))
				loc.text = arguments.includeBlank;
			else
				loc.text = "";
			loc.returnValue = loc.returnValue & "<option value="""">#loc.text#</option>";
		}
		for (loc.i=arguments.$loopFrom; loc.i<=arguments.$loopTo; loc.i=loc.i+arguments.$step)
		{
			if (arguments.value == loc.i)
				loc.selected = " selected=""selected""";
			else
				loc.selected = "";
			if (Len(arguments.$optionNames))
				loc.optionName = ListGetAt(arguments.$optionNames, loc.i);
			else
				loc.optionName = loc.i;
			if (arguments.$type == "minute" || arguments.$type == "second")
				loc.optionName = NumberFormat(loc.optionName, "09");
			loc.returnValue = loc.returnValue & "<option value=""#loc.i#""#loc.selected#>#loc.optionName#</option>";
		}
		loc.returnValue = loc.returnValue & "</select>";
		loc.returnValue = loc.returnValue & $formAfterElement(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$optionsForSelect" returntype="string" access="public" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfset var loc = {}>

	<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfif application.wheels.obfuscateUrls AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
		<cfset loc.value = obfuscateParam(loc.value)>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<cfset loc.optionValue = arguments.options[arguments.valueField][currentrow]>
					<cfset loc.optionText = arguments.options[arguments.textField][currentrow]>
					<cfif application.wheels.obfuscateUrls AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.wheels.obfuscateUrls AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.wheels.obfuscateUrls AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = loc.i>
					<cfif application.wheels.obfuscateUrls AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="$formValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="value" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.objectName))
		{
			loc.object = Evaluate(arguments.objectName);
			if (StructKeyExists(loc.object, arguments.property))
				loc.returnValue = loc.object[arguments.property];
			else
				loc.returnValue = "";
		}
		else
		{
			loc.returnValue = arguments.value;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formHasError" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="string" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="value" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (Len(arguments.objectName))
		{
			loc.object = Evaluate(arguments.objectName);
			if (ArrayLen(loc.object.errorsOn(arguments.property)))
				loc.returnValue = true;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formBeforeElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false" default="">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true">
	<cfargument name="prepend" type="string" required="false" default="">
	<cfargument name="append" type="string" required="false" default="">
	<cfargument name="prependToLabel" type="string" required="false" default="">
	<cfargument name="appendToLabel" type="string" required="false" default="">
	<cfargument name="errorElement" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		if ($formHasError(argumentCollection=arguments))
		loc.returnValue = loc.returnValue & "<#arguments.errorElement# class=""field-with-errors"">";
		if (Len(arguments.label))
		{
			loc.returnValue = loc.returnValue & arguments.prependToLabel;
			if (Len(arguments.name))
				loc.returnValue = loc.returnValue & "<label for=""#arguments.name#""";
			else
				loc.returnValue = loc.returnValue & "<label for=""#listLast(arguments.objectName,'.')#-#arguments.property#""";
			for (loc.key in arguments)
			{
			 if (Left(loc.key, 5) == "label" && Len(loc.key) > 5)
			 	loc.returnValue = loc.returnValue & " #Replace(loc.key, 'label', '')#=""#arguments[loc.key]#""";
			}
			loc.returnValue = loc.returnValue & ">" & arguments.label;
			if (!arguments.wrapLabel)
				loc.returnValue = loc.returnValue & "</label>" & arguments.appendToLabel;
		}
		loc.returnValue = loc.returnValue & arguments.prepend;
		
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formAfterElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="false" default="">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false" default="">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true">
	<cfargument name="prepend" type="string" required="false" default="">
	<cfargument name="append" type="string" required="false" default="">
	<cfargument name="prependToLabel" type="string" required="false" default="">
	<cfargument name="appendToLabel" type="string" required="false" default="">
	<cfargument name="errorElement" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.returnValue = loc.returnValue & arguments.append;
		if (Len(arguments.label) && arguments.wrapLabel)
		{
			loc.returnValue = loc.returnValue & "</label>";
			loc.returnValue = loc.returnValue & arguments.appendToLabel;
		}
		if ($formHasError(argumentCollection=arguments))
			loc.returnValue = loc.returnValue & "</#arguments.errorElement#>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
