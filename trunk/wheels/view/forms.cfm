<cffunction name="startFormTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`.">
	<cfargument name="method" type="string" required="false" default="post" hint="The type of method to use in the form tag, `get` and `post` are the options">
	<cfargument name="multipart" type="boolean" required="false" default="false" hint="Set to `true` if the form should be able to upload files">
	<cfargument name="spamProtection" type="boolean" required="false" default="false" hint="Set to `true` to protect the form against spammers (done with Javascript)">
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
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "method,multipart,spamProtection,route,controller,action,key,params,anchor,onlyPath,host,protocol,port">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset request.wheels.currentFormMethod = arguments.method>

	<cfset loc.url = URLFor(argumentCollection=arguments)>

	<!--- make sure we return XHMTL compliant code --->
	<cfset loc.url = Replace(loc.url, "&", "&amp;", "all")>

	<cfif arguments.spamProtection>
		<cfset loc.onsubmit = "this.action='#Left(loc.url, int((Len(loc.url)/2)))#'+'#Right(loc.url, ceiling((Len(loc.url)/2)))#';">
		<cfset loc.url = "">
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<form action="#loc.url#" method="#arguments.method#"<cfif arguments.multipart> enctype="multipart/form-data"</cfif><cfif StructKeyExists(loc, "onsubmit")> onsubmit="#loc.onsubmit#"</cfif>#loc.attributes#>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="endFormTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing the closing `form` tag.">
	<cfif StructKeyExists(request.wheels, "currentFormMethod")>
		<cfset StructDelete(request.wheels, "currentFormMethod")>
	</cfif>
	<cfreturn "</form>">
</cffunction>

