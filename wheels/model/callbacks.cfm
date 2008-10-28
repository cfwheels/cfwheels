<cffunction name="beforeValidation" returntype="void" access="public" output="false" hint="Init, Register method(s) that should be called before an object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeValidation", arguments.methods)>
</cffunction>

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before a new object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeValidationOnCreate", arguments.methods)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before an existing object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeValidationOnUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after an object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterValidation", arguments.methods)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after a new object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterValidationOnCreate", arguments.methods)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after an existing object is validated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterValidationOnUpdate", arguments.methods)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before an object is saved">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeSave", arguments.methods)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before a new object is created">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeCreate", arguments.methods)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before an existing object is updated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterCreate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after a new object is created">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterCreate", arguments.methods)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after an existing object is updated">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterUpdate", arguments.methods)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after an object is saved">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterSave", arguments.methods)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called before an object is deleted">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("beforeDelete", arguments.methods)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false" hint="Init, Registers method(s) that should be called after an object is deleted">
	<cfargument name="methods" type="string" required="true" hint="Method name or list of method names">
	<cfset $registerCallback("afterDelete", arguments.methods)>
</cffunction>

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};
		for (loc.i=1; loc.i LTE ListLen(arguments.methods); loc.i=loc.i+1)
			ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, loc.i));
	</cfscript>
</cffunction>

<cffunction name="$callback" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		for (loc.i=1; loc.i LTE ArrayLen(variables.wheels.class.callbacks[arguments.type]); loc.i=loc.i+1)
		{
			loc.returnValue = $invoke(method=variables.wheels.class.callbacks[arguments.type][loc.i]);
			if (StructKeyExists(loc, "returnValue") && !loc.returnValue)
				break;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>