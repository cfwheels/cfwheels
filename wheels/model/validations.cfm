<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<!--- high level validation helpers --->
<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false" hint="Validates that the value of the specified property is unique in the database table. Useful for ensuring that two users can't sign up to a website with identical screen names for example. When a new record is created, a check is made to make sure that no record already exists in the database with the given value for the specified property. When the record is updated, the same check is made but disregarding the record itself."
	examples=
	'
		<!--- Make sure that two users with the same screen name won''t ever exist in the database (although to be 100% safe, you should consider using database locking as well) --->
		<cfset validatesUniquenessOf(property="username", message="Sorry, that username is already taken.")>

		<!--- Same as above but allow identical user names as long as they belong to a different account --->
		<cfset validatesUniquenessOf(property="username", scope="accountId")>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validatesConfirmationOf,validatesExclusionOf,validatesFormatOf,validatesInclusionOf,validatesLengthOf,validatesNumericalityOf,validatesPresenceOf">
	<cfargument name="properties" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfargument name="message" type="string" required="false" hint="@validatesConfirmationOf.">
	<cfargument name="when" type="string" required="false" default="onSave" hint="@validatesConfirmationOf.">
	<cfargument name="allowBlank" type="boolean" required="false" hint="@validatesExclusionOf.">
	<cfargument name="scope" type="string" required="false" default="" hint="One or more properties by which to limit the scope of the uniqueness constraint.">
	<cfargument name="condition" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="true" hint="whether to take softDeletes into account when performing uniqueness check">
	<cfif StructKeyExists(arguments, "if")>
		<cfset $deprecated("The `if` argument will be deprecated in a future version of Wheels, please use the `condition` argument instead")>
		<cfset arguments.condition = arguments.if>
		<cfset StructDelete(arguments, "if")>
	</cfif>
	<cfscript>
		$args(name="validatesUniquenessOf", args=arguments);
		arguments.scope = $listClean(arguments.scope);
		$registerValidation(methods="$validatesUniquenessOf", argumentCollection=arguments);
	</cfscript>
</cffunction>

<!--- low level validation --->

<cffunction name="validateOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called to validate new objects before they are inserted."
	examples=
	'
		<cffunction name="init">
			<!--- Register the `checkPhoneNumber` method below to be called to validate new objects before they are inserted --->
			<cfset validateOnCreate("checkPhoneNumber")>
		</cffunction>

		<cffunction name="checkPhoneNumber">
			<!--- Make sure area code is `614` --->
			<cfreturn Left(this.phoneNumber, 3) is "614">
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validate,validateOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@validate.">
	<cfargument name="condition" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfif StructKeyExists(arguments, "if")>
		<cfset $deprecated("The `if` argument will be deprecated in a future version of Wheels, please use the `condition` argument instead")>
		<cfset arguments.condition = arguments.if>
		<cfset StructDelete(arguments, "if")>
	</cfif>
	<cfset $registerValidation(when="onCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called to validate existing objects before they are updated."
	examples=
	'
		<cffunction name="init">
			<!--- Register the `check` method below to be called to validate existing objects before they are updated --->
			<cfset validateOnUpdate("checkPhoneNumber")>
		</cffunction>

		<cffunction name="checkPhoneNumber">
			<!--- Make sure area code is `614` --->
			<cfreturn Left(this.phoneNumber, 3) is "614">
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="validate,validateOnCreate">
	<cfargument name="methods" type="string" required="false" default="" hint="@validate.">
	<cfargument name="condition" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfargument name="unless" type="string" required="false" default="" hint="@validatesConfirmationOf.">
	<cfif StructKeyExists(arguments, "if")>
		<cfset $deprecated("The `if` argument will be deprecated in a future version of Wheels, please use the `condition` argument instead")>
		<cfset arguments.condition = arguments.if>
		<cfset StructDelete(arguments, "if")>
	</cfif>
	<cfset $registerValidation(when="onUpdate", argumentCollection=arguments)>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="valid" returntype="boolean" access="public" output="false" hint="Runs the validation on the object and returns `true` if it passes it. Wheels will run the validation process automatically whenever an object is saved to the database, but sometimes it's useful to be able to run this method to see if the object is valid without saving it to the database."
	examples=
	'
		<!--- Check if a user is valid before proceeding with execution --->
		<cfset user = model("user").new(params.user)>
		<cfif user.valid()>
			<!--- Do something here --->
		</cfif>
	'
	categories="model-object,errors" chapters="object-validation" functions="">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="@save.">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		clearErrors();
		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks))
					loc.returnValue = true;
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate") && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks))
					loc.returnValue = true;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="automaticValidations" returntype="void" access="public" output="false" hint="Whether or not to enable default validations for this model."
	examples='
		<!--- In `models/User.cfc`, disable automatic validations. In this case, automatic validations are probably enabled globally, but we want to disable just for this model --->
		<cffunction name="init">
			<cfset automaticValidations(false)>
		</cffunction>
	'
	categories="model-initialization,validations" chapters="object-validation" functions="">
	<cfargument name="value" type="boolean" required="true">
	<cfset variables.wheels.class.automaticValidations = arguments.value>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$validatesUniquenessOf" returntype="void" access="public" output="false" hint="Adds an error if the object property fail to pass the validation setup in the @validatesUniquenessOf method.">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfargument name="scope" type="string" required="false" default="">
	<cfargument name="properties" type="struct" required="false" default="#this.properties()#">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		loc.where = [];

		// create the WHERE clause to be used in the query that checks if an identical value already exists
		// wrap value in single quotes unless it's numeric
		// example: "userName='Joe'"
		ArrayAppend(loc.where, "#arguments.property#=#$adapter().$quoteValue(str=this[arguments.property], type=validationTypeForProperty(arguments.property))#");

		// add scopes to the WHERE clause if passed in, this means that checks for other properties are done in the WHERE clause as well
		// example: "userName='Joe'" becomes "userName='Joe' AND account=1" if scope is "account" for example
		arguments.scope = $listClean(arguments.scope);
		if (Len(arguments.scope))
		{
			loc.iEnd = ListLen(arguments.scope);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.property = ListGetAt(arguments.scope, loc.i);
				ArrayAppend(loc.where, "#loc.property#=#$adapter().$quoteValue(str=this[loc.property], type=validationTypeForProperty(loc.property))#");
			}
		}

		// try to fetch existing object from the database
		loc.existingObject = findOne(select=primaryKey(),where=ArrayToList(loc.where, " AND "), reload=true, includeSoftDeletes=arguments.includeSoftDeletes);

		// we add an error if an object was found in the database and the current object is either not saved yet or not the same as the one in the database
		if (IsObject(loc.existingObject) && (isNew() || loc.existingObject.key() != key($persisted=true)))
		{
			addError(property=arguments.property, message=$validationErrorMessage(argumentCollection=arguments));
		}
	</cfscript>
</cffunction>
