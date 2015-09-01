<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="addError" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		ArrayAppend(variables.wheels.errors, arguments);
	</cfscript>
</cffunction>

<cffunction name="addErrorToBase" returntype="void" access="public" output="false">
	<cfargument name="message" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		arguments.property = "";
		addError(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="allErrors" returntype="array" access="public" output="false">
	<cfreturn variables.wheels.errors>
</cffunction>

<cffunction name="clearErrors" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (!Len(arguments.property) && !Len(arguments.name))
		{
			ArrayClear(variables.wheels.errors);
		}
		else
		{
			loc.iEnd = ArrayLen(variables.wheels.errors);
			for (loc.i=loc.iEnd; loc.i >= 1; loc.i--)
			{
				if (variables.wheels.errors[loc.i].property == arguments.property && (variables.wheels.errors[loc.i].name == arguments.name))
				{
					ArrayDeleteAt(variables.wheels.errors, loc.i);
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="errorCount" returntype="numeric" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (!Len(arguments.property) && !Len(arguments.name))
		{
			loc.rv = ArrayLen(variables.wheels.errors);
		}
		else
		{
			loc.rv = ArrayLen(errorsOn(argumentCollection=arguments));
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="errorsOn" returntype="array" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.rv = [];
		loc.iEnd = ArrayLen(variables.wheels.errors);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (variables.wheels.errors[loc.i].property == arguments.property && (variables.wheels.errors[loc.i].name == arguments.name))
			{
				ArrayAppend(loc.rv, variables.wheels.errors[loc.i]);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="errorsOnBase" returntype="array" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		arguments.property = "";
		loc.rv = errorsOn(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hasErrors" returntype="boolean" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="">
	<cfargument name="name" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (errorCount(argumentCollection=arguments) > 0)
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>