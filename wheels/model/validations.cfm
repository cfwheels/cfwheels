<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property also has an identical confirmation value (common when having a user type in their email address, choosing a password etc). The confirmation value only exists temporarily and never gets saved to the database.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesConfirmationOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(methods="$validateConfirmationOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property does not exist in the supplied list.">
	<cfargument name="properties" type="string" required="false" default="" hint="Name of property or list of properties to validate (can also be called with the `property` argument)">
	<cfargument name="list" type="string" required="true" hint="List of values that should not be allowed">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesExclusionOf.message#" hint="Supply a custom error message here to override the built-in one">
	<cfargument name="when" type="string" required="false" default="onSave" hint="Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation it will occur on both create and update, i.e. `onSave`)">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesExclusionOf.allowBlank#" hint="If set to `true`, validation will be skipped if the value of the property is blank.">
	<cfargument name="if" type="string" required="false" default="" hint="Name of a method or a string to be evaluated that decides if validation will be run (if string/method returns `true` validation will run)">
	<cfargument name="unless" type="string" required="false" default="" hint="Name of a method or a string to be evaluated that decides if validation will be run (if string/method returns `false` validation will run)">
	<cfscript>
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		$registerValidation(methods="$validateExclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesFormatOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is formatted correctly by matching it against the regular expression provided.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="regEx" type="string" required="false" default="" hint="Regular expression to verify against">
	<cfargument name="type" type="string" required="false" default="" hint="One of the following types to test against: creditcard, date, email, eurodate, guid, social_security_number, ssn, telephone, time, URL, USdate, UUID, zipcode (will be passed through to CFML's `isValid` function)">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesFormatOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesFormatOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfscript>
		if (application.wheels.environment != "production")
		{
			if (Len(arguments.type) && !ListFindNoCase("creditcard,date,email,eurodate,guid,social_security_number,ssn,telephone,time,URL,USdate,UUID,zipcode", arguments.type))
				$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The `#arguments.type#` type is not supported. Supported types are: creditcard, date, email, eurodate, guid, social_security_number, ssn, telephone, time, URL, USdate, UUID, zipcode");
		}
		$registerValidation(methods="$validateFormatOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property exists in the supplied list.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="list" type="string" required="true" hint="List of allowed values">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesInclusionOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesInclusionOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfscript>
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		$registerValidation(methods="$validateInclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesLengthOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property matches the length requirements supplied. Only one of the `exactly`, `maximum`, `minimum` and `within` arguments can be used at a time.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesLengthOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesLengthOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="exactly" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.exactly#" hint="The exact length that the property value has to be">
	<cfargument name="maximum" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.maximum#" hint="The maximum length that the property value has to be">
	<cfargument name="minimum" type="numeric" required="false" default="#application.wheels.functions.validatesLengthOf.minimum#" hint="The minimum length that the property value has to be">
	<cfargument name="within" type="string" required="false" default="#application.wheels.functions.validatesLengthOf.within#" hint="A list of two values (minimum and maximum) that the length of the property value has to fall within">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfscript>
		if (Len(arguments.within))
			arguments.within = ListToArray(Replace(arguments.within, ", ", ",", "all"));
		$registerValidation(methods="$validateLengthOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is numeric.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesNumericalityOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesNumericalityOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="onlyInteger" type="boolean" required="false" default="#application.wheels.functions.validatesNumericalityOf.onlyInteger#" hint="Specifies whether the property value has to be an integer">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(methods="$validateNumericalityOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false" hint="Validates that the specified property exists and that its value is not blank.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesPresenceOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(methods="$validatePresenceOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is unique in the database table. Useful for ensuring that two users can't sign up to a website with identical screen names for example. When a new record is created a check is made to make sure that no record already exists in the database with the given value for the specified property. When the record is updated the same check is made but disregarding the record itself.">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="message" type="string" required="false" default="#application.wheels.functions.validatesUniquenessOf.message#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="allowBlank" type="boolean" required="false" default="#application.wheels.functions.validatesUniquenessOf.allowBlank#" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="scope" type="string" required="false" default="" hint="One or more properties by which to limit the scope of the uniqueness constraint">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfscript>
		arguments.scope = Replace(arguments.scope, ", ", ",", "all");
		$registerValidation(methods="$validateUniquenessOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate objects before they are saved.">
	<cfargument name="methods" type="string" required="false" default="" hint="Method name or list of method names (can also be called with the `method` argument)">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(when="onSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="validateOnCreate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate new objects before they are inserted.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `validate`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(when="onCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false" hint="Register method(s) that should be called to validate existing objects before they are updated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `validate`">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for `validatesExclusionOf`">
	<cfset $registerValidation(when="onUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="valid" returntype="boolean" access="public" output="false" hint="Runs the validation on the object and returns `true` if it passes it. Wheels will run the validation process automatically whenever an object is saved to the database but sometimes it's useful to be able to run this method to see if the object is valid without saving it to the database.">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (isNew())
		{
			if ($validate("onCreate") && $validate("onSave"))
				loc.returnValue = true;
		}
		else
		{
			if ($validate("onUpdate") && $validate("onSave"))
				loc.returnValue = true;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$registerValidation" returntype="void" access="public" output="false">
	<cfargument name="when" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "method"))
		{
			arguments.methods = arguments.method;
			StructDelete(arguments, "method");
		}
		if (StructKeyExists(arguments, "property"))
		{
			arguments.properties = arguments.property;
			StructDelete(arguments, "property");
		}
		if (application.wheels.environment != "production")
		{
			if (StructKeyExists(arguments, "properties"))
			{
				// when using the core validations the developer needs to pass in specific properties
				if (!Len(arguments.properties))
					$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="Please pass in the names of the properties you want to validate. Use either the `property` argument (for a single property) or the `properties` argument (for a list of properties) to do this.");
			}
		}
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.jEnd = 1; // only loop once by default (will be used on the lower level validation helpers that do not take arguments; validate, validateOnCreate and validateOnUpdate)
			if (StructKeyExists(arguments, "properties"))
				loc.jEnd = ListLen(arguments.properties);
			for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
			{
				loc.validation = {};
				loc.validation.method = Trim(ListGetAt(arguments.methods, loc.i));
				loc.validation.args = Duplicate(arguments);
				if (StructKeyExists(arguments, "properties"))
				{
					loc.validation.args.property = Trim(ListGetAt(loc.validation.args.properties, loc.j));
					loc.validation.args.message = $validationErrorMessage(message=loc.validation.args.message, property=loc.validation.args.property);
				}
				StructDelete(loc.validation.args, "when");
				StructDelete(loc.validation.args, "methods");
				StructDelete(loc.validation.args, "properties");
				ArrayAppend(variables.wheels.class.validations[arguments.when], loc.validation);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validate" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(variables.wheels.class.validations[arguments.type]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.thisValidation = variables.wheels.class.validations[arguments.type][loc.i];
			if (application.wheels.environment != "production")
			{
				if (StructKeyExists(loc.thisValidation.args, "property"))
				{
					// when using the core validations the developer needs to pass in specific properties
					if (!ListFindNoCase(StructKeyList(variables.wheels.class.properties), loc.thisValidation.args.property) && !ListFindNoCase(StructKeyList(variables.wheels.class.calculatedProperties), loc.thisValidation.args.property))
						$throw(type="Wheels", message="Property Not Found", extendedInfo="The `#loc.thisValidation.args.property#` property does not exist in the `#capitalize(variables.wheels.class.name)#` model so validation can not be performed against it.");
				}
			}
			if ($evaluateValidationCondition(argumentCollection=loc.thisValidation.args))
			{
				if (loc.thisValidation.method == "$validatePresenceOf")
				{
					if (!StructKeyExists(this, loc.thisValidation.args.property) || !Len(this[loc.thisValidation.args.property]))
						addError(property=loc.thisValidation.args.property, message=loc.thisValidation.args.message);
				}
				else
				{
					if (StructKeyExists(loc.thisValidation.args, "property") && StructKeyExists(loc.thisValidation.args, "allowBlank") && !loc.thisValidation.args.allowBlank && (!StructKeyExists(this, loc.thisValidation.args.property) || !Len(this[loc.thisValidation.args.property])))
						addError(property=loc.thisValidation.args.property, message=loc.thisValidation.args.message);
					else if (!StructKeyExists(loc.thisValidation.args, "property") || (StructKeyExists(this, loc.thisValidation.args.property) && Len(this[loc.thisValidation.args.property])))
						$invoke(method=loc.thisValidation.method, argumentCollection=loc.thisValidation.args);
				}
			}
		}
		loc.returnValue = !hasErrors();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$validateConfirmationOf" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, loc.virtualConfirmProperty) && this[arguments.property] != this[loc.virtualConfirmProperty])
			addError(property=loc.virtualConfirmProperty, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateExclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if (ListFindNoCase(arguments.list, this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateFormatOf" returntype="void" access="public" output="false">
	<cfscript>
		if ((Len(arguments.regEx) && !REFindNoCase(arguments.regEx, this[arguments.property])) || (Len(arguments.type) && !IsValid(arguments.type, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateInclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!ListFindNoCase(arguments.list, this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateLengthOf" returntype="void" access="public" output="false">
	<cfscript>
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
	</cfscript>
</cffunction>

<cffunction name="$validateNumericalityOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!IsNumeric(this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
		else if (arguments.onlyInteger && Round(this[arguments.property]) != this[arguments.property])
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateUniquenessOf" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
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

<cffunction name="$evaluateValidationCondition" returntype="boolean" access="public" output="false" hint="Evaluates the condition to determine if the validation should be executed.">
	<cfscript>
		var returnValue = false;
		if ((!StructKeyExists(arguments, "if") || !Len(arguments.if) || Evaluate(arguments.if)) && (!StructKeyExists(arguments, "unless") || !Len(arguments.unless) || !Evaluate(arguments.unless)))
			returnValue = true;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$validationErrorMessage" returntype="string" access="public" output="false" hint="Creates nice looking error text.">
	<cfargument name="message" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var returnValue = "";
		returnValue = Replace(arguments.message, "[property]", LCase(humanize(arguments.property)), "all"); // turn variable names into words
		if (Left(arguments.message, 10) == "[property]")
			returnValue = capitalize(returnValue); // capitalize the first variable name word if it comes first in the sentence
	</cfscript>
	<cfreturn returnValue>
</cffunction>