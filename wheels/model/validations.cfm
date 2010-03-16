<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<!--- high level validation helpers --->

<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property also has an identical confirmation value (common when having a user type in their email address, choosing a password etc). The confirmation value only exists temporarily and never gets saved to the database. By convention the confirmation property has to be named the same as the property with ""Confirmation"" appended at the end. Using the password example, to confirm our `password` property we would create a property called `passwordConfirmation`."
	examples=
	'
		<!--- Make sure that the user has to confirm their password correctly the first time they register (usually done by typing it again in a second form field) --->
		<cfset validatesConfirmationOf(property="password", when="onCreate", message="Please confirm your chosen password properly!")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="Name of property or list of property names to validate against (can also be called with the `property` argument).">
	<cfargument name="message" type="string" required="false" hint="Supply a custom error message here to override the built-in one.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation will occur on both create and update, i.e. `onSave`).">
	<cfargument name="if" type="string" required="false" default="" hint="String expression to be evaluated that decides if validation will be run (if the expression returns `true` validation will run).">
	<cfargument name="unless" type="string" required="false" default="" hint="String expression to be evaluated that decides if validation will be run (if the expression returns `false` validation will run).">
	<cfset $insertDefaults(name="validatesConfirmationOf", input=arguments)>
	<cfset $registerValidation(methods="$validateConfirmationOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property does not exist in the supplied list."
	examples=
	'
		<!--- Do not allow "PHP" or "Fortran" to be saved to the database as a cool language --->
		<cfset validatesExclusionOf(property="coolLanguage", list="php,fortran", message="Haha, you can not be serious, try again please.")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="list" type="string" required="true" hint="Single value or list of values that should not be allowed.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="If set to `true`, validation will be skipped if the property value is an empty string or doesn't exist at all.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfscript>
		$insertDefaults(name="validatesExclusionOf", input=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validateExclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesFormatOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is formatted correctly by matching it against a regular expression using the `regEx` argument and/or against a built-in CFML validation type (`creditcard`, `date`, `email` etc) using the `type` argument."
	examples=
	'
		<!--- Make sure that the user has entered a correct credit card --->
		<cfset validatesFormatOf(property="cc", type="creditcard")>

		<!--- Make sure that the user has entered an email address ending with the `.se` domain when the `ipCheck` methods returns `true` and it''s not Sunday, also supply a custom error message that overrides the Wheels default one --->
		<cfset validatesFormatOf(property="email", regEx="^.*@.*\.se$", if="ipCheck()", unless="DayOfWeek() IS 1" message="Sorry, you must have a Swedish email address to use this website")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="regEx" type="string" required="false" default="" hint="Regular expression to verify against.">
	<cfargument name="type" type="string" required="false" default="" hint="One of the following types to verify against: `creditcard`, `date`, `email`, `eurodate`, `guid`, `social_security_number`, `ssn`, `telephone`, `time`, `URL`, `USdate`, `UUID`, `variableName`, `zipcode` (will be passed through to CFML's `isValid` function).">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="See documentation for @validatesExclusionOf.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfscript>
		$insertDefaults(name="validatesFormatOf", input=arguments);
		if (application.wheels.showErrorInformation)
		{
			if (Len(arguments.type) && !ListFindNoCase("creditcard,date,email,eurodate,guid,social_security_number,ssn,telephone,time,URL,USdate,UUID,variableName,zipcode", arguments.type))
				$throw(type="Wheels.IncorrectArguments", message="The `#arguments.type#` type is not supported.", extendedInfo="Use one of the supported types: `creditcard`, `date`, `email`, `eurodate`, `guid`, `social_security_number`, `ssn`, `telephone`, `time`, `URL`, `USdate`, `UUID`, `variableName`, `zipcode`");
		}
		$registerValidation(methods="$validateFormatOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property exists in the supplied list."
	examples=
	'
		<!--- Make sure that the user selects either "Wheels" or "Rails" as their framework --->
		<cfset validatesInclusionOf(property="frameworkOfChoice", list="wheels,rails", message="Please try again and this time select a decent framework.")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="list" type="string" required="true" hint="List of allowed values.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="See documentation for @validatesExclusionOf.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfscript>
		$insertDefaults(name="validatesInclusionOf", input=arguments);
		arguments.list = $listClean(arguments.list);
		$registerValidation(methods="$validateInclusionOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesLengthOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property matches the length requirements supplied. Use the `exactly`, `maximum`, `minimum` and `within` arguments to specify the length requirements."
	examples=
	'
		<!--- Make sure that the `firstname` and `lastName` properties are not more than 50 characters and use square brackets to dynamically insert the property name when the error message is displayed to the user (the `firstName` property will be displayed as "first name") --->
		<cfset validatesLengthOf(properties="firstName,lastName", maximum=50, message="Please shorten your [property] please, 50 characters is the maximum length allowed.")>

		<!--- Make sure that the `password` property is between 4 and 15 characters --->
		<cfset validatesLengthOf(property="password", within="4,20", message="The password length has to be between 4 and 20 characters.")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesNumericalityOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="See documentation for @validatesExclusionOf.">
	<cfargument name="exactly" type="numeric" required="false" hint="The exact length that the property value has to be.">
	<cfargument name="maximum" type="numeric" required="false" hint="The maximum length that the property value has to be.">
	<cfargument name="minimum" type="numeric" required="false" hint="The minimum length that the property value has to be.">
	<cfargument name="within" type="string" required="false" hint="A list of two values (minimum and maximum) that the length of the property value has to fall within.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfscript>
		$insertDefaults(name="validatesLengthOf", input=arguments);
		if (Len(arguments.within))
			arguments.within = $listClean(list=arguments.within, returnAs="array");
		$registerValidation(methods="$validateLengthOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is numeric."
	examples=
	'
		<!--- Make sure that the score is a number with no decimals but only when a score is supplied (setting `allowBlank` to `true` means that objects are allowed to be saved without scores, typically resulting in `NULL` values being inserted in the database table) --->
		<cfset validatesNumericalityOf(property="score", onlyInteger=true, allowBlank=true, message="Please enter a correct score.")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesPresenceOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="See documentation for @validatesExclusionOf.">
	<cfargument name="onlyInteger" type="boolean" required="false" hint="Specifies whether the property value has to be an integer.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfset $insertDefaults(name="validatesNumericalityOf", input=arguments)>
	<cfset $registerValidation(methods="$validateNumericalityOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false" hint="Validates that the specified property exists and that its value is not blank."
	examples=
	'
		<!--- Make sure that the user data can not be saved to the database without the `emailAddress` property (it has to exist and not be an empty string) --->
		<cfset validatesPresenceOf("emailAddress")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesUniquenessOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfset $insertDefaults(name="validatesPresenceOf", input=arguments)>
	<cfset $registerValidation(methods="$validatePresenceOf", argumentCollection=arguments)>
</cffunction>

<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is unique in the database table. Useful for ensuring that two users can't sign up to a website with identical screen names for example. When a new record is created a check is made to make sure that no record already exists in the database with the given value for the specified property. When the record is updated the same check is made but disregarding the record itself."
	examples=
	'
		<!--- Make sure that two users with the same screen name won''t ever exist in the database (although to be 100% safe you should consider using database locking as well) --->
		<cfset validatesUniquenessOf(property="username", message="Sorry, that username is already taken.")>

		<!--- Same as above but allow identical user names as long as they belong to a different account --->
		<cfset validatesUniquenessOf(property="username", scope="accountId")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf">
	<cfargument name="properties" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="message" type="string" required="false" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="See documentation for @validatesExclusionOf.">
	<cfargument name="scope" type="string" required="false" default="" hint="One or more properties by which to limit the scope of the uniqueness constraint.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfscript>
		$insertDefaults(name="validatesUniquenessOf", input=arguments);
		arguments.scope = $listClean(arguments.scope);
		$registerValidation(methods="$validateUniquenessOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- low level validation --->

<cffunction name="validate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called to validate objects before they are saved."
	examples=
	'
		<cffunction name="init">
			<!--- Register the `check` method below to be called to validate objects before they are saved --->
			<cfset validate("check")>
		</cffunction>

		<cffunction name="check">
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validateOnCreate,validateOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="Method name or list of method names to call (can also be called with the `method` argument).">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfset $registerValidation(when="onSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="validateOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called to validate new objects before they are inserted."
	examples=
	'
		<cffunction name="init">
			<!--- Register the `check` method below to be called to validate new objects before they are inserted --->
			<cfset validateOnCreate("check")>
		</cffunction>

		<cffunction name="check">
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validate,validateOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @validate.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfset $registerValidation(when="onCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called to validate existing objects before they are updated."
	examples=
	'
		<cffunction name="init">
			<!--- Register the `check` method below to be called to validate existing objects before they are updated --->
			<cfset validateOnUpdate("check")>
		</cffunction>

		<cffunction name="check">
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validate,validateOnCreate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @validate.">
	<cfargument name="if" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="See documentation for @validatesConfirmationOf.">
	<cfset $registerValidation(when="onUpdate", argumentCollection=arguments)>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="valid" returntype="boolean" access="public" output="false" hint="Runs the validation on the object and returns `true` if it passes it. Wheels will run the validation process automatically whenever an object is saved to the database but sometimes it's useful to be able to run this method to see if the object is valid without saving it to the database."
	examples=
	'
		<!--- Check if a user is valid before proceeding with execution --->
		<cfif user.valid()>
			<!--- Do something here --->
		</cfif>
	'
	categories="model-object,errors" chapters="object-validation" functions="">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		clearErrors();
		if ($callback("beforeValidation"))
		{
			if (isNew())
			{
				if ($callback("beforeValidationOnCreate") && $validate("onSave") && $validate("onCreate") && $callback("afterValidation") && $callback("afterValidationOnCreate"))
					loc.returnValue = true;
			}
			else
			{
				if ($callback("beforeValidationOnUpdate") && $validate("onSave") && $validate("onUpdate") && $callback("afterValidation") && $callback("afterValidationOnUpdate"))
					loc.returnValue = true;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$registerValidation" returntype="void" access="public" output="false" hint="Called from the high level validation helpers to register the validation in the class struct of the model.">
	<cfargument name="when" type="string" required="true">
	<cfscript>
		var loc = {};

		// combine `method`/`methods` and `property`/`properties` into one variables for easier processing below
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

		if (application.wheels.showErrorInformation)
		{
			if (StructKeyExists(arguments, "properties"))
			{
				if (!Len(arguments.properties))
					$throw(type="Wheels.IncorrectArguments", message="The `property` or `properties` argument is required but was not passed in.", extendedInfo="Please pass in the names of the properties you want to validate. Use either the `property` argument (for a single property) or the `properties` argument (for a list of properties) to do this.");
			}
		}

		// loop through all methods and properties and add info for each to the `class` struct
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// only loop once by default (will be used on the lower level validation helpers that do not take arguments: `validate`, `validateOnCreate` and `validateOnUpdate`)
			loc.jEnd = 1;
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

<cffunction name="$validationErrorMessage" returntype="string" access="public" output="false" hint="Creates nicer looking error text by humanizing the property name and capitalizing it when appropriate.">
	<cfargument name="message" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var returnValue = "";

		// turn property names into lower cased words
		returnValue = Replace(arguments.message, "[property]", LCase(humanize(arguments.property)), "all");

		// capitalize the first word in the property name if it comes first in the sentence
		if (Left(arguments.message, 10) == "[property]")
			returnValue = capitalize(returnValue);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$validate" returntype="boolean" access="public" output="false" hint="Runs all the validation methods setup on the object and adds errors as it finds them. Returns `true` if no errors were added, `false` otherwise.">
	<cfargument name="type" type="string" required="true">
	<cfargument name="execute" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};

		// don't run any validations when we want to skip
		if (!arguments.execute)
			return true;

		// loop through all validations for passed in type (`onSave`, `onCreate` etc) that has been set on this model object
		loc.iEnd = ArrayLen(variables.wheels.class.validations[arguments.type]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.thisValidation = variables.wheels.class.validations[arguments.type][loc.i];
			if ($evaluateValidationCondition(argumentCollection=loc.thisValidation.args))
			{
				if (loc.thisValidation.method == "$validatePresenceOf")
				{
					// if the property does not exist or if it's blank we add an error on the object (for all other validation types we call corresponding methods below instead)
					if (!StructKeyExists(this, loc.thisValidation.args.property) || !Len(this[loc.thisValidation.args.property]))
						addError(property=loc.thisValidation.args.property, message=loc.thisValidation.args.message);
				}
				else
				{
					// if the validation set does not allow blank values we can set an error right away, otherwise we call a method to run the actual check
					if (StructKeyExists(loc.thisValidation.args, "property") && StructKeyExists(loc.thisValidation.args, "allowBlank") && !loc.thisValidation.args.allowBlank && (!StructKeyExists(this, loc.thisValidation.args.property) || !Len(this[loc.thisValidation.args.property])))
						addError(property=loc.thisValidation.args.property, message=loc.thisValidation.args.message);
					else if (!StructKeyExists(loc.thisValidation.args, "property") || (StructKeyExists(this, loc.thisValidation.args.property) && Len(this[loc.thisValidation.args.property])))
						$invoke(method=loc.thisValidation.method, argumentCollection=loc.thisValidation.args);
				}
			}
		}

		// now that we have run all the validation checks we can return `true` if no errors exist on the object, `false` otherwise
		loc.returnValue = !hasErrors();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$evaluateValidationCondition" returntype="boolean" access="public" output="false" hint="Evaluates the condition to determine if the validation should be executed.">
	<cfscript>
		var returnValue = false;
		// proceed with validation when `if` has been supplied and it evaluates to `true` or when `unless` has been supplied and it evaluates to `false`
		// if both `if` and `unless` have been supplied though, they both need to be evaluated correctly (`true`/`false` that is) for validation to proceed
		if ((!StructKeyExists(arguments, "if") || !Len(arguments.if) || Evaluate(arguments.if)) && (!StructKeyExists(arguments, "unless") || !Len(arguments.unless) || !Evaluate(arguments.unless)))
			returnValue = true;
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$validateConfirmationOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesConfirmationOf method.">
	<cfscript>
		var loc = {};
		loc.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, loc.virtualConfirmProperty) && this[arguments.property] != this[loc.virtualConfirmProperty])
			addError(property=loc.virtualConfirmProperty, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateExclusionOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesExclusionOf method.">
	<cfscript>
		if (ListFindNoCase(arguments.list, this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateFormatOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesFormatOf method.">
	<cfscript>
		if ((Len(arguments.regEx) && !REFindNoCase(arguments.regEx, this[arguments.property])) || (Len(arguments.type) && !IsValid(arguments.type, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateInclusionOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesInclusionOf method.">
	<cfscript>
		if (!ListFindNoCase(arguments.list, this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateLengthOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesLengthOf method.">
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

<cffunction name="$validateNumericalityOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesNumericalityOf method.">
	<cfscript>
		if (!IsNumeric(this[arguments.property]))
			addError(property=arguments.property, message=arguments.message);
		else if (arguments.onlyInteger && Round(this[arguments.property]) != this[arguments.property])
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateUniquenessOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesUniquenessOf method.">
	<cfscript>
		var loc = {};

		// create the WHERE clause to be used in the query that checks if an identical value already exists
		// wrap value in single quotes unless it's numeric
		// example: "userName='Joe'"
		loc.where = arguments.property & "=";
		if (!IsNumeric(this[arguments.property]))
			loc.where = loc.where & "'";
		loc.where = loc.where & this[arguments.property];
		if (!IsNumeric(this[arguments.property]))
			loc.where = loc.where & "'";

		// add scopes to the WHERE clause if passed in, this means that checks for other properties are done in the WHERE clause as well
		// example: "userName='Joe'" becomes "userName='Joe' AND account=1" if scope is "account" for example
		if (Len(arguments.scope))
		{
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
		}

		// try to fetch existing object from the database
		loc.existingObject = findOne(where=loc.where, reload=true);

		// we add an error if an object was found in the database and the current object is either not saved yet or not the same as the one in the database
		if (IsObject(loc.existingObject) && (isNew() || loc.existingObject.key() != key($persisted=true)))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validationExists" returntype="boolean" access="public" output="false" hint="Checks to see if a validation has been created for a property.">
	<cfargument name="property" type="string" required="true">
	<cfargument name="validation" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = false;

		for (loc.when in variables.wheels.class.validations) {

			if (StructKeyExists(variables.wheels.class.validations, loc.when)) {

				loc.eventArray = variables.wheels.class.validations[loc.when];
				loc.iEnd = ArrayLen(loc.eventArray);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {

					if (loc.eventArray[loc.i].args.property == arguments.property and loc.eventArray[loc.i].method == "$#arguments.validation#") {
						loc.returnValue = true;
						break;
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="setDefaultValidations" returntype="void" access="public" output="false" hint="whether to turn default validations on or off for this model.">
	<cfargument name="value" type="boolean" required="true">
	<cfset variables.wheels.class.setDefaultValidations = arguments.value>
</cffunction>