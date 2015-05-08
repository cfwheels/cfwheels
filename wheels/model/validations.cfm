<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="automaticValidations" returntype="void" access="public" output="false">
	<cfargument name="value" type="boolean" required="true">
	<cfscript>
		variables.wheels.class.automaticValidations = arguments.value;
	</cfscript>
</cffunction>

<cffunction name="validate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfscript>
		$registerValidation(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validateOnCreate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$registerValidation(when="onCreate", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$registerValidation(when="onUpdate", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesConfirmationOf", args=arguments);
		$registerValidation(methods="$validatesConfirmationOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="list" type="string" required="true">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesExclusionOf", args=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validatesExclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesFormatOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="regEx" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesFormatOf", args=arguments);
		if (application.wheels.showErrorInformation)
		{
			if (Len(arguments.type) && !ListFindNoCase("creditcard,date,email,eurodate,guid,social_security_number,ssn,telephone,time,URL,USdate,UUID,variableName,zipcode,boolean", arguments.type))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.type#` type is not supported.", extendedInfo="Use one of the supported types: `creditcard`, `date`, `email`, `eurodate`, `guid`, `social_security_number`, `ssn`, `telephone`, `time`, `URL`, `USdate`, `UUID`, `variableName`, `zipcode`, `boolean`");
			}
		}
		$registerValidation(methods="$validatesFormatOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="list" type="string" required="true">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesInclusionOf", args=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validatesInclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesLengthOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="exactly" type="numeric" required="false">
	<cfargument name="maximum" type="numeric" required="false">
	<cfargument name="minimum" type="numeric" required="false">
	<cfargument name="within" type="string" required="false">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesLengthOf", args=arguments);
		if (Len(arguments.within))
		{
			arguments.within = $listClean(list=arguments.within, returnAs="array");
		}
		$registerValidation(methods="$validatesLengthOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="onlyInteger" type="boolean" required="false">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfargument name="odd" type="boolean" required="false">
	<cfargument name="even" type="boolean" required="false">
	<cfargument name="greaterThan" type="numeric" required="false">
	<cfargument name="greaterThanOrEqualTo" type="numeric" required="false">
	<cfargument name="equalTo" type="numeric" required="false">
	<cfargument name="lessThan" type="numeric" required="false">
	<cfargument name="lessThanOrEqualTo" type="numeric" required="false">
	<cfscript>
		$args(name="validatesNumericalityOf", args=arguments);
		$registerValidation(methods="$validatesNumericalityOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfscript>
		$args(name="validatesPresenceOf", args=arguments);
		$registerValidation(methods="$validatesPresenceOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false">
	<cfargument name="properties" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false">
	<cfargument name="scope" type="string" required="false" default="">
	<cfargument name="condition" type="string" required="false" default="">
	<cfargument name="unless" type="string" required="false" default="">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="true">
	<cfscript>
		$args(name="validatesUniquenessOf", args=arguments);
		arguments.scope = $listClean(arguments.scope);
		$registerValidation(methods="$validatesUniquenessOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="valid" returntype="boolean" access="public" output="false">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		clearErrors();
		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($validateAssociations() && $callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks))
				{
					loc.rv = true;
				}
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks))
				{
					loc.rv = true;
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$registerValidation" returntype="void" access="public" output="false" hint="Called from the high level validation helpers to register the validation in the class struct of the model.">
	<cfargument name="when" type="string" required="true">
	<cfscript>
		var loc = {};

		// combine method / methods and property / properties into one variables for easier processing below
		// validate, validateOnCreate and validateOnUpdate do not take the properties argument however other validations do
		$combineArguments(args=arguments, combine="methods,method", required=true);
		$combineArguments(args=arguments, combine="properties,property", required=false);

		if (application.wheels.showErrorInformation)
		{
			if (StructKeyExists(arguments, "properties"))
			{
				if (!Len(arguments.properties))
				{
					$throw(type="Wheels.IncorrectArguments", message="The `property` or `properties` argument is required but was not passed in.", extendedInfo="Please pass in the names of the properties you want to validate. Use either the `property` argument (for a single property) or the `properties` argument (for a list of properties) to do this.");
				}
			}
		}

		// loop through all methods and properties and add info for each to the `class` struct
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// only loop once by default (will be used on the lower level validation helpers that do not take arguments: validate, validateOnCreate and validateOnUpdate)
			loc.jEnd = 1;
			if (StructKeyExists(arguments, "properties"))
			{
				loc.jEnd = ListLen(arguments.properties);
			}

			for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
			{
				loc.validation = {};
				loc.validation.method = Trim(ListGetAt(arguments.methods, loc.i));
				loc.validation.args = Duplicate(arguments);
				if (StructKeyExists(arguments, "properties"))
				{
					loc.validation.args.property = Trim(ListGetAt(loc.validation.args.properties, loc.j));
				}
				StructDelete(loc.validation.args, "when");
				StructDelete(loc.validation.args, "methods");
				StructDelete(loc.validation.args, "properties");
				ArrayAppend(variables.wheels.class.validations[arguments.when], loc.validation);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validationErrorMessage" returntype="string" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.message;

		// evaluate the error message if it contains pound signs
		if (Find(Chr(35), loc.rv))
		{
			// use a try / catch here since it will fail if a pound sign is used that's not in an expression
			try
			{
				loc.rv = Evaluate(DE(loc.rv));
			}
			catch (any e) {}
		}

		// loop through each argument and replace bracketed occurrence with argument value
		for (loc.key in arguments)
		{
			loc.key = LCase(loc.key);
			loc.value = arguments[loc.key];
			if (StructKeyExists(loc, "value") && IsSimpleValue(loc.value) && Len(loc.value))
			{
				if (loc.key == "property")
				{
					loc.value = this.$label(loc.value);
				}
				loc.rv = Replace(loc.rv, "[[#loc.key#]]", "{{#Chr(7)#}}", "all");
				loc.rv = Replace(loc.rv, "[#loc.key#]", LCase(loc.value), "all");
				loc.rv = Replace(loc.rv, "{{#Chr(7)#}}", "[#loc.key#]", "all");
			}
		}

		// capitalize the first word in the property name if it comes first in the sentence
		if (Left(arguments.message, 10) == "[property]")
		{
			loc.rv = capitalize(loc.rv);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$validate" returntype="boolean" access="public" output="false" hint="Runs all the validation methods setup on the object and adds errors as it finds them. Returns `true` if no errors were added, `false` otherwise.">
	<cfargument name="type" type="string" required="true">
	<cfargument name="execute" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};

		// don't run any validations when we want to skip
		if (!arguments.execute)
		{
			return true;
		}

		// loop over the passed in types
		loc.iEnd = ListLen(arguments.type);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.type, loc.i);

			// loop through all validations for passed in type (onSave, onCreate etc) that has been set on this model object
			loc.jEnd = ArrayLen(variables.wheels.class.validations[loc.item]);
			for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
			{
				loc.thisValidation = variables.wheels.class.validations[loc.item][loc.j];
				if ($evaluateCondition(argumentCollection=loc.thisValidation.args))
				{
					if (loc.thisValidation.method == "$validatesPresenceOf")
					{
						// if the property does not exist or if it's blank we add an error on the object (for all other validation types we call corresponding methods below instead)
						if (!StructKeyExists(this, loc.thisValidation.args.property) || (IsSimpleValue(this[loc.thisValidation.args.property]) && !Len(Trim(this[loc.thisValidation.args.property]))) || (IsStruct(this[loc.thisValidation.args.property]) && !StructCount(this[loc.thisValidation.args.property])))
						{
							addError(property=loc.thisValidation.args.property, message=$validationErrorMessage(loc.thisValidation.args.property, loc.thisValidation.args.message));
						}
					}
					else
					{
						// if the validation set does not allow blank values we can set an error right away, otherwise we call a method to run the actual check
						if (StructKeyExists(loc.thisValidation.args, "property") && StructKeyExists(loc.thisValidation.args, "allowBlank") && !loc.thisValidation.args.allowBlank && (!StructKeyExists(this, loc.thisValidation.args.property) || (!Len(this[loc.thisValidation.args.property]) && loc.thisValidation.method != "$validatesUniquenessOf")))
						{
							addError(property=loc.thisValidation.args.property, message=$validationErrorMessage(loc.thisValidation.args.property, loc.thisValidation.args.message));
						}
						else if (!StructKeyExists(loc.thisValidation.args, "property") || (StructKeyExists(this, loc.thisValidation.args.property) &&(Len(this[loc.thisValidation.args.property]) || loc.thisValidation.method == "$validatesUniquenessOf")))
						{
							$invoke(method=loc.thisValidation.method, invokeArgs=loc.thisValidation.args);
						}
					}
				}
			}
		}

		// now that we have run all the validation checks we can return "true" if no errors exist on the object, "false" otherwise
		loc.rv = !hasErrors();
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$evaluateCondition" returntype="boolean" access="public" output="false" hint="Evaluates the condition to determine if the validation should be executed.">
	<cfscript>
		var loc = {};
		loc.rv = false;

		// proceed with validation when "condition" has been supplied and it evaluates to "true" or when "unless" has been supplied and it evaluates to "false"
		// if both "condition" and "unless" have been supplied though, they both need to be evaluated correctly ("true"/false" that is) for validation to proceed
		if ((!StructKeyExists(arguments, "condition") || !Len(arguments.condition) || Evaluate(arguments.condition)) && (!StructKeyExists(arguments, "unless") || !Len(arguments.unless) || !Evaluate(arguments.unless)))
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$validatesConfirmationOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesConfirmationOf method.">
	<cfscript>
		var loc = {};
		loc.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, loc.virtualConfirmProperty) && this[arguments.property] != this[loc.virtualConfirmProperty])
		{
			addError(property=loc.virtualConfirmProperty, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesExclusionOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesExclusionOf method.">
	<cfscript>
		if (ListFindNoCase(arguments.list, this[arguments.property]))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesFormatOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesFormatOf method.">
	<cfscript>
		if ((Len(arguments.regEx) && !REFindNoCase(arguments.regEx, this[arguments.property])) || (Len(arguments.type) && !IsValid(arguments.type, this[arguments.property])))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesInclusionOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesInclusionOf method.">
	<cfscript>
		if (!ListFindNoCase(arguments.list, this[arguments.property]))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesPresenceOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesPresenceOf method.">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfargument name="properties" type="struct" required="false" default="#this.properties()#">
	<cfscript>
		// if the property does not exist or if it's blank we add an error on the object
		if (!StructKeyExists(arguments.properties, arguments.property) || (IsSimpleValue(arguments.properties[arguments.property]) && !Len(Trim(arguments.properties[arguments.property]))) || (IsStruct(arguments.properties[arguments.property]) && !StructCount(arguments.properties[arguments.property])))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesLengthOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesLengthOf method.">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfargument name="exactly" type="numeric" required="true">
	<cfargument name="maximum" type="numeric" required="true">
	<cfargument name="minimum" type="numeric" required="true">
	<cfargument name="within" type="any" required="true">
	<cfargument name="properties" type="struct" required="false" default="#this.properties()#">
	<cfscript>
		var loc = {};
		loc.lenValue = Len(arguments.properties[arguments.property]);

		// for within, just create minimum / maximum values
		if (IsArray(arguments.within) && ArrayLen(arguments.within) == 2)
		{
			arguments.minimum = arguments.within[1];
			arguments.maximum = arguments.within[2];
		}

		if ((arguments.maximum && loc.lenValue > arguments.maximum) || (arguments.minimum && loc.lenValue < arguments.minimum) || (arguments.exactly && loc.lenValue != arguments.exactly))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesNumericalityOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesNumericalityOf method.">
	<cfscript>
		if (!IsNumeric(this[arguments.property]) || (arguments.onlyInteger && Round(this[arguments.property]) != this[arguments.property]) || (IsNumeric(arguments.greaterThan) && this[arguments.property] <= arguments.greaterThan) || (IsNumeric(arguments.greaterThanOrEqualTo) && this[arguments.property] < arguments.greaterThanOrEqualTo) || (IsNumeric(arguments.equalTo) && this[arguments.property] != arguments.equalTo) || (IsNumeric(arguments.lessThan) && this[arguments.property] >= arguments.lessThan) || (IsNumeric(arguments.lessThanOrEqualTo) && this[arguments.property] > arguments.lessThanOrEqualTo) || (IsBoolean(arguments.odd) && arguments.odd && !BitAnd(this[arguments.property], 1)) || (IsBoolean(arguments.even) && arguments.even && BitAnd(this[arguments.property], 1)))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>

<cffunction name="$validatesUniquenessOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesUniquenessOf method.">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfargument name="scope" type="string" required="false" default="">
	<cfargument name="properties" type="struct" required="false" default="#this.properties()#">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		if (!IsBoolean(variables.wheels.class.tableName) || variables.wheels.class.tableName)
		{
			loc.where = [];

			// create the WHERE clause to be used in the query that checks if an identical value already exists
			// wrap value in single quotes unless it's numeric
			// example: "userName='Joe'"
			ArrayAppend(loc.where, "#arguments.property#=#variables.wheels.class.adapter.$quoteValue(str=this[arguments.property], type=validationTypeForProperty(arguments.property))#");

			// add scopes to the WHERE clause if passed in, this means that checks for other properties are done in the WHERE clause as well
			// example: "userName='Joe'" becomes "userName='Joe' AND account=1" if scope is "account" for example
			arguments.scope = $listClean(arguments.scope);
			loc.iEnd = ListLen(arguments.scope);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.scope, loc.i);
				ArrayAppend(loc.where, "#loc.item#=#variables.wheels.class.adapter.$quoteValue(str=this[loc.item], type=validationTypeForProperty(loc.item))#");
			}

			// try to fetch existing object from the database
			loc.existingObject = findOne(select=primaryKey(),where=ArrayToList(loc.where, " AND "), reload=true, includeSoftDeletes=arguments.includeSoftDeletes);

			// we add an error if an object was found in the database and the current object is either not saved yet or not the same as the one in the database
			if (IsObject(loc.existingObject) && (isNew() || loc.existingObject.key() != key($persisted=true)))
			{
				addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validationExists" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="validation" type="string" required="true">
	<cfscript>
		var loc = {};

		// checks to see if a validation has been created for a property
		loc.rv = false;
		for (loc.key in variables.wheels.class.validations)
		{
			if (StructKeyExists(variables.wheels.class.validations, loc.key))
			{
				loc.eventArray = variables.wheels.class.validations[loc.key];
				loc.iEnd = ArrayLen(loc.eventArray);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if (StructKeyExists(loc.eventArray[loc.i].args, "property") && loc.eventArray[loc.i].args.property == arguments.property && loc.eventArray[loc.i].method == "$#arguments.validation#")
					{
						loc.rv = true;
						break;
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>