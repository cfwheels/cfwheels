<cffunction name="beforeValidation" returntype="void" access="public" output="false" hint="Register method(s) that should be called before an object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeValidation", arguments.methods)>
</cffunction>

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeValidationOnCreate", arguments.methods)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeValidationOnUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterValidation", arguments.methods)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterValidationOnCreate", arguments.methods)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is validated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterValidationOnUpdate", arguments.methods)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is saved.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeSave", arguments.methods)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is created.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeCreate", arguments.methods)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is updated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is created.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterCreate", arguments.methods)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is updated.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is saved.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterSave", arguments.methods)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is deleted.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("beforeDelete", arguments.methods)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is deleted.">
	<cfargument name="method" type="string" required="false" default="#arguments.methods#" hint="Method name or list of method names">
	<cfargument name="methods" type="string" required="false" default="#arguments.method#" hint="See `method`">
	<cfset $registerCallback("afterDelete", arguments.methods)>
</cffunction>

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, loc.i));
	</cfscript>
</cffunction>

<cffunction name="$callback" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		loc.iEnd = ArrayLen(variables.wheels.class.callbacks[arguments.type]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.returnValue = $invoke(method=variables.wheels.class.callbacks[arguments.type][loc.i]);
			if (!StructKeyExists(loc, "returnValue"))
			{
				loc.returnValue = true;
			}
			else if (!loc.returnValue)
			{
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>