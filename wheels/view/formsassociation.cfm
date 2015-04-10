<!--- PUBLIC VIEW HELPER FUNCTIONS --->

<cffunction name="hasManyRadioButton" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="association" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="keys" type="string" required="true">
	<cfargument name="tagValue" type="string" required="true">
	<cfargument name="checkIfBlank" type="boolean" required="false" default="false">
	<cfargument name="label" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="hasManyRadioButton", args=arguments);
		loc.checked = false;
		loc.rv = "";
		loc.value = $hasManyFormValue(argumentCollection=arguments);
		loc.included = includedInObject(argumentCollection=arguments);
		if (!loc.included)
		{
			loc.included = "";
		}
		if (loc.value == arguments.tagValue || (arguments.checkIfBlank && loc.value != arguments.tagValue))
		{
			loc.checked = true;
		}
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-#arguments.property#-#arguments.tagValue#";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][#arguments.property#]";
		loc.rv = radioButtonTag(name=loc.tagName, id=loc.tagId, value=arguments.tagValue, checked=loc.checked, label=arguments.label);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hasManyCheckBox" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="association" type="string" required="true">
	<cfargument name="keys" type="string" required="true">
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
		$args(name="hasManyCheckBox", args=arguments);
		loc.checked = true;
		loc.rv = "";
		loc.included = includedInObject(argumentCollection=arguments);
		if (!loc.included)
		{
			loc.included = "";
			loc.checked = false;
		}
		loc.tagId = "#arguments.objectName#-#arguments.association#-#Replace(arguments.keys, ",", "-", "all")#-_delete";
		loc.tagName = "#arguments.objectName#[#arguments.association#][#arguments.keys#][_delete]";
		StructDelete(arguments, "keys");
		StructDelete(arguments, "objectName");
		StructDelete(arguments, "association");
		loc.rv = checkBoxTag(name=loc.tagName, id=loc.tagId, value=0, checked=loc.checked, uncheckedValue=1, argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="includedInObject" returntype="boolean" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="association" type="string" required="true">
	<cfargument name="keys" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		loc.object = $getObject(arguments.objectName);

		// clean up our key argument if there is a comma on the beginning or end
		arguments.keys = REReplace(arguments.keys, "^,|,$", "", "all");

		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
		{
			return loc.rv;
		}
		if (!Len(arguments.keys))
		{
			return loc.rv;
		}
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (IsObject(loc.assoc) && loc.assoc.key() == arguments.keys)
			{
				loc.rv = loc.i;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$hasManyFormValue" returntype="string" access="public" output="false">
	<cfargument name="objectName" type="string" required="true">
	<cfargument name="association" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="keys" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		loc.object = $getObject(arguments.objectName);
		if (!StructKeyExists(loc.object, arguments.association) || !IsArray(loc.object[arguments.association]))
		{
			return loc.rv;
		}
		if (!Len(arguments.keys))
		{
			return loc.rv;
		}
		loc.iEnd = ArrayLen(loc.object[arguments.association]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.assoc = loc.object[arguments.association][loc.i];
			if (isObject(loc.assoc) && loc.assoc.key() == arguments.keys && StructKeyExists(loc.assoc, arguments.property))
			{
				loc.rv = loc.assoc[arguments.property];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>