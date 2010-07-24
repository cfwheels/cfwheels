<cffunction name="hasManyRadioButton" returntype="string" access="public" output="false" hint="Used as a short cut to output the proper form elements for an association. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.">
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="association" type="string" required="true" />
	<cfargument name="property" type="string" required="true" />
	<cfargument name="keys" type="string" required="true" />
	<cfargument name="tagValue" type="string" required="true" />
	<cfargument name="checkIfBlank" type="boolean" required="false" default="false" />
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		var loc = {};
		$args(name="hasManyRadioButton", args=arguments);
		loc.checked = false;
		loc.returnValue = "";
		loc.value = $hasManyFormValue(argumentCollection=arguments);
		loc.included = includedInObject(argumentCollection=arguments);
		
		if (!loc.included)
		{
			loc.included = "";
		}
		
		if (loc.value == arguments.tagValue || (arguments.checkIfBlank && loc.value != arguments.tagValue))
			loc.checked = true;
		
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-#arguments.property#-#arguments.tagValue#";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][#arguments.property#]";
		loc.returnValue = radioButtonTag(name=loc.tagName, id=loc.tagId, value=arguments.tagValue, checked=loc.checked, label=arguments.label);
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="hasManyCheckBox" returntype="string" access="public" output="false" hint="Used as a short cut to output the proper form elements for an association. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.">
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="association" type="string" required="true" />
	<cfargument name="keys" type="string" required="true" />
	<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
	<cfargument name="errorElement" type="string" required="false" hint="See documentation for @textField.">
	<cfscript>
		var loc = {};
		$args(name="hasManyCheckBox", args=arguments);
		loc.checked = true;
		loc.returnValue = "";
		loc.included = includedInObject(argumentCollection=arguments);
		
		if (!loc.included)
		{
			loc.included = "";
			loc.checked = false;
		}
		
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-_delete";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][_delete]";
		
		StructDelete(arguments, "keys", false);
		StructDelete(arguments, "objectName", false);
		StructDelete(arguments, "association", false);
		
		loc.returnValue = checkBoxTag(name=loc.tagName, id=loc.tagId, value=0, checked=loc.checked, uncheckedValue=1, argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="includedInObject" returntype="boolean" access="public" output="false" hint="Used as a short cut to check if the specified ids are a part of the main form object. This method should only be used for hasMany associations.">
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="association" type="string" required="true" />
	<cfargument name="keys" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.returnValue = 0;
		loc.object = $getObject(arguments.objectName);
		
		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
			return loc.returnValue;
		
		if (!Len(arguments.keys))
			return loc.returnValue;
		
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (isObject(loc.assoc) && loc.assoc.key() == arguments.keys)
			{
				loc.returnValue = loc.i;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$hasManyFormValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="association" type="string" required="true" />
	<cfargument name="property" type="string" required="true" />
	<cfargument name="keys" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.object = $getObject(arguments.objectName);
		
		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
			return loc.returnValue;
		
		if (!Len(arguments.keys))
			return loc.returnValue;
		
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (isObject(loc.assoc) && loc.assoc.key() == arguments.keys && StructKeyExists(loc.assoc, arguments.property))
			{
				loc.returnValue = loc.assoc[arguments.property];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>