<cffunction name="addError" returntype="void" access="public" output="false" hint="Adds an error on the specific property.">
	<cfargument name="property" type="string" required="true" hint="Name of property">
	<cfargument name="message" type="string" required="true" hint="Message relating to the error">
	<cfargument name="name" type="string" required="false" default="" hint="Name to identify the error by">
	<cfscript>
		ArrayAppend(variables.wheels.errors, arguments);
	</cfscript>
</cffunction>

<cffunction name="addErrorToBase" returntype="void" access="public" output="false" hint="Adds an error on the object as a whole (not related to any specific property).">
	<cfargument name="message" type="string" required="true" hint="Message relating to the error">
	<cfargument name="name" type="string" required="false" default="" hint="Name to identify the error by">
	<cfscript>
		arguments.property = "";
		addError(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="hasErrors" returntype="boolean" access="public" output="false" hint="Returns 'true' if the object, property or name has any errors.">
	<cfargument name="property" type="string" required="false" default="" hint="Name of property">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = {};
		if (errorCount(argumentCollection=arguments) > 0)
			loc.returnValue = true;
		else
			loc.returnValue = false;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="clearErrors" returntype="void" access="public" output="false" hint="Clear out all errors for the object, property or name">
	<cfargument name="property" type="string" required="false" default="" hint="Name of property">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = {};
		if(!len(arguments.property) && !len(arguments.name))
			ArrayClear(variables.wheels.errors);
		else
		{
			loc.iEnd = ArrayLen(variables.wheels.errors);
			for (loc.i=loc.iEnd; loc.i >= 1; loc.i--)
				if (variables.wheels.errors[loc.i].property == arguments.property && (variables.wheels.errors[loc.i].name == arguments.name))
					ArrayDeleteAt(variables.wheels.errors, loc.i);
		}
	</cfscript>
</cffunction>

<cffunction name="errorCount" returntype="numeric" access="public" output="false" hint="Returns the number of errors this object, property or name has associated with it.">
	<cfargument name="property" type="string" required="false" default="" hint="Name of property">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = {};
		if(!len(arguments.property) && !len(arguments.name))
			loc.returnValue = ArrayLen(variables.wheels.errors);
		else
			loc.returnValue = ArrayLen(errorsOn(argumentCollection=arguments));
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorsOn" returntype="array" access="public" output="false" hint="Returns an array of all errors associated with the supplied property (and name when passed in).">
	<cfargument name="property" type="string" required="true" hint="Name of property">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = {};
		loc.returnValue = [];
		loc.iEnd = ArrayLen(variables.wheels.errors);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			if (variables.wheels.errors[loc.i].property == arguments.property && (variables.wheels.errors[loc.i].name == arguments.name))
				ArrayAppend(loc.returnValue, variables.wheels.errors[loc.i]);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorsOnBase" returntype="array" access="public" output="false" hint="Returns an array of all errors associated with the object as a whole (not related to any specific property).">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = {};
		arguments.property = "";
		loc.returnValue = errorsOn(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="allErrors" returntype="array" access="public" output="false" hint="Returns an array of all errors on the object.">
	<cfscript>
		var loc = {};
		loc.returnValue = variables.wheels.errors;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
