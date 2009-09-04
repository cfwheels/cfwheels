<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property also has an identical confirmation value (common when having a user type in their email address, choosing a password etc). The confirmation value only exists temporarily and never gets saved to the database.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesConfirmationOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateConfirmationOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property does not exist in the supplied list.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="Name of property or list of properties to validate">
	<cfargument name="list" type="string" required="true" hint="List of values that should not be allowed">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesExclusionOf.message#" hint="Supply a custom error message here to override the built-in one">
	<cfargument name="when" type="string" required="false" default="onSave" hint="Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation it will occur on both create and update, i.e. `onSave`)">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesExclusionOf.allowBlank#" hint="If set to `true`, validation will be skipped if the value of the property is blank.">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.list = arguments.list;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateExclusionOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesFormatOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is formatted correctly by matching it against the regular expression provided.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="regEx" type="string" required="true" hint="Regular expression to verify against">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesFormatOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesFormatOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.regEx = arguments.regEx;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateFormatOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property exists in the supplied list.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="list" type="string" required="true" hint="List of allowed values">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesInclusionOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesInclusionOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.list = arguments.list;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateInclusionOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesLengthOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property matches the length requirements supplied. Only one of the `exactly`, `maximum`, `minimum` and `within` arguments can be used at a time.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesLengthOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesLengthOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="exactly" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.exactly#" hint="The exact length that the property value has to be">
	<cfargument name="maximum" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.maximum#" hint="The maximum length that the property value has to be">
	<cfargument name="minimum" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.minimum#" hint="The minimum length that the property value has to be">
	<cfargument name="within" type="string" required="false" default="#application.wheels.functions.validatesLengthOf.within#" hint="A list of two values (minimum and maximum) that the length of the property value has to fall within">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.iEnd = ListLen(arguments.property);
		if (Len(arguments.within))
			arguments.within = ListToArray(Replace(arguments.within, ", ", ",", "all"));
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.exactly = arguments.exactly;
			loc.args.maximum = arguments.maximum;
			loc.args.minimum = arguments.minimum;
			loc.args.within = arguments.within;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateLengthOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is numeric.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesNumericalityOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesNumericalityOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="onlyInteger" type="boolean" required="false" default="#application.wheels.functions.validatesNumericalityOf.onlyInteger#" hint="Specifies whether the property value has to be an integer">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.onlyInteger = arguments.onlyInteger;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateNumericalityOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false" hint="Validates that the specified property exists and that its value is not blank.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesPresenceOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validatePresenceOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is unique in the database table. Useful for ensuring that two users can't sign up to a website with identical screen names for example. When a new record is created a check is made to make sure that no record already exists in the database with the given value for the specified property. When the record is updated the same check is made but disregarding the record itself.">
	<cfargument name="property" type="string" required="false" default="#arguments.properties#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesUniquenessOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="scope" type="string" required="false" default="" hint="One or more properties by which to limit the scope of the uniqueness constraint">
	<cfargument name="properties" type="string" required="false" default="#arguments.property#" hint="See `property`">
	<cfargument name="condition" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.args = {};
		arguments.scope = Replace(arguments.scope, ", ", ",", "all");
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(arguments.message, "[property]", humanize(loc.args.property));
			loc.args.scope = arguments.scope;
			loc.args.condition = arguments.condition;
			$registerValidation(arguments.when, "$validateUniquenessOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate objects before they are saved.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerValidation("onSave", arguments.methods)>
</cffunction>

<cffunction name="validateOnCreate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate new objects before they are inserted.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerValidation("onCreate", arguments.methods)>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate existing objects before they are updated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerValidation("onUpdate", arguments.methods)>
</cffunction>

<cffunction name="valid" returntype="boolean" access="public" output="false" hint="Runs the validation on the object and returns `true` if it passes it. Wheels will run the validation process automatically whenever an object is saved to the database but sometimes it's useful to be able to run this method to see if the object is valid without saving it to the database.">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (isNew())
			if ($validate("onCreate") && $validate("onSave"))
				loc.returnValue = true;
		else
			if ($validate("onUpdate") && $validate("onSave"))
				loc.returnValue = true;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$registerValidation" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.iItem = Trim(ListGetAt(arguments.methods, loc.i));
			loc.validation = {};
			loc.validation.method = loc.iItem;
			loc.validation.args = arguments.args;
			ArrayAppend(variables.wheels.class.validations[arguments.type], loc.validation);
		}
	</cfscript>
</cffunction>

<cffunction name="$validate" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(variables.wheels.class.validations[arguments.type]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			$invoke(method=variables.wheels.class.validations[arguments.type][loc.i].method, argumentCollection=variables.wheels.class.validations[arguments.type][loc.i].args);
		loc.returnValue = !hasErrors();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$validateConfirmationOf" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		loc.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, loc.virtualConfirmProperty))
			if (this[arguments.property] != this[loc.virtualConfirmProperty])
				addError(property=loc.virtualConfirmProperty, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateExclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && ListFindNoCase(arguments.list, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateFormatOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && !REFindNoCase(arguments.regEx, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateInclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && !ListFindNoCase(arguments.list, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateLengthOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if (!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property])))
		{
			addError(property=arguments.property, message=arguments.message);
		}
		else
		{
			if (StructKeyExists(this, arguments.property) && Len(this[arguments.property]))
			{
				if (arguments.maximum)
				{
					if (Len(this[arguments.property]) > arguments.maximum)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (arguments.minimum)
				{
					if (Len(this[arguments.property]) < arguments.minimum)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (arguments.exactly)
				{
					if (Len(this[arguments.property]) != arguments.exactly)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (IsArray(arguments.within) && ArrayLen(arguments.within))
				{
					if (Len(this[arguments.property]) < arguments.within[1] || Len(this[arguments.property]) > arguments.within[2])
						addError(property=arguments.property, message=arguments.message);
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validateNumericalityOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if (!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property])))
		{
			addError(property=arguments.property, message=arguments.message);
		}
		else
		{
			if (StructKeyExists(this, arguments.property) && Len(this[arguments.property]))
			{
				if (!IsNumeric(this[arguments.property]))
					addError(property=arguments.property, message=arguments.message);
				else if (arguments.onlyInteger && Round(this[arguments.property]) != this[arguments.property])
					addError(property=arguments.property, message=arguments.message);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validatePresenceOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		if (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateUniquenessOf" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		if (!$evaluateValidationCondition(argumentCollection=arguments))
			return;
		loc.where = arguments.property & "=";
		if (!IsNumeric(this[arguments.property]))
			loc.where = loc.where & "'";
		loc.where = loc.where & this[arguments.property];
		if (!IsNumeric(this[arguments.property]))
			loc.where = loc.where & "'";
		loc.iEnd = ListLen(arguments.scope);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.where = loc.where & " AND ";
			loc.property = Trim(ListGetAt(arguments.scope, loc.i));
			loc.where = loc.where & loc.property & "=";
			if (!IsNumeric(this[loc.property]))
				loc.where = loc.where & "'";
			loc.where = loc.where & this[loc.property];
			if (!IsNumeric(this[loc.property]))
				loc.where = loc.where & "'";
		}
		loc.existingObject = findOne(where=loc.where, reload=true);
		if (IsObject(loc.existingObject) && (isNew() || loc.existingObject.key() != key($persisted=true)))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<!--- 
evaluates the condition to determine if the validation should be executed
 --->
<cffunction name="$evaluateValidationCondition">
	<cfif structkeyexists(arguments, "condition") and len(arguments.condition)>
		<cfreturn evaluate(arguments.condition)>
	</cfif>
	<cfreturn true>
</cffunction>