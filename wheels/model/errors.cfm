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

<cffunction name="hasErrors" returntype="boolean" access="public" output="false" hint="Returns 'true' if the object has any errors.">
	<cfscript>
		var loc = StructNew();
		if (errorCount() GT 0)
			loc.returnValue = true;
		else
			loc.returnValue = false;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="clearErrors" returntype="void" access="public" output="false" hint="Clear out all errors for the object.">
	<cfscript>
		ArrayClear(variables.wheels.errors);
	</cfscript>
</cffunction>

<cffunction name="errorCount" returntype="numeric" access="public" output="false" hint="Returns the number of errors this object has associated with it.">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = ArrayLen(variables.wheels.errors);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorsOn" returntype="array" access="public" output="false" hint="Returns an array of all errors associated with the supplied property (and name when passed in).">
	<cfargument name="property" type="string" required="true" hint="Name of property">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = [];
		for (loc.i=1; loc.i LTE ArrayLen(variables.wheels.errors); loc.i=loc.i+1)
			if (variables.wheels.errors[loc.i].property IS arguments.property and (variables.wheels.errors[loc.i].name IS arguments.name))
				ArrayAppend(loc.returnValue, variables.wheels.errors[loc.i]);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="errorsOnBase" returntype="array" access="public" output="false" hint="Returns an array of all errors associated with the object as a whole (not related to any specific property).">
	<cfargument name="name" type="string" required="false" default="" hint="Given name for the error">
	<cfscript>
		var loc = StructNew();
		arguments.property = "";
		loc.returnValue = errorsOn(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="allErrors" returntype="array" access="public" output="false" hint="Returns an array of all errors on the object.">
	<cfscript>
		var loc = StructNew();
		loc.returnValue = variables.wheels.errors;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
