<cfscript>
	/*
	* PUBLIC MODEL INITIALIZATION METHODS
	*/

	public void function automaticValidations(required boolean value) {
		variables.wheels.class.automaticValidations = arguments.value;
	}

	public void function validate(
		string methods="",
		string condition="",
		string unless="",
		string when="onSave"
	) {
		$registerValidation(argumentCollection=arguments);
	}

	public void function validateOnCreate(
		string methods="",
		string condition="",
		string unless=""
	) {
		$registerValidation(when="onCreate", argumentCollection=arguments);
	}

	public void function validateOnUpdate(
		string methods="",
		string condition="",
		string unless=""
	) {
		$registerValidation(when="onUpdate", argumentCollection=arguments);
	}

	public void function validatesConfirmationOf(
		string properties="",
		string message,
		string when="onSave",
		string condition="",
		string unless=""
	) {
		$args(name="validatesConfirmationOf", args=arguments);
		$registerValidation(methods="$validatesConfirmationOf", argumentCollection=arguments);
	}

	public void function validatesExclusionOf(
		string properties="",
		required string list,
		string message,
		string when="onSave",
		boolean allowBlank,
		string condition="",
		string unless=""
	) {
		$args(name="validatesExclusionOf", args=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validatesExclusionOf", argumentCollection=arguments);
	}

	public void function validatesFormatOf(
		string properties="",
		string regEx="",
		string type="",
		string message,
		string when="onSave",
		boolean allowBlank,
		string condition="",
		string unless=""
	) {
		$args(name="validatesFormatOf", args=arguments);
		if (application.wheels.showErrorInformation)
		{
			if (Len(arguments.type) && !ListFindNoCase("creditcard,date,email,eurodate,guid,social_security_number,ssn,telephone,time,URL,USdate,UUID,variableName,zipcode,boolean", arguments.type))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.type#` type is not supported.", extendedInfo="Use one of the supported types: `creditcard`, `date`, `email`, `eurodate`, `guid`, `social_security_number`, `ssn`, `telephone`, `time`, `URL`, `USdate`, `UUID`, `variableName`, `zipcode`, `boolean`");
			}
		}
		$registerValidation(methods="$validatesFormatOf", argumentCollection=arguments);
	}

	public void function validatesInclusionOf(
		string properties="",
		required string list,
		string message,
		string when="onSave",
		boolean allowBlank,
		string condition="",
		string unless=""
	) {
		$args(name="validatesInclusionOf", args=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validatesInclusionOf", argumentCollection=arguments);
	}

	public void function validatesLengthOf(
		string properties="",
		string message,
		string when="onSave",
		boolean allowBlank,
		numeric exactly,
		numeric maximum,
		numeric minimum,
		string within,
		string condition="",
		string unless=""
	) {
		$args(name="validatesLengthOf", args=arguments);
		if (Len(arguments.within))
		{
			arguments.within = $listClean(list=arguments.within, returnAs="array");
		}
		$registerValidation(methods="$validatesLengthOf", argumentCollection=arguments);
	}

	public void function validatesNumericalityOf(
		string properties="",
		string message,
		string when="onSave",
		boolean allowBlank,
		boolean onlyInteger,
		string condition="",
		string unless="",
		boolean odd,
		boolean even,
		numeric greaterThan,
		numeric greaterThanOrEqualTo,
		numeric equalTo,
		numeric lessThan,
		numeric lessThanOrEqualTo
	) {
		$args(name="validatesNumericalityOf", args=arguments);
		$registerValidation(methods="$validatesNumericalityOf", argumentCollection=arguments);
	}

	public void function validatesPresenceOf(
		string properties="",
		string message,
		string when="onSave",
		string condition="",
		string unless=""
	) {
		$args(name="validatesPresenceOf", args=arguments);
		$registerValidation(methods="$validatesPresenceOf", argumentCollection=arguments);
	}

	public void function validatesUniquenessOf(
		string properties="",
		string message,
		string when="onSave",
		boolean allowBlank,
		string scope="",
		string condition="",
		string unless="",
		boolean includeSoftDeletes="true"
	) {
		$args(name="validatesUniquenessOf", args=arguments);
		arguments.scope = $listClean(arguments.scope);
		$registerValidation(methods="$validatesUniquenessOf", argumentCollection=arguments);
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/

	public boolean function valid(boolean callbacks="true") {
		local.rv = false;
		clearErrors();
		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks))
				{
					local.rv = true;
				}
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks))
				{
					local.rv = true;
				}
			}
		}
		$validateAssociations(callbacks=arguments.callbacks);
		return local.rv;
	}

	/*
	* PRIVATE METHODS
	*/

	/**
    * Called from the high level validation helpers to register the validation in the class struct of the model.
    */
	public void function $registerValidation(required string when) {

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
		local.iEnd = ListLen(arguments.methods);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			// only loop once by default (will be used on the lower level validation helpers that do not take arguments: validate, validateOnCreate and validateOnUpdate)
			local.jEnd = 1;
			if (StructKeyExists(arguments, "properties"))
			{
				local.jEnd = ListLen(arguments.properties);
			}

			for (local.j=1; local.j <= local.jEnd; local.j++)
			{
				local.validation = {};
				local.validation.method = Trim(ListGetAt(arguments.methods, local.i));
				local.validation.args = Duplicate(arguments);
				if (StructKeyExists(arguments, "properties"))
				{
					local.validation.args.property = Trim(ListGetAt(local.validation.args.properties, local.j));
				}
				StructDelete(local.validation.args, "when");
				StructDelete(local.validation.args, "methods");
				StructDelete(local.validation.args, "properties");
				ArrayAppend(variables.wheels.class.validations[arguments.when], local.validation);
			}
		}
	}

	public string function $validationErrorMessage(required string property, required string message) {
		local.rv = arguments.message;
		// evaluate the error message if it contains pound signs
		if (Find(Chr(35), local.rv))
		{
			// use a try / catch here since it will fail if a pound sign is used that's not in an expression
			try
			{
				local.rv = Evaluate(DE(local.rv));
			}
			catch (any e) {}
		}

		// loop through each argument and replace bracketed occurrence with argument value
		for (local.key in arguments)
		{
			local.key = LCase(local.key);
			local.value = arguments[local.key];
			if (StructKeyExists(local, "value") && IsSimpleValue(local.value) && Len(local.value))
			{
				if (local.key == "property")
				{
					local.value = this.$label(local.value);
				}
				local.rv = Replace(local.rv, "[[#local.key#]]", "{{#Chr(7)#}}", "all");
				local.rv = Replace(local.rv, "[#local.key#]", local.value, "all");
				local.rv = Replace(local.rv, "{{#Chr(7)#}}", "[#local.key#]", "all");
			}
		}
		return local.rv;
	}

	/**
    * Runs all the validation methods setup on the object and adds errors as it finds them. Returns `true` if no errors were added, `false` otherwise.
    */
	public boolean function $validate(required string type, boolean execute="true") {
		// don't run any validations when we want to skip
		if (!arguments.execute)
		{
			return true;
		}

		// loop over the passed in types
		local.iEnd = ListLen(arguments.type);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = ListGetAt(arguments.type, local.i);

			// loop through all validations for passed in type (onSave, onCreate etc) that has been set on this model object
			local.jEnd = ArrayLen(variables.wheels.class.validations[local.item]);
			for (local.j=1; local.j <= local.jEnd; local.j++)
			{
				local.thisValidation = variables.wheels.class.validations[local.item][local.j];
				if ($evaluateCondition(argumentCollection=local.thisValidation.args))
				{
					if (local.thisValidation.method == "$validatesPresenceOf")
					{
						// if the property does not exist or if it's blank we add an error on the object (for all other validation types we call corresponding methods below instead)
						if (!StructKeyExists(this, local.thisValidation.args.property) || (IsSimpleValue(this[local.thisValidation.args.property]) && !Len(Trim(this[local.thisValidation.args.property]))) || (IsStruct(this[local.thisValidation.args.property]) && !StructCount(this[local.thisValidation.args.property])))
						{
							addError(property=local.thisValidation.args.property, message=$validationErrorMessage(local.thisValidation.args.property, local.thisValidation.args.message));
						}
					}
					else
					{
						// if the validation set does not allow blank values we can set an error right away, otherwise we call a method to run the actual check
						if (StructKeyExists(local.thisValidation.args, "property") && StructKeyExists(local.thisValidation.args, "allowBlank") && !local.thisValidation.args.allowBlank && (!StructKeyExists(this, local.thisValidation.args.property) || (!Len(this[local.thisValidation.args.property]) && local.thisValidation.method != "$validatesUniquenessOf")))
						{
							addError(property=local.thisValidation.args.property, message=$validationErrorMessage(local.thisValidation.args.property, local.thisValidation.args.message));
						}
						else if (!StructKeyExists(local.thisValidation.args, "property") || (StructKeyExists(this, local.thisValidation.args.property) &&(Len(this[local.thisValidation.args.property]) || local.thisValidation.method == "$validatesUniquenessOf")))
						{
							$invoke(method=local.thisValidation.method, invokeArgs=local.thisValidation.args);
						}
					}
				}
			}
		}
		// now that we have run all the validation checks we can return "true" if no errors exist on the object, "false" otherwise
		return !hasErrors();
	}

	/**
    * Evaluates the condition to determine if the validation should be executed.
    */
	public boolean function $evaluateCondition() {
		local.rv = false;
		// since cf8 can't handle cfscript operators (==, != etc) inside an Evaluate() call we replace them with eq, neq etc in a try / catch
		local.evaluate = "condition,unless";
		local.iEnd = ListLen(local.evaluate);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = ListGetAt(local.evaluate, local.i);
			if (StructKeyExists(arguments, local.item) && Len(arguments[local.item]))
			{
				local.key = local.item & "Evaluated";
				try
				{
					local[local.key] = Evaluate(arguments[local.item]);
				}
				catch (any e)
				{
					arguments[local.item] = Replace(ReplaceList(arguments[local.item], "==,!=,<,<=,>,>=", " eq , neq , lt , lte , gt , gte "), "  ", " ", "all");
					local[local.key] = Evaluate(arguments[local.item]);
				}
			}
		}
		// proceed with validation when "condition" has been supplied and it evaluates to "true" or when "unless" has been supplied and it evaluates to "false"
		// if both "condition" and "unless" have been supplied though, they both need to be evaluated correctly ("true"/false" that is) for validation to proceed
		if ((!StructKeyExists(arguments, "condition") || !Len(arguments.condition) || local.conditionEvaluated) && (!StructKeyExists(arguments, "unless") || !Len(arguments.unless) || !local.unlessEvaluated))
		{
			local.rv = true;
		}
		return local.rv;
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesConfirmationOf method.
    */
	public void function $validatesConfirmationOf() {
		local.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, local.virtualConfirmProperty) && this[arguments.property] != this[local.virtualConfirmProperty])
		{
			addError(property=local.virtualConfirmProperty, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesExclusionOf method.
    */
	public void function $validatesExclusionOf() {
		if (ListFindNoCase(arguments.list, this[arguments.property]))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesFormatOf method.
    */
	public void function $validatesFormatOf() {
		if ((Len(arguments.regEx) && !REFindNoCase(arguments.regEx, this[arguments.property])) || (Len(arguments.type) && !IsValid(arguments.type, this[arguments.property])))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesInclusionOf method.
    */
	public void function $validatesInclusionOf() {
		if (!ListFindNoCase(arguments.list, this[arguments.property]))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesPresenceOf method.
    */
	public void function $validatesPresenceOf(
		required string property,
		required string message,
		struct properties=this.properties()
	) {
		// if the property does not exist or if it's blank we add an error on the object
		if (!StructKeyExists(arguments.properties, arguments.property) || (IsSimpleValue(arguments.properties[arguments.property]) && !Len(Trim(arguments.properties[arguments.property]))) || (IsStruct(arguments.properties[arguments.property]) && !StructCount(arguments.properties[arguments.property])))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesLengthOf method.
    */
	public void function $validatesLengthOf(
		required string property,
		required string message,
		required numeric exactly,
		required numeric maximum,
		required numeric minimum,
		required any within,
		struct properties=this.properties()
	) {
		local.lenValue = Len(arguments.properties[arguments.property]);

		// for within, just create minimum / maximum values
		if (IsArray(arguments.within) && ArrayLen(arguments.within) == 2)
		{
			arguments.minimum = arguments.within[1];
			arguments.maximum = arguments.within[2];
		}

		if ((arguments.maximum && local.lenValue > arguments.maximum) || (arguments.minimum && local.lenValue < arguments.minimum) || (arguments.exactly && local.lenValue != arguments.exactly))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesNumericalityOf method.
    */
	public void function $validatesNumericalityOf() {
		if (!IsNumeric(this[arguments.property]) || (arguments.onlyInteger && Round(this[arguments.property]) != this[arguments.property]) || (IsNumeric(arguments.greaterThan) && this[arguments.property] <= arguments.greaterThan) || (IsNumeric(arguments.greaterThanOrEqualTo) && this[arguments.property] < arguments.greaterThanOrEqualTo) || (IsNumeric(arguments.equalTo) && this[arguments.property] != arguments.equalTo) || (IsNumeric(arguments.lessThan) && this[arguments.property] >= arguments.lessThan) || (IsNumeric(arguments.lessThanOrEqualTo) && this[arguments.property] > arguments.lessThanOrEqualTo) || (IsBoolean(arguments.odd) && arguments.odd && !BitAnd(this[arguments.property], 1)) || (IsBoolean(arguments.even) && arguments.even && BitAnd(this[arguments.property], 1)))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	}

	/**
    * Adds an error if the object property fail to pass the validation setup in the @validatesUniquenessOf method.
    */
	public void function $validatesUniquenessOf(
		required string property,
		required string message,
		string scope="",
		struct properties="#this.properties()#",
		boolean includeSoftDeletes="true"
	) {
		if (!IsBoolean(variables.wheels.class.tableName) || variables.wheels.class.tableName)
		{
			local.where = [];

			// create the WHERE clause to be used in the query that checks if an identical value already exists
			// wrap value in single quotes unless it's numeric
			// example: "userName='Joe'"
			local.part = arguments.property & "=" & variables.wheels.class.adapter.$quoteValue(str=this[arguments.property], type=validationTypeForProperty(arguments.property));
			if (Right(local.part, 3) == "=''" && ListFindNoCase("integer,float,boolean", validationTypeForProperty(arguments.property)))
			{
				// when numeric property but blank we need to translate to IS NULL
				local.part = SpanExcluding(local.part, "=") & " IS NULL";
			}
			ArrayAppend(local.where, local.part);

			// add scopes to the WHERE clause if passed in, this means that checks for other properties are done in the WHERE clause as well
			// example: "userName='Joe'" becomes "userName='Joe' AND account=1" if scope is "account" for example
			arguments.scope = $listClean(arguments.scope);
			local.iEnd = ListLen(arguments.scope);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.item = ListGetAt(arguments.scope, local.i);
				local.part = local.item & "=" & variables.wheels.class.adapter.$quoteValue(str=this[local.item], type=validationTypeForProperty(local.item));
				if (Right(local.part, 3) == "=''" && ListFindNoCase("integer,float,boolean", validationTypeForProperty(local.item)))
				{
					// when numeric property but blank we need to translate to IS NULL
					local.part = SpanExcluding(local.part, "=") & " IS NULL";
				}
				ArrayAppend(local.where, local.part);
			}

			// try to fetch existing object from the database
			local.existingObject = findOne(select=primaryKey(), where=ArrayToList(local.where, " AND "), reload=true, includeSoftDeletes=arguments.includeSoftDeletes, callbacks=false);

			// we add an error if an object was found in the database and the current object is either not saved yet or not the same as the one in the database
			if (IsObject(local.existingObject) && (isNew() || local.existingObject.key() != key($persisted=true)))
			{
				addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
			}
		}
	}

	public boolean function $validationExists(required string property, required string validation) {
			// checks to see if a validation has been created for a property
			local.rv = false;
			for (local.key in variables.wheels.class.validations)
			{
				if (StructKeyExists(variables.wheels.class.validations, local.key))
				{
					local.eventArray = variables.wheels.class.validations[local.key];
					local.iEnd = ArrayLen(local.eventArray);
					for (local.i=1; local.i <= local.iEnd; local.i++)
					{
						if (StructKeyExists(local.eventArray[local.i].args, "property") && local.eventArray[local.i].args.property == arguments.property && local.eventArray[local.i].method == "$#arguments.validation#")
						{
							local.rv = true;
							break;
						}
					}
				}
			}
		return local.rv;
	}
</cfscript>