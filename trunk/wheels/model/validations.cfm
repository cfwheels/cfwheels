<cffunction name="validatesConfirmationOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesConfirmationOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			$registerValidation(arguments.when, "$validateConfirmationOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesExclusionOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="list" type="string" required="true">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.args = {};
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesExclusionOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.list = arguments.list;
			$registerValidation(arguments.when, "$validateExclusionOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesFormatOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="regEx" type="string" required="true">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesFormatOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.regEx = arguments.regEx;
			$registerValidation(arguments.when, "$validateFormatOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesInclusionOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="list" type="string" required="true">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.args = {};
		arguments.list = Replace(arguments.list, ", ", ",", "all");
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesInclusionOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.list = arguments.list;
			$registerValidation(arguments.when, "$validateInclusionOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesLengthOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="exactly" type="numeric" required="false" default=0>
	<cfargument name="maximum" type="numeric" required="false" default=0>
	<cfargument name="minimum" type="numeric" required="false" default=0>
	<cfargument name="within" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesLengthOf.message;
		loc.iEnd = ListLen(arguments.property);
		if (Len(arguments.within))
			arguments.within = ListToArray(Replace(arguments.within, ", ", ",", "all"));
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.exactly = arguments.exactly;
			loc.args.maximum = arguments.maximum;
			loc.args.minimum = arguments.minimum;
			loc.args.within = arguments.within;
			$registerValidation(arguments.when, "$validateLengthOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesNumericalityOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="onlyInteger" type="boolean" required="false" default="false">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfargument name="allowBlank" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesNumericalityOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.allowBlank = arguments.allowBlank;
			loc.args.onlyInteger = arguments.onlyInteger;
			$registerValidation(arguments.when, "$validateNumericalityOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesPresenceOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesPresenceOf.message;
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			$registerValidation(arguments.when, "$validatePresenceOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validatesUniquenessOf" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="scope" type="string" required="false" default="">
	<cfargument name="message" type="string" required="false" default="">
	<cfargument name="when" type="string" required="false" default="onSave">
	<cfscript>
		var loc = {};
		loc.args = {};
		if (Len(arguments.message))
			loc.genericMessage = arguments.message;
		else
			loc.genericMessage = application.settings.validatesUniquenessOf.message;
		arguments.scope = Replace(arguments.scope, ", ", ",", "all");
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.args.property = Trim(ListGetAt(arguments.property, loc.i));
			loc.args.message = Replace(loc.genericMessage, "[property]", loc.args.property);
			loc.args.scope = arguments.scope;
			$registerValidation(arguments.when, "$validateUniquenessOf", Duplicate(loc.args));
		}
	</cfscript>
</cffunction>

<cffunction name="validate" returntype="void" access="public" output="false" hint="Init, Register method(s) that should be called to validate objects before they are saved">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerValidation("onSave", arguments.methods)>
</cffunction>

<cffunction name="validateOnCreate" returntype="void" access="public" output="false" hint="Init, Register method(s) that should be called to validate new objects before they are inserted">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerValidation("onCreate", arguments.methods)>
</cffunction>

<cffunction name="validateOnUpdate" returntype="void" access="public" output="false" hint="Init, Register method(s) that should be called to validate existing objects before they are updated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerValidation("onUpdate", arguments.methods)>
</cffunction>

<cffunction name="$registerValidation" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
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
		for (loc.i=1; loc.i LTE ArrayLen(variables.wheels.class.validations[arguments.type]); loc.i=loc.i+1)
			$invoke(method=variables.wheels.class.validations[arguments.type][loc.i].method, argumentCollection=variables.wheels.class.validations[arguments.type][loc.i].args);
		loc.returnValue = !hasErrors();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="valid" returntype="boolean" access="public" output="false" hint="Object, Runs the validation on the object and returns 'true' if it passes it">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if ($isNew())
			if ($validate("onCreate") && $validate("onSave"))
				loc.returnValue = true;
		else
			if ($validate("onUpdate") && $validate("onSave"))
				loc.returnValue = true;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$validateConfirmationOf" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.virtualConfirmProperty = arguments.property & "Confirmation";
		if (StructKeyExists(this, loc.virtualConfirmProperty))
			if (this[arguments.property] IS NOT this[loc.virtualConfirmProperty])
				addError(property=loc.virtualConfirmProperty, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateExclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && ListFindNoCase(arguments.list, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateFormatOf" returntype="void" access="public" output="false">
	<cfscript>
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && !REFindNoCase(arguments.regEx, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateInclusionOf" returntype="void" access="public" output="false">
	<cfscript>
		if ((!arguments.allowBlank && (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))) || (StructKeyExists(this, arguments.property) && Len(this[arguments.property]) && !ListFindNoCase(arguments.list, this[arguments.property])))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>

<cffunction name="$validateLengthOf" returntype="void" access="public" output="false">
	<cfscript>
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
					if (Len(this[arguments.property]) GT arguments.maximum)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (arguments.minimum)
				{
					if (Len(this[arguments.property]) LT arguments.minimum)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (arguments.exactly)
				{
					if (Len(this[arguments.property]) IS NOT arguments.exactly)
						addError(property=arguments.property, message=arguments.message);
				}
				else if (IsArray(arguments.within) && ArrayLen(arguments.within))
				{
					if (Len(this[arguments.property]) LT arguments.within[1] || Len(this[arguments.property]) GT arguments.within[2])
						addError(property=arguments.property, message=arguments.message);
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validateNumericalityOf" returntype="void" access="public" output="false">
	<cfscript>
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
				else if (arguments.onlyInteger && Round(this[arguments.property]) IS NOT this[arguments.property])
					addError(property=arguments.property, message=arguments.message);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$validatePresenceOf" returntype="void" access="public" output="false">
	<cfscript>
		if (!StructKeyExists(this, arguments.property) || !Len(this[arguments.property]))
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
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
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
		if (exists(where=loc.where, reload=true))
			addError(property=arguments.property, message=arguments.message);
	</cfscript>
</cffunction>
