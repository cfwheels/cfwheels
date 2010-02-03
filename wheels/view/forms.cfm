<cffunction name="startFormTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    ##startFormTag(action="create", spamProtection=true)##
		        <!--- your form controls --->
		    ##endFormTag()##
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="method" type="string" required="false" default="#application.wheels.functions.startFormTag.method#" hint="The type of method to use in the form tag, `get` and `post` are the options">
	<cfargument name="multipart" type="boolean" required="false" default="#application.wheels.functions.startFormTag.multipart#" hint="Set to `true` if the form should be able to upload files">
	<cfargument name="spamProtection" type="boolean" required="false" default="#application.wheels.functions.startFormTag.spamProtection#" hint="Set to `true` to protect the form against spammers (done with JavaScript)">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.startFormTag.onlyPath#" hint="See documentation for @URLFor">
	<cfargument name="host" type="string" required="false" default="#application.wheels.functions.startFormTag.host#" hint="See documentation for @URLFor">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.startFormTag.protocol#" hint="See documentation for @URLFor">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.startFormTag.port#" hint="See documentation for @URLFor">
	<cfscript>
		var loc = {};
		$insertDefaults(name="startFormTag", input=arguments);

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
		if (!StructKeyExists(arguments, "enctype") && arguments.multipart)
			arguments.enctype = "multipart/form-data";

		loc.skip = "multipart,spamProtection,route,controller,key,params,anchor,onlyPath,host,protocol,port";
		if (Len(arguments.route))
			loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
		if (ListFind(loc.skip, "action"))
			loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above

		loc.returnValue = $tag(name="form", skip=loc.skip, attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="endFormTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing the closing `form` tag."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    ##startFormTag(action="create")##
		        <!--- your form controls --->
		    ##endFormTag()##
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfscript>
		if (StructKeyExists(request.wheels, "currentFormMethod"))
			StructDelete(request.wheels, "currentFormMethod");
	</cfscript>
	<cfreturn "</form>">
</cffunction>

<cffunction name="submitTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a submit button `form` control."
	examples=
	'
		!--- view code --->
		<cfoutput>
		    ##startFormTag(action="something")##
		        <!--- form controls go here --->
		        ##submitTag()##
		    ##endFormTag()##
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="value" type="string" required="false" default="#application.wheels.functions.submitTag.value#" hint="Message to display in the button form control">
	<cfargument name="image" type="string" required="false" default="#application.wheels.functions.submitTag.image#" hint="File name of the image file to use in the button form control">
	<cfargument name="disable" type="any" required="false" default="#application.wheels.functions.submitTag.disable#" hint="Whether to disable the button upon clicking (prevents double-clicking)">
	<cfscript>
		var loc = {};
		$insertDefaults(name="submitTag", reserved="type,src", input=arguments);
		if (Len(arguments.disable))
		{
			loc.onclick = "this.disabled=true;";
			if (!Len(arguments.image) && !IsBoolean(arguments.disable))
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

<cffunction name="textField" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a text field form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##textField(label="First Name", objectName="user", property="firstName")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="The variable name of the object to build the form control for">
	<cfargument name="property" type="string" required="true" hint="The name of the property (database column) to use in the form control">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textField.label#" hint="The label text to use in the form control">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textField.labelPlacement#" hint="Whether to place the label before, after, or wrapped around the form control">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textField.prepend#" hint="String to prepend to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textField.append#" hint="String to append to the form control. Useful to wrap the form control around HTML tags">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textField.prependToLabel#" hint="String to prepend to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textField.appendToLabel#" hint="String to append to the form control's label. Useful to wrap the form control around HTML tags">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.textField.errorElement#" hint="HTML tag to wrap the form control with when the object contains errors">
	<cfscript>
		var loc = {};
		$insertDefaults(name="textField", reserved="type,name,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "text";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = $formValue(argumentCollection=arguments);
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textFieldTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a text field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##textFieldTag(name="someName")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="Name to populate in tag's `name` attribute">
	<cfargument name="value" type="string" required="false" default="" hint="Value to populate in tag's `value` attribute">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textFieldTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textFieldTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textFieldTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textFieldTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textFieldTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textFieldTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = textField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="passwordField" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a password field form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##passwordField(objectName="user", property="pass")##</p>
		</cfoutput>
	'
	categories="view-helper" chapter="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.passwordField.label#" hint="See documentation for textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.passwordField.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.passwordField.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.passwordField.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.passwordField.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.passwordField.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.passwordField.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="passwordField", reserved="type,name,value", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "password";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = $formValue(argumentCollection=arguments);
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="passwordFieldTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a password field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##passwordFieldTag(name="password")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="value" type="string" required="false" default="" hint="See documentation for @textFieldTag">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = passwordField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="hiddenField" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a hidden field form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##hiddenField(objectName="user", property="id")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="hiddenField", reserved="type,name,value", input=arguments);
		arguments.type = "hidden";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = $formValue(argumentCollection=arguments);
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
			arguments.value = obfuscateParam(arguments.value);
		loc.returnValue = $tag(name="input", close=true, skip="objectName,property", attributes=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="hiddenFieldTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a hidden field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##hiddenFieldTag(name="userId", value=user.id)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="value" type="string" required="false" default="" hint="See documentation for @textFieldTag">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.returnValue = hiddenField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="fileField" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a file field form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##fileField(objectName="photo", property="imageFile")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.fileField.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.fileField.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.fileField.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.fileField.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.fileField.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.fileField.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.fileField.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="fileField", reserved="type,name", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "file";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="fileFieldTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a file form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##fileFieldTag(name="photo")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.fileFieldTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.fileFieldTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.fileFieldTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.fileFieldTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.fileFieldTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.fileFieldTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = "";
		StructDelete(arguments, "name");
		loc.returnValue = fileField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textArea" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a password field form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		  <p>##textArea(objectName="article", property="overview")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textArea.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textArea.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textArea.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textArea.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textArea.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textArea.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.textArea.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="textArea", reserved="name", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		loc.content = $formValue(argumentCollection=arguments);
		loc.returnValue = loc.before & $element(name="textarea", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="textAreaTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a text area form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		  <p>##textAreaTag(name="description")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="content" type="string" required="false" default="" hint="Content to display in `textarea` by default">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textAreaTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textAreaTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textAreaTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textAreaTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textAreaTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textAreaTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.content;
		StructDelete(arguments, "name");
		StructDelete(arguments, "content");
		loc.returnValue = textArea(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButton" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a radio button form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>
			    ##radioButton(objectName="user", property="gender", tagValue="m", label="Male")##<br />
		        ##radioButton(objectName="user", property="gender", tagValue="f", label="Female")##
			</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textField,submitTag,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="tagValue" type="string" required="true" hint="The value of the radio button when `selected`">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.radioButton.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.radioButton.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.radioButton.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.radioButton.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.radioButton.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.radioButton.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.radioButton.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="radioButton", reserved="type,name,value,checked", input=arguments);
		loc.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.tagValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
		arguments.$appendToFor = loc.valueToAppend;
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "radio";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
		{
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(loc.valueToAppend))
				arguments.id = arguments.id & "-" & loc.valueToAppend;
		}
		arguments.value = arguments.tagValue;
		if (arguments.tagValue == $formValue(argumentCollection=arguments))
			arguments.checked = "checked";
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,tagValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="radioButtonTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a radio button form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>
			    ##radioButtonTag(name="gender", value="m", label="Male", checked=true)##<br />
		        ##radioButtonTag(name="gender", value="f", label="Female")##
			</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="value" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not to check the radio button by default">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.radioButtonTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.radioButtonTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.radioButtonTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.radioButtonTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.radioButtonTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.radioButtonTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		if (arguments.checked)
		{
			arguments.objectName[arguments.name] = arguments.value;
			arguments.tagValue = arguments.value;
		}
		else
		{
			arguments.objectName[arguments.name] = "";
			arguments.tagValue = arguments.value;
		}
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		loc.returnValue = radioButton(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="checkBox" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a check box form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##checkBox(objectName="photo", property="isPublic", label="Display this photo publicly.")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="checkedValue" type="string" required="false" default="#application.wheels.functions.checkBox.checkedValue#" hint="The value of the check box when it's on the `checked` state">
	<cfargument name="uncheckedValue" type="string" required="false" default="#application.wheels.functions.checkBox.uncheckedValue#" hint="The value of the check box when it's on the `unchecked` state">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.checkBox.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.checkBox.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.checkBox.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.checkBox.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.checkBox.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.checkBox.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.checkBox.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="checkBox", reserved="type,name,value,checked", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.type = "checkbox";
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		arguments.value = arguments.checkedValue;
		loc.value = $formValue(argumentCollection=arguments);
		if (loc.value == arguments.value || IsNumeric(loc.value) && loc.value == 1 || !IsNumeric(loc.value) && IsBoolean(loc.value) && loc.value)
			arguments.checked = "checked";
		loc.returnValue = loc.before & $tag(name="input", close=true, skip="objectName,property,checkedValue,uncheckedValue,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", attributes=arguments);
		if (!IsStruct(arguments.objectName))
		{
			loc.hiddenAttributes = {};
			loc.hiddenAttributes.type = "hidden";
			loc.hiddenAttributes.name = arguments.name & "($checkbox)";
			loc.hiddenAttributes.value = arguments.uncheckedValue;
			loc.returnValue = loc.returnValue & $tag(name="input", close=true, attributes=loc.hiddenAttributes);
		}
		loc.returnValue = loc.returnValue & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="checkBoxTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a check box form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##checkBoxTag(name="suscribe", value="true", label="Suscribe to our newsletter", checked=false)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTag,dateSelectTag,timeSelectTag">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not the check box should be checked by default">
	<cfargument name="value" type="string" required="false" default="#application.wheels.functions.checkBoxTag.value#" hint="Value of check box in its `checked` state">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.checkBoxTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.checkBoxTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.checkBoxTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.checkBoxTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.checkBoxTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.checkBoxTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.checkedValue = arguments.value;
		arguments.property = arguments.name;
		arguments.objectName = {};
		if (arguments.checked)
			arguments.objectName[arguments.name] = arguments.value;
		else
			arguments.objectName[arguments.name] = "";
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		loc.returnValue = checkBox(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="select" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a select form control based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- controller code --->
		<cfset authors = model("author").findAll()>

		<!--- view code --->
		<cfoutput>
		    <p>##select(objectName="book", property="authorId", options=authors)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,dateTimeSelect,dateSelect,timeSelect">
	<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="options" type="any" required="true" hint="A collection to populate the select form control with. Can be a query recordset or an array of objects">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.select.includeBlank#" hint="Whether to include a blank option in the select form control. Pass `true` to include a blank line or a string that should represent what display text should appear for the empty value (for example, '- Select One -')">
	<cfargument name="valueField" type="string" required="false" default="#application.wheels.functions.select.valueField#" hint="The column or property to use for the value of each list element. Used only when a query or array of objects has been supplied in the `options` argument">
	<cfargument name="textField" type="string" required="false" default="#application.wheels.functions.select.textField#" hint="The column or property to use for the value of each list element that the end user will see. Used only when a query or array of objects has been supplied in the `options` argument">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.select.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.select.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.select.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.select.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.select.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.select.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.select.errorElement#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		$insertDefaults(name="select", reserved="name", input=arguments);
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		arguments.name = $tagName(arguments.objectName, arguments.property);
		if (!StructKeyExists(arguments, "id"))
			arguments.id = $tagId(arguments.objectName, arguments.property);
		if (StructKeyExists(arguments, "multiple"))
		{
			if (arguments.multiple)
				arguments.multiple = "multiple";
			else
				StructDelete(arguments, "multiple");
		}
		loc.content = $optionsForSelect(argumentCollection=arguments);
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			if (!IsBoolean(arguments.includeBlank))
				loc.blankOptionText = arguments.includeBlank;
			else
				loc.blankOptionText = "";
			loc.blankOptionAttributes = {value=""};
			loc.content = $element(name="option", content=loc.blankOptionText, attributes=loc.blankOptionAttributes) & loc.content;
		}
		loc.returnValue = loc.before & $element(name="select", skip="objectName,property,options,includeBlank,valueField,textField,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="selectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a select form control based on the supplied `name` and `options`."
	examples=
	'
		<!--- controller code --->
		<cfset cities = model("city").findAll()>

		<!--- view code --->
		<cfoutput>
		    <p>##selectTag(name="cityId", options=cities)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="options" type="any" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="Value of option that should be selected by default">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.selectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="multiple" type="boolean" required="false" default="#application.wheels.functions.selectTag.multiple#" hint="Whether to allow multiple selection of options in the select form control">
	<cfargument name="valueField" type="string" required="false" default="#application.wheels.functions.selectTag.valueField#" hint="See documentation for @select">
	<cfargument name="textField" type="string" required="false" default="#application.wheels.functions.selectTag.textField#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.selectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.selectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.selectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.selectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.selectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.selectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		loc.returnValue = select(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="dateSelect" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing three select form controls for a date based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		  <p>##dateSelect(objectName="user", property="dateOfBirth")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textField,submitTag,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,timeSelect">
	<cfargument name="objectName" type="any" required="false" default="" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="false" default="" hint="See documentation for @textField">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.dateSelect.order#" hint="Use to change the order of or exclude date select tags">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateSelect.separator#" hint="Use to change the character that is displayed between the date select tags">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateSelect.startYear#" hint="First year in select list">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateSelect.endYear#" hint="Last year in select list">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateSelect.monthDisplay#" hint="Pass in `names`, `numbers` or `abbreviations` to control display">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateSelect.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateSelect.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateSelect.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateSelect.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateSelect.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateSelect.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateSelect.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.dateSelect.errorElement#" hint="See documentation for @textField">
	<cfscript>
		$insertDefaults(name="dateSelect", input=arguments);
		arguments.$functionName = "dateSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateSelectTags" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing three select form controls (month, day and year)."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateSelectTags()##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,textFieldTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.dateSelectTags.order#" hint="See documentation for @dateSelect">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateSelectTags.separator#" hint="See documentation for @dateSelect">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateSelectTags.startYear#" hint="See documentation for @dateSelect">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateSelectTags.endYear#" hint="See documentation for @dateSelect">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateSelectTags.monthDisplay#" hint="See documentation for @dateSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateSelectTags.includeBlank#" hint="See documentation for @dateSelect">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateSelectTags.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateSelectTags.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateSelectTags.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateSelectTags.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateSelectTags.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateSelectTags.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "dateSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##timeSelect(objectName="business", property="openUntil")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateTimeSelect,dateSelect">
	<cfargument name="objectName" type="any" required="false" default="" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="false" default="" hint="See documentation for @textField">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.timeSelect.order#" hint="Use to change the order of or exclude time select tags">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.timeSelect.separator#" hint="Use to change the character that is displayed between the time select tags">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.timeSelect.minuteStep#" hint="Pass in `10` to only show minute 10, 20,30 etc">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.timeSelect.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.timeSelect.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.timeSelect.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.timeSelect.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.timeSelect.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.timeSelect.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.timeSelect.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.timeSelect.errorElement#" hint="See documentation for @textField">
	<cfscript>
		$insertDefaults(name="timeSelect", input=arguments);
		arguments.$functionName = "timeSelect";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelectTags" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing three select form controls for a time based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##timeSelectTags(name="timeOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag">
	<cfargument name="order" type="string" required="false" default="#application.wheels.functions.timeSelectTags.order#" hint="See documentation for @timeSelect">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.timeSelectTags.separator#" hint="See documentation for @timeSelect">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.timeSelectTags.minuteStep#" hint="See documentation for @timeSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.timeSelectTags.includeBlank#" hint="See documentation for @timeSelect">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.timeSelectTags.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.timeSelectTags.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.timeSelectTags.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.timeSelectTags.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.timeSelectTags.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.timeSelectTags.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		arguments.$functionName = "timeSelectTag";
	</cfscript>
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelect" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection) based on the supplied `objectName` and `property`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateTimeSelect(objectName="article", property="publishedAt")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textField,radioButton,checkBox,passwordField,hiddenField,textArea,fileField,select,dateSelect,timeSelect">
	<cfargument name="objectName" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="property" type="string" required="true" hint="See documentation for @textField">
	<cfargument name="dateOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.dateOrder#" hint="See documentation for @dateSelect">
	<cfargument name="dateSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.dateSeparator#" hint="See documentation for @dateSelect">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.startYear#" hint="See documentation for @dateSelect">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.endYear#" hint="See documentation for @dateSelect">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.monthDisplay#" hint="See documentation for @dateSelect">
	<cfargument name="timeOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.timeOrder#" hint="See documentation for @timeSelect">
	<cfargument name="timeSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.timeSeparator#" hint="See documentation for @timeSelect">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelect.minuteStep#" hint="See documentation for @timeSelect">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.separator#" hint="Use to change the character that is displayed between the first and second set of select tags">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateTimeSelect.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.appendToLabel#" hint="See documentation for @textField">
	<cfargument name="errorElement" type="string" required="false" default="#application.wheels.functions.dateTimeSelect.errorElement#" hint="See documentation for @textField">
	<cfscript>
		$insertDefaults(name="dateTimeSelect", reserved="name", input=arguments);
		arguments.$functionName = "dateTimeSelect";
	</cfscript>
	<cfreturn dateTimeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelectTags" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing six select form controls (three for date selection and the remaining three for time selection)."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##dateTimeSelectTags()##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="See documentation for @selectTag.">
	<cfargument name="dateOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.dateOrder#" hint="See documentation for @dateTimeSelect">
	<cfargument name="dateSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.dateSeparator#" hint="See documentation for @dateTimeSelect">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.startYear#" hint="See documentation for @dateTimeSelect">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.endYear#" hint="See documentation for @dateTimeSelect">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.monthDisplay#" hint="See documentation for @dateTimeSelect">
	<cfargument name="timeOrder" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.timeOrder#" hint="See documentation for @dateTimeSelect">
	<cfargument name="timeSeparator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.timeSeparator#" hint="See documentation for @dateTimeSelect">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.dateTimeSelectTags.minuteStep#" hint="See documentation for @dateTimeSelect">
	<cfargument name="separator" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.separator#" hint="See documentation for @dateTimeSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.dateTimeSelectTags.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.label#" hint="See documentation for @textField@">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.dateTimeSelectTags.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.separator = arguments.separator;
		arguments.order = arguments.dateOrder;
		arguments.separator = arguments.dateSeparator;
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & dateSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & dateSelectTags(argumentCollection=arguments);
		loc.returnValue = loc.returnValue & loc.separator;
		arguments.order = arguments.timeOrder;
		arguments.separator = arguments.timeSeparator;
		if (StructKeyExists(arguments, "$functionName") && arguments.$functionName == "dateTimeSelect")
			loc.returnValue = loc.returnValue & timeSelect(argumentCollection=arguments);
		else
			loc.returnValue = loc.returnValue & timeSelectTags(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="yearSelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a select form control for a range of years based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##yearSelectTag(name="yearOfBirthday")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The year that should be selected initially">
	<cfargument name="startYear" type="numeric" required="false" default="#application.wheels.functions.yearSelectTag.startYear#" hint="See documentation for @dateSelect">
	<cfargument name="endYear" type="numeric" required="false" default="#application.wheels.functions.yearSelectTag.endYear#" hint="See documentation for @dateSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.yearSelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.yearSelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.yearSelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.yearSelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.yearSelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.yearSelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.yearSelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected))
			arguments.selected = createDate(arguments.selected, Month(Now()), Day(Now()));
		arguments.order = "year";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="monthSelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a select form control for the months of the year based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##monthSelectTag(name="monthOfBirthday")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The month that should be selected initially">
	<cfargument name="monthDisplay" type="string" required="false" default="#application.wheels.functions.monthSelectTag.monthDisplay#" hint="See documentation for @dateSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.monthSelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.monthSelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.monthSelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.monthSelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.monthSelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.monthSelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.monthSelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 12)
			arguments.selected = createDate(Year(Now()), arguments.selected, Day(Now()));
		arguments.order = "month";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="daySelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing a select form control for the days of the week based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##daySelectTag(name="dayOfWeek")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The day that should be selected initially">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.daySelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.daySelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.daySelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.daySelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.daySelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.daySelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.daySelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected) and arguments.selected gt 0 and arguments.selected lte 31)
			arguments.selected = createDate(Year(Now()), Month(Now()), arguments.selected);
		arguments.order = "day";
	</cfscript>
	<cfreturn dateSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="hourSelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing one select form control for the hours of the day based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##hourSelectTag(name="hourOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The hour that should be selected initially">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.hourSelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.hourSelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.hourSelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.hourSelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.hourSelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.hourSelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.hourSelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(arguments.selected, Minute(Now()), Second(Now()));
		arguments.order = "hour";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="minuteSelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing one select form control for the minutes of an hour based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##minuteSelectTag(name="minuteOfMeeting")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The minute that should be selected initially">
	<cfargument name="minuteStep" type="numeric" required="false" default="#application.wheels.functions.minuteSelectTag.minuteStep#" hint="See documentation for @timeSelect">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.minuteSelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.minuteSelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(Hour(Now()), arguments.selected, Second(Now()));
		arguments.order = "minute";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="string" access="public" output="false"
	hint="Builds and returns a string containing one select form control for the seconds of a minute based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##secondSelectTag(name="secondsToLaunch")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag">
	<cfargument name="selected" type="string" required="false" default="" hint="The second that should be selected initially">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.secondSelectTag.includeBlank#" hint="See documentation for @select">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.secondSelectTag.label#" hint="See documentation for @textField">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.secondSelectTag.labelPlacement#" hint="See documentation for @textField">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.secondSelectTag.prepend#" hint="See documentation for @textField">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.secondSelectTag.append#" hint="See documentation for @textField">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.secondSelectTag.prependToLabel#" hint="See documentation for @textField">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.secondSelectTag.appendToLabel#" hint="See documentation for @textField">
	<cfscript>
		if (IsNumeric(arguments.selected) and arguments.selected gte 0 and arguments.selected lt 60)
			arguments.selected = createTime(Hour(Now()), Minute(Now()), arguments.selected);
		arguments.order = "second";
	</cfscript>
	<cfreturn timeSelectTags(argumentCollection=arguments)>
</cffunction>

<cffunction name="$yearSelectTag" returntype="string" access="public" output="false">
	<cfargument name="startYear" type="numeric" required="true">
	<cfargument name="endYear" type="numeric" required="true">
	<cfscript>
		if (structkeyexists(arguments, "value") && val(arguments.value) gt 0 && arguments.value lt arguments.startYear)
		{
			arguments.startYear = arguments.value;
		}
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

<cffunction name="$dateOrTimeSelect" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="$functionName" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.name = $tagName(arguments.objectName, arguments.property);
		arguments.$id = $tagId(arguments.objectName, arguments.property);
		loc.value = $formValue(argumentCollection=arguments);
		loc.returnValue = "";
		loc.firstDone = false;
		loc.iEnd = ListLen(arguments.order);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.order, loc.i);
			arguments.name = loc.name & "($" & loc.item & ")";
			if (Len(loc.value))
				if (Isdate(loc.value))
					arguments.value = Evaluate("#loc.item#(loc.value)");
				else
					arguments.value = loc.value;
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
	<cfargument name="labelPlacement" type="string" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="false" default="">
	<cfargument name="$type" type="string" required="true">
	<cfargument name="$loopFrom" type="numeric" required="true">
	<cfargument name="$loopTo" type="numeric" required="true">
	<cfargument name="$id" type="string" required="true">
	<cfargument name="$step" type="numeric" required="true">
	<cfargument name="$optionNames" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (!Len(arguments.value) && (!IsBoolean(arguments.includeBlank) || !arguments.includeBlank))
			arguments.value = Evaluate("#arguments.$type#(Now())");
		arguments.$appendToFor = arguments.$type;
		if (StructKeyExists(arguments, "order") && ListLen(arguments.order) > 1 && ListLen(arguments.label) > 1)
			arguments.label = ListGetAt(arguments.label, ListFindNoCase(arguments.order, arguments.$type));
		loc.before = $formBeforeElement(argumentCollection=arguments);
		loc.after = $formAfterElement(argumentCollection=arguments);
		loc.content = "";
		if (!IsBoolean(arguments.includeBlank) || arguments.includeBlank)
		{
			loc.args = {};
			loc.args.value = "";
			if (!IsBoolean(arguments.includeBlank))
				loc.optionContent = arguments.includeBlank;
			else
				loc.optionContent = "";
			loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
		}
		for (loc.i=arguments.$loopFrom; loc.i <= arguments.$loopTo; loc.i=loc.i+arguments.$step)
		{
			loc.args = {};
			loc.args.value = loc.i;
			if (arguments.value == loc.i)
				loc.args.selected = "selected";
			if (Len(arguments.$optionNames))
				loc.optionContent = ListGetAt(arguments.$optionNames, loc.i);
			else
				loc.optionContent = loc.i;
			if (arguments.$type == "minute" || arguments.$type == "second")
				loc.optionContent = NumberFormat(loc.optionContent, "09");
			loc.content = loc.content & $element(name="option", content=loc.optionContent, attributes=loc.args);
		}
		if (!StructKeyExists(arguments, "id"))
			arguments.id = arguments.$id & "-" & arguments.$type;
		loc.returnValue = loc.before & $element(name="select", skip="objectName,property,label,labelPlacement,prepend,append,prependToLabel,appendToLabel,errorElement,value,includeBlank,order,separator,startYear,endYear,monthDisplay,dateSeparator,dateOrder,timeSeparator,timeOrder,minuteStep", skipStartingWith="label", content=loc.content, attributes=arguments) & loc.after;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$optionsForSelect" returntype="string" access="public" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="string" required="true">
	<cfargument name="textField" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.value = $formValue(argumentCollection=arguments);
		loc.returnValue = "";
		if (IsQuery(arguments.options))
		{
			if (!Len(arguments.valueField) || !Len(arguments.textField))
			{
				// order the columns according to their ordinal position in the database table
				loc.info = GetMetaData(arguments.options);
				loc.iEnd = ArrayLen(loc.info);
				loc.columns = "";
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					loc.columns = ListAppend(loc.columns, loc.info[loc.i].name);
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
								arguments.valueField = ListGetAt(loc.columns, loc.j);
							if (!Len(arguments.textField) && !IsNumeric(arguments.options[ListGetAt(loc.columns, loc.j)][loc.i]))
								arguments.textField = ListGetAt(loc.columns, loc.j);
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
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=arguments.options[arguments.valueField][loc.i], optionText=arguments.options[arguments.textField][loc.i]);
			}
		}
		else if (IsStruct(arguments.options))
		{
			loc.sortedKeys = ListSort(StructKeyList(arguments.options), "textnocase"); // sort struct keys alphabetically
			loc.iEnd = ListLen(loc.sortedKeys);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.key = ListGetAt(loc.sortedKeys, loc.i);
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=LCase(loc.key), optionText=arguments.options[loc.key]);
			}
		}
		else
		{
			// convert the options to an array so we don't duplicate logic
			if (IsSimpleValue(arguments.options))
				arguments.options = ListToArray(arguments.options);

			// loop through the array
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
				loc.returnValue = loc.returnValue & $option(objectValue=loc.value, optionValue=loc.optionValue, optionText=loc.optionText);
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
		var loc = {};
		loc.optionAttributes = {value=arguments.optionValue};
		if (arguments.optionValue == arguments.objectValue || ListFindNoCase(arguments.objectValue, arguments.optionValue))
			loc.optionAttributes.selected = "selected";
		if (application.wheels.obfuscateUrls && StructKeyExists(request.wheels, "currentFormMethod") && request.wheels.currentFormMethod == "get")
			loc.optionAttributes.value = obfuscateParam(loc.optionAttributes.value);
		loc.returnValue = $element(name="option", content=arguments.optionText, attributes=loc.optionAttributes);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (IsStruct(arguments.objectName))
		{
			loc.returnValue = arguments.objectName[arguments.property];
		}
		else
		{
			loc.object = $getObject(arguments.objectName);
			if (application.wheels.showErrorInformation && !IsObject(loc.object))
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			if (StructKeyExists(loc.object, arguments.property))
				loc.returnValue = loc.object[arguments.property];
			else
				loc.returnValue = "";
		}
	</cfscript>
	<cfreturn HTMLEditFormat(loc.returnValue)>
</cffunction>

<cffunction name="$formHasError" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (!IsStruct(arguments.objectName))
		{
			loc.object = $getObject(arguments.objectName);
			if (application.wheels.showErrorInformation && !IsObject(loc.object))
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.objectName#` variable is not an object.");
			if (ArrayLen(loc.object.errorsOn(arguments.property)))
				loc.returnValue = true;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createLabel" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="$appendToFor" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = arguments.prependToLabel;
		loc.attributes = {};
		for (loc.key in arguments)
			if (Left(loc.key, 5) == "label" && Len(loc.key) > 5 && loc.key != "labelPlacement")
				loc.attributes[Replace(loc.key, "label", "")] = arguments[loc.key];
		if (StructKeyExists(arguments, "id"))
			loc.attributes.for = arguments.id;
		else
			loc.attributes.for = $tagId(arguments.objectName, arguments.property);
		if (Len(arguments.$appendToFor))
			loc.attributes.for = loc.attributes.for & "-" & arguments.$appendToFor;
		loc.returnValue = loc.returnValue & $tag(name="label", attributes=loc.attributes);
		loc.returnValue = loc.returnValue & arguments.label;
		loc.returnValue = loc.returnValue & "</label>";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formBeforeElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="labelPlacement" type="string" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfargument name="$appendToFor" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		if ($formHasError(argumentCollection=arguments) and Len(arguments.errorElement))
			loc.returnValue = loc.returnValue & $tag(name=arguments.errorElement, class="field-with-errors");
		if (Len(arguments.label) && arguments.labelPlacement != "after")
		{
			loc.returnValue = loc.returnValue & $createLabel(argumentCollection=arguments);
			if (arguments.labelPlacement == "around")
				loc.returnValue = Replace(loc.returnValue, "</label>", "");
			else
				loc.returnValue = loc.returnValue & arguments.appendToLabel;

		}
		loc.returnValue = loc.returnValue & arguments.prepend;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$formAfterElement" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="labelPlacement" type="string" required="true">
	<cfargument name="prepend" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="prependToLabel" type="string" required="true">
	<cfargument name="appendToLabel" type="string" required="true">
	<cfargument name="errorElement" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = arguments.append;
		if (Len(arguments.label) && arguments.labelPlacement != "before")
		{
			if (arguments.labelPlacement == "after")
				loc.returnValue = loc.returnValue & $createLabel(argumentCollection=arguments);
			else if (arguments.labelPlacement == "around")
				loc.returnValue = loc.returnValue & "</label>";
			loc.returnValue = loc.returnValue & arguments.appendToLabel;
		}
		if ($formHasError(argumentCollection=arguments) and Len(arguments.errorElement))
			loc.returnValue = loc.returnValue & "</" & arguments.errorElement & ">";
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>