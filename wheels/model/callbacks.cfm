<cffunction name="afterNew" returntype="void" access="public" output="false"
	hint="Register method(s) that should be called after a new object has been initialized (usually done with the @new method)."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterNew("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="Method name or list of method names (can also be called with the `method` argument).">
	<cfset $registerCallback(type="afterNew", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterFind" returntype="void" access="public" output="false"
	hint="Register method(s) that should be called after an existing object has been initialized (usually done with the findByKey or findOne method)."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterFind("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterFind", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterInitialization" returntype="void" access="public" output="false"
	hint="Register method(s) that should be called after an object has been initialized."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterInitialization("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterInitialization", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidation" returntype="void" access="public" output="false"
	hint="Register method(s) that should be called before an object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidation("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before a new object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidationOnCreate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before an existing object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidationOnUpdate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after an object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidation("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after a new object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidationOnCreate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after an existing object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidationOnUpdate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before an object is saved."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeSave("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before a new object is created."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeCreate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before an existing object is updated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeUpdate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterCreate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after a new object is created."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterCreate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after an existing object is updated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterUpdate("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after an object is saved."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterSave("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called before an object is deleted."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeDelete("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="beforeDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false"
	hint="Registers method(s) that should be called after an object is deleted."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterDelete("fixObj")>
	'
	categories="model-initialization" chapters="object-callbacks" functions="afterCreate,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="See documentation for @afterNew.">
	<cfset $registerCallback(type="afterDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(arguments, "method"))
			arguments.methods = arguments.method;
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			ArrayAppend(variables.wheels.class.callbacks[arguments.type], Trim(ListGetAt(arguments.methods, loc.i)));
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
			loc.method = variables.wheels.class.callbacks[arguments.type][loc.i];
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
					if (StructKeyExists(variables, loc.method) && IsCustomFunction(variables[loc.method]))
						loc.returnValue = $invoke(method=loc.method, argumentCollection=loc.args);
					else
						loc.returnValue = $invoke(componentReference=this, method=loc.method, argumentCollection=loc.args);
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
				// update the request with a hash of the query if it changed so that we can find it with pagination
				if (!StructKeyExists(request.wheels, loc.querykey))
					request.wheels[loc.querykey] = variables.wheels.class.name;
			}
			else
			{
				if (StructKeyExists(variables, loc.method) && IsCustomFunction(variables[loc.method]))
					loc.returnValue = $invoke(method=loc.method);
				else
					loc.returnValue = $invoke(componentReference=this, method=loc.method);
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