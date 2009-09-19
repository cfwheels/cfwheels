<cffunction name="afterNew" returntype="void" access="public" output="false" hint="Register method(s) that should be called after a new object has been initialized (usually done with the new method).">
	<cfargument name="methods" type="string" required="false" default="" hint="Method name or list of method names (can also be called with the `method` argument)">
	<cfset $registerCallback(type="afterNew", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterFind" returntype="void" access="public" output="false" hint="Register method(s) that should be called after an existing object has been initialized (usually done with the findByKey or findOne method).">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterFind", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterInitialization" returntype="void" access="public" output="false" hint="Register method(s) that should be called after an object has been initialized.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterInitialization", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidation" returntype="void" access="public" output="false" hint="Register method(s) that should be called before an object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is validated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is saved.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is created.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is updated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is created.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is updated.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is saved.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is deleted.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="beforeDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is deleted.">
	<cfargument name="methods" type="string" required="false" default="" hint="See `afterNew`">
	<cfset $registerCallback(type="afterDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "method") && !Len(arguments.methods))
			arguments.methods = arguments.method;
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, loc.i));
	</cfscript>
</cffunction>

<cffunction name="$callback" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="collection" type="any" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		loc.iEnd = ArrayLen(variables.wheels.class.callbacks[arguments.type]);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (arguments.type == "afterFind" && IsQuery(arguments.collection))
			{
				loc.jEnd = arguments.collection.recordCount;
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.args = {};
					loc.kEnd = ListLen(arguments.collection.columnList);
					for (loc.k=1; loc.k <= loc.kEnd; loc.k++)
					{
						loc.kItem = ListGetAt(arguments.collection.columnList, loc.k);
						loc.args[loc.kItem] = arguments.collection[loc.kItem][loc.j];
					}
					loc.returnValue = $invoke(method=variables.wheels.class.callbacks[arguments.type][loc.i], argumentCollection=loc.args);
					if (StructKeyExists(loc, "returnValue"))
					{
						if (IsStruct(loc.returnValue))
						{
							for (loc.key in loc.returnValue)
							{
								if (!ListFindNoCase(arguments.collection.columnList, loc.key))
									QueryAddColumn(arguments.collection, loc.key, ArrayNew(1));
								arguments.collection[loc.key][loc.j] = loc.returnValue[loc.key];
							}
							loc.returnValue = true;
						}
						if (!loc.returnValue)
							break;
					}
				}
			}
			else
			{
				loc.returnValue = $invoke(method=variables.wheels.class.callbacks[arguments.type][loc.i]);
			}
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