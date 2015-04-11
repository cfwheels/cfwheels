<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="textFieldTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfargument name="type" type="string" required="false" default="text">
	<cfscript>
		var loc = {};
		$args(name="textFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.rv = textField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="passwordFieldTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="passwordFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.rv = passwordField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hiddenFieldTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.value;
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		loc.rv = hiddenField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="fileFieldTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="fileFieldTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = "";
		StructDelete(arguments, "name");
		loc.rv = fileField(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="textAreaTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="content" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="textAreaTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.content;
		StructDelete(arguments, "name");
		StructDelete(arguments, "content");
		loc.rv = textArea(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="radioButtonTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="value" type="string" required="true">
	<cfargument name="checked" type="boolean" required="false" default="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
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
		loc.rv = radioButton(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="checkBoxTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="checked" type="boolean" required="false" default="false">
	<cfargument name="value" type="string" required="false">
	<cfargument name="uncheckedValue" type="string" required="false" default="">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
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
			loc.valueToAppend = LCase(Replace(ReReplaceNoCase(arguments.checkedValue, "[^a-z0-9- ]", "", "all"), " ", "-", "all"));
			arguments.id = $tagId(arguments.objectName, arguments.property);
			if (len(loc.valueToAppend))
			{
				arguments.id &= "-" & loc.valueToAppend;
			}
		}
		StructDelete(arguments, "name");
		StructDelete(arguments, "value");
		StructDelete(arguments, "checked");
		loc.rv = checkBox(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="selectTag" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="options" type="any" required="true">
	<cfargument name="selected" type="string" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false">
	<cfargument name="multiple" type="boolean" required="false">
	<cfargument name="valueField" type="string" required="false">
	<cfargument name="textField" type="string" required="false">
	<cfargument name="label" type="string" required="false">
	<cfargument name="labelPlacement" type="string" required="false">
	<cfargument name="prepend" type="string" required="false">
	<cfargument name="append" type="string" required="false">
	<cfargument name="prependToLabel" type="string" required="false">
	<cfargument name="appendToLabel" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="selectTag", args=arguments);
		arguments.property = arguments.name;
		arguments.objectName = {};
		arguments.objectName[arguments.name] = arguments.selected;
		StructDelete(arguments, "name");
		StructDelete(arguments, "selected");
		loc.rv = select(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>