<cffunction name="submitTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a submit button `form` control.">
	<cfargument name="value" type="string" required="false" default="Save changes" hint="Message to display in the button form control">
	<cfargument name="image" type="string" required="false" default="" hint="File name of the image file to use in the button form control">
	<cfargument name="disable" type="any" required="false" default="" hint="Whether to disable the button upon clicking (prevents double-clicking)">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "value,image,disable">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif Len(arguments.disable) IS NOT 0>
		<cfset loc.onclick = "this.disabled=true;">
		<cfif Len(arguments.image) IS 0 AND NOT IsBoolean(arguments.disable)>
			<cfset loc.onclick = loc.onclick & "this.value='#arguments.disable#';">
		</cfif>
		<cfset loc.onclick = loc.onclick & "this.form.submit();">
	</cfif>

	<cfif Len(arguments.image) IS NOT 0>
		<cfset loc.source = "#application.wheels.webPath##application.wheels.imagePath#/#arguments.image#">
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<input value="#arguments.value#"<cfif Len(arguments.image) IS 0> type="submit"<cfelse> type="image" src="#loc.source#"</cfif><cfif Len(arguments.disable) IS NOT 0> onclick="#loc.onclick#"</cfif>#loc.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="textField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to build the form control for">
	<cfargument name="property" type="string" required="true" hint="The name of the property (database column) to use in the form control">
	<cfargument name="label" type="string" required="false" default="#application.settings.textField.label#" hint="The label text to use in the form control">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.settings.textField.wrapLabel#" hint="Whether or not to wrap the label around the form control">
	<cfargument name="prepend" type="string" required="false" default="#application.settings.textField.prepend#" hint="String to prepend to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="append" type="string" required="false" default="#application.settings.textField.append#" hint="String to append to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.settings.textField.prependToLabel#" hint="String to prepend to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.settings.textField.appendToLabel#" hint="String to append to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="errorElement" type="string" required="false" default="#application.settings.textField.errorElement#" hint="HTML tag to wrap the form control with when the object contains errors">
	<cfset var loc = {}>
	<cfset StructAppend(arguments, application.settings.textField, false)>
	<cfset arguments.$namedArguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			#$formBeforeElement(argumentCollection=arguments)#
			<input type="text" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#-#arguments.property#" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
			#$formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
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
	<cfargument name="label" type="string" required="false" default="#application.settings.passwordField.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.settings.passwordField.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.settings.passwordField.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.settings.passwordField.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.settings.passwordField.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.settings.passwordField.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.settings.passwordField.errorElement#" hint="See documentation for `textField`">
	<cfset var loc = {}>
	<cfset StructAppend(arguments, application.settings.passwordField, false)>
	<cfset arguments.$namedArguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			#$formBeforeElement(argumentCollection=arguments)#
			<input type="password" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#-#arguments.property#" value="#HTMLEditFormat($formValue(argumentCollection=arguments))#"#loc.attributes# />
			#$formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="hiddenField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a hidden field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "objectName,property">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
		<cfset loc.value = obfuscateParam(loc.value)>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<input type="hidden" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#-#arguments.property#" value="#HTMLEditFormat(loc.value)#"#loc.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="textArea" returntype="string" access="public" output="false" hint="Builds and returns a string containing a password field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="#application.settings.textArea.label#" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="#application.settings.textArea.wrapLabel#" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="#application.settings.textArea.prepend#" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="#application.settings.textArea.append#" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.settings.textArea.prependToLabel#" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.settings.textArea.appendToLabel#" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="#application.settings.textArea.errorElement#" hint="See documentation for `textField`">
	<cfscript>
		var loc = {};
		StructAppend(arguments, application.settings.passwordField, false);
		arguments.$namedArguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement";
		loc.attributes = $getAttributes(argumentCollection=arguments);
		loc.returnValue = "";
		loc.returnValue = loc.returnValue & $formBeforeElement(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & "<textarea name=""#ListLast(arguments.objectName, '.')#[#arguments.property#]"" id=""#ListLast(arguments.objectName, '.')#-#arguments.property#""#loc.attributes#>";
		loc.returnValue = loc.returnValue & $formValue(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & "</textarea>";
		loc.returnValue = loc.returnValue & $formAfterElement(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="fileField" returntype="string" access="public" output="false" hint="Builds and returns a string containing a file field form control based on the supplied `objectName` and `property`.">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="property" type="string" required="true" hint="See documentation for `textField`">
	<cfargument name="label" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="wrapLabel" type="boolean" required="false" default="true" hint="See documentation for `textField`">
	<cfargument name="prepend" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="append" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="prependToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="appendToLabel" type="string" required="false" default="" hint="See documentation for `textField`">
	<cfargument name="errorElement" type="string" required="false" default="div" hint="See documentation for `textField`">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			#$formBeforeElement(argumentCollection=arguments)#
			<input type="file" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#-#arguments.property#" value=""#loc.attributes# />
			#$formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
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
	<cfargument name="includeBlank" type="boolean" required="false" default="false" hint="Whether to include a blank option in the select form control">
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
	<cfargument name="startYear" type="any" required="false" default="#year(now())-5#">
	<cfargument name="endYear" type="any" required="false" default="#year(now())+5#">
	<cfset arguments.$loopFrom = arguments.startYear>
	<cfset arguments.$loopTo = arguments.endYear>
	<cfset arguments.$type = "year">
	<cfset arguments.$step = 1>
	<cfset StructDelete(arguments, "startYear")>
	<cfset StructDelete(arguments, "endYear")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$monthSelectTag" returntype="string" access="public" output="false">
	<cfargument name="monthDisplay" type="any" required="false" default="names">
	<cfset arguments.$loopFrom = 1>
	<cfset arguments.$loopTo = 12>
	<cfset arguments.$type = "month">
	<cfset arguments.$step = 1>
	<cfif arguments.monthDisplay IS "abbreviations">
		<cfset arguments.$optionNames = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
	<cfelseif arguments.monthDisplay IS "names">
		<cfset arguments.$optionNames = "January,February,March,April,May,June,July,August,September,October,November,December">
	</cfif>
	<cfset StructDelete(arguments, "monthDisplay")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$daySelectTag" returntype="string" access="public" output="false">
	<cfset arguments.$loopFrom = 1>
	<cfset arguments.$loopTo = 31>
	<cfset arguments.$type = "day">
	<cfset arguments.$step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$hourSelectTag" returntype="string" access="public" output="false">
	<cfset arguments.$loopFrom = 0>
	<cfset arguments.$loopTo = 23>
	<cfset arguments.$type = "hour">
	<cfset arguments.$step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$minuteSelectTag" returntype="string" access="public" output="false">
	<cfargument name="minuteStep" type="any" required="false" default="1">
	<cfset arguments.$loopFrom = 0>
	<cfset arguments.$loopTo = 59>
	<cfset arguments.$type = "minute">
	<cfset arguments.$step = arguments.minuteStep>
	<cfset StructDelete(arguments, "minuteStep")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$secondSelectTag" returntype="string" access="public" output="false">
	<cfset arguments.$loopFrom = 0>
	<cfset arguments.$loopTo = 59>
	<cfset arguments.$type = "second">
	<cfset arguments.$step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateTimeSelect" returntype="string" access="public" output="false">
	<cfset var loc = {}>

	<cfset loc.html = "">
	<cfset loc.separator = arguments.separator>

	<cfset arguments.order = arguments.dateOrder>
	<cfset arguments.separator = arguments.dateSeparator>
	<cfif arguments.$functionName IS "dateTimeSelect">
		<cfset loc.html = loc.html & dateSelect(argumentCollection=arguments)>
	<cfelseif arguments.$functionName IS "dateTimeSelectTag">
		<cfset loc.html = loc.html & $dateSelectTag(argumentCollection=arguments)>
	</cfif>
	<cfset loc.html = loc.html & loc.separator>
	<cfset arguments.order = arguments.timeOrder>
	<cfset arguments.separator = arguments.timeSeparator>
	<cfif arguments.$functionName IS "dateTimeSelect">
		<cfset loc.html = loc.html & timeSelect(argumentCollection=arguments)>
	<cfelseif arguments.$functionName IS "dateTimeSelectTag">
		<cfset loc.html = loc.html & $timeSelectTag(argumentCollection=arguments)>
	</cfif>

	<cfreturn loc.html>
</cffunction>

<cffunction name="$dateSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="month,day,year">
	<cfargument name="separator" type="any" required="false" default=" ">
	<cfset arguments.$functionName = "dateSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$timeSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="hour,minute,second">
	<cfargument name="separator" type="any" required="false" default=":">
	<cfset arguments.$functionName = "timeSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateOrTimeSelect" returntype="string" access="public" output="false">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="$functionName" type="any" required="true">
	<cfset var loc = {}>

	<cfif Len(arguments.objectName) IS NOT 0>
		<cfset loc.name = "#listLast(arguments.objectName,".")#[#arguments.property#]">
		<cfset arguments.$id = "#listLast(arguments.objectName,".")#-#arguments.property#">
		<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfelse>
		<cfset loc.name = arguments.name>
		<cfset arguments.$id = arguments.name>
		<cfset loc.value = arguments.value>
	</cfif>

	<cfset loc.html = "">
	<cfset loc.firstDone = false>
	<cfloop list="#arguments.order#" index="loc.i">
		<cfset arguments.name = loc.name & "($" & loc.i & ")">
		<cfif loc.value IS NOT "">
			<cfset arguments.value = evaluate("#loc.i#(loc.value)")>
		<cfelse>
			<cfset arguments.value = "">
		</cfif>
		<cfif loc.firstDone>
			<cfset loc.html = loc.html & arguments.separator>
		</cfif>
		<cfset loc.html = loc.html & evaluate("$#loc.i#SelectTag(argumentCollection=arguments)")>
		<cfset loc.firstDone = true>
	</cfloop>

	<cfreturn loc.html>
</cffunction>

<cffunction name="$yearMonthHourMinuteSecondSelectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="$type" type="any" required="true" default="">
	<cfargument name="$loopFrom" type="any" required="true" default="">
	<cfargument name="$loopTo" type="any" required="true" default="">
	<cfargument name="$id" type="any" required="false" default="#arguments.name#">
	<cfargument name="$optionNames" type="any" required="false" default="">
	<cfargument name="$step" type="any" required="false" default="">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "name,value,includeBlank,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,$type,$loopFrom,$loopTo,$id,$optionNames,$step">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif arguments.value IS "" AND NOT arguments.includeBlank>
		<cfset arguments.value = evaluate("#arguments.$type#(now())")>
	</cfif>

	<cfset loc.html = "">
	<cfset loc.html = loc.html & $formBeforeElement(argumentCollection=arguments)>
	<cfset loc.html = loc.html & "<select name=""#arguments.name#"" id=""#arguments.$id#""#loc.attributes#>">
	<cfif NOT IsBoolean(arguments.includeBlank) OR arguments.includeBlank>
		<cfif NOT IsBoolean(arguments.includeBlank)>
			<cfset loc.text = arguments.includeBlank>
		<cfelse>
			<cfset loc.text = "">
		</cfif>
		<cfset loc.html = loc.html & "<option value="""">#loc.text#</option>">
	</cfif>
	<cfloop from="#arguments.$loopFrom#" to="#arguments.$loopTo#" index="loc.i" step="#arguments.$step#">
		<cfif arguments.value IS loc.i>
			<cfset loc.selected = " selected=""selected""">
		<cfelse>
			<cfset loc.selected = "">
		</cfif>
		<cfif arguments.$optionNames IS NOT "">
			<cfset loc.optionName = listGetAt(arguments.$optionNames, loc.i)>
		<cfelse>
			<cfset loc.optionName = loc.i>
		</cfif>
		<cfif arguments.$type IS "minute" OR arguments.$type IS "second">
			<cfset loc.optionName = numberFormat(loc.optionName, "09")>
		</cfif>
		<cfset loc.html = loc.html & "<option value=""#loc.i#""#loc.selected#>#loc.optionName#</option>">
	</cfloop>
	<cfset loc.html = loc.html & "</select>">
	<cfset loc.html = loc.html & $formAfterElement(argumentCollection=arguments)>

	<cfreturn loc.html>
</cffunction>

<cffunction name="$optionsForSelect" returntype="string" access="public" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfset var loc = {}>

	<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
		<cfset loc.value = obfuscateParam(loc.value)>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<cfset loc.optionValue = arguments.options[arguments.valueField][currentrow]>
					<cfset loc.optionText = arguments.options[arguments.textField][currentrow]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = loc.i>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
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
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var loc = {}>

	<cfif Len(arguments.objectName) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset loc.object = evaluate(arguments.objectName)>
		<cfif StructKeyExists(loc.object, arguments.property)>
			<cfset loc.value = loc.object[arguments.property]>
		<cfelse>
			<cfset loc.value = "">
		</cfif>
	<cfelse>
		<cfset loc.value = arguments.value>
	</cfif>

	<cfreturn loc.value>
</cffunction>

<cffunction name="$formHasError" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var loc = {}>

	<cfset loc.error = false>
	<cfif Len(arguments.objectName)>
		<cfset loc.object = Evaluate(arguments.objectName)>
		<cfif ArrayLen(loc.object.errorsOn(arguments.property))>
			<cfset loc.error = true>	
		</cfif>
	</cfif>

	<cfreturn loc.error>
</cffunction>

<cffunction name="$formBeforeElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var loc = {}>

	<cfset loc.output = "">
	<cfif $formHasError(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "<#arguments.errorElement# class=""field-with-errors"">">
	</cfif>

	<cfif Len(arguments.label) IS NOT 0>
		<cfset loc.output = loc.output & arguments.prependToLabel>
		<cfif Len(arguments.name)>
			<cfset loc.output = loc.output & "<label for=""#arguments.name#""">
		<cfelse>
			<cfset loc.output = loc.output & "<label for=""#listLast(arguments.objectName,'.')#-#arguments.property#""">
		</cfif>
		<cfloop collection="#arguments#" item="loc.i">
			<cfif Left(loc.i, 5) IS "label" AND Len(loc.i) GT 5>
				<cfset loc.output = loc.output & " #Replace(loc.i, 'label', '')#=""#arguments[loc.i]#""">
			</cfif>
		</cfloop>
		<cfset loc.output = loc.output & ">" & arguments.label>
		<cfif NOT arguments.wrapLabel>
			<cfset loc.output = loc.output & "</label>" & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfset loc.output = loc.output & arguments.prepend>

	<cfreturn loc.output>
</cffunction>

<cffunction name="$formAfterElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var loc = {}>

	<cfset loc.output = "">
	<cfset loc.output = loc.output & arguments.append>
	<cfif Len(arguments.label) IS NOT 0>
		<cfif arguments.wrapLabel>
			<cfset loc.output = loc.output & "</label>">
			<cfset loc.output = loc.output & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfif $formHasError(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "</#arguments.errorElement#>">
	</cfif>

	<cfreturn loc.output>
</cffunction>
