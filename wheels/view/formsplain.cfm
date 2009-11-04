<cffunction name="textFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##textFieldTag(name="someName")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="Name to populate in tag's `name` attribute.">
	<cfargument name="value" type="string" required="false" default="" hint="Value to populate in tag's `value` attribute.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textFieldTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textFieldTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textFieldTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textFieldTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textFieldTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textFieldTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="passwordFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a password field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##passwordFieldTag(name="password")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="value" type="string" required="false" default="" hint="See documentation for @textFieldTag.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.passwordFieldTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="hiddenFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a hidden field form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##hiddenFieldTag(name="userId", value=user.id)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="value" type="string" required="false" default="" hint="See documentation for @textFieldTag.">
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

<cffunction name="fileFieldTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a file form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##fileFieldTag(name="photo")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,textAreaTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.fileFieldTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.fileFieldTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.fileFieldTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.fileFieldTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.fileFieldTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.fileFieldTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="textAreaTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a text area form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		  <p>##textAreaTag(name="description")##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,checkBoxTag,passwordFieldTag,hiddenFieldTag,fileFieldTag,selectTag,dateTimeSelectTags,dateSelectTags,timeSelectTags">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="content" type="string" required="false" default="" hint="Content to display in `textarea` by default.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.textAreaTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.textAreaTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.textAreaTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.textAreaTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.textAreaTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.textAreaTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="radioButtonTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a radio button form control based on the supplied `name`."
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
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="value" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not to check the radio button by default.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.radioButtonTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.radioButtonTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.radioButtonTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.radioButtonTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.radioButtonTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.radioButtonTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="checkBoxTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a check box form control based on the supplied `name`."
	examples=
	'
		<!--- view code --->
		<cfoutput>
		    <p>##checkBoxTag(name="suscribe", value="true", label="Suscribe to our newsletter", checked=false)##</p>
		</cfoutput>
	'
	categories="view-helper" chapters="form-helpers-and-showing-errors" functions="URLFor,startFormTag,endFormTag,submitTag,textFieldTag,radioButtonTag,passwordFieldTag,hiddenFieldTag,textAreaTag,fileFieldTag,selectTag,dateTimeSelectTag,dateSelectTag,timeSelectTag">
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether or not the check box should be checked by default.">
	<cfargument name="value" type="string" required="false" default="#application.wheels.functions.checkBoxTag.value#" hint="Value of check box in its `checked` state.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.checkBoxTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.checkBoxTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.checkBoxTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.checkBoxTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.checkBoxTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.checkBoxTag.appendToLabel#" hint="See documentation for @textField.">
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

<cffunction name="selectTag" returntype="string" access="public" output="false" hint="Builds and returns a string containing a select form control based on the supplied `name` and `options`."
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
	<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="options" type="any" required="true" hint="See documentation for @textFieldTag.">
	<cfargument name="selected" type="string" required="false" default="" hint="Value of option that should be selected by default.">
	<cfargument name="includeBlank" type="any" required="false" default="#application.wheels.functions.selectTag.includeBlank#" hint="See documentation for @select.">
	<cfargument name="multiple" type="boolean" required="false" default="#application.wheels.functions.selectTag.multiple#" hint="Whether to allow multiple selection of options in the select form control.">
	<cfargument name="valueField" type="string" required="false" default="#application.wheels.functions.selectTag.valueField#" hint="See documentation for @select.">
	<cfargument name="textField" type="string" required="false" default="#application.wheels.functions.selectTag.textField#" hint="See documentation for @select.">
	<cfargument name="label" type="string" required="false" default="#application.wheels.functions.selectTag.label#" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" default="#application.wheels.functions.selectTag.labelPlacement#" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" default="#application.wheels.functions.selectTag.prepend#" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" default="#application.wheels.functions.selectTag.append#" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" default="#application.wheels.functions.selectTag.prependToLabel#" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" default="#application.wheels.functions.selectTag.appendToLabel#" hint="See documentation for @textField.">
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
