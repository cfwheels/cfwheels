<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="afterCreate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterFind" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterFind", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterInitialization" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterInitialization", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterNew" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterNew", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="afterValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidation" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false">
	<cfargument name="methods" type="string" required="false" default="">
	<cfset $registerCallback(type="beforeValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};

		// create this type in the array if it doesn't already exist
		if (!StructKeyExists(variables.wheels.class.callbacks,arguments.type))
		{
			variables.wheels.class.callbacks[arguments.type] = ArrayNew(1);
		}

		loc.existingCallbacks = ArrayToList(variables.wheels.class.callbacks[arguments.type]);
		if (StructKeyExists(arguments, "method"))
		{
			arguments.methods = arguments.method;
		}
		arguments.methods = $listClean(arguments.methods);
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (!ListFindNoCase(loc.existingCallbacks, ListGetAt(arguments.methods, loc.i)))
			{
				ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, loc.i));
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$clearCallbacks" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		arguments.type = $listClean(list="#arguments.type#", returnAs="array");

		// no type(s) was passed in. get all the callback types registered
		if (ArrayIsEmpty(arguments.type))
		{
			arguments.type = ListToArray(StructKeyList(variables.wheels.class.callbacks));
		}

		// loop through each callback type and clear it
		loc.iEnd = ArrayLen(arguments.type);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			variables.wheels.class.callbacks[arguments.type[loc.i]] = [];
		}
	</cfscript>
</cffunction>

<cffunction name="$callbacks" returntype="any" access="public" output="false">
	<cfargument name="type" type="string" required="false" default="">
	<cfscript>
		if (Len(arguments.type))
		{
			if (StructKeyExists(variables.wheels.class.callbacks, arguments.type))
			{
				loc.rv = variables.wheels.class.callbacks[arguments.type];
			}
			else
			{
				loc.rv = ArrayNew(1);
			}
		}
		else
		{
			loc.rv = variables.wheels.class.callbacks;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$callback" returntype="boolean" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="execute" type="boolean" required="true">
	<cfargument name="collection" type="any" required="false" default="">
	<cfscript>
		var loc = {};
		if (arguments.execute)
		{
			// get all callbacks for the type and loop through them all until the end or one of them returns false
			loc.callbacks = $callbacks(arguments.type);
			loc.iEnd = ArrayLen(loc.callbacks);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.method = loc.callbacks[loc.i];
				if (arguments.type == "afterFind")
				{
					// since this is an afterFind callback we need to handle it differently
					if (IsQuery(arguments.collection))
					{
						loc.rv = $queryCallback(method=loc.method, collection=arguments.collection);
					}
					else
					{
						loc.invokeArgs = properties();
						loc.rv = $invoke(method=loc.method, invokeArgs=loc.invokeArgs);
						if (StructKeyExists(loc, "rv") && IsStruct(loc.rv))
						{
							setProperties(loc.rv);
							StructDelete(loc, "rv");
						}
					}
				}
				else
				{
					// this is a regular callback so just call the method
					loc.rv = $invoke(method=loc.method);
				}

				// break the loop if the callback returned false
				if (StructKeyExists(loc, "rv") && IsBoolean(loc.rv) && !loc.rv)
				{
					break;
				}
			}
		}

		// return true by default (happens when no callbacks are set or none of the callbacks returned a result)
		if (!StructKeyExists(loc, "rv"))
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$queryCallback" returntype="boolean" access="public" output="false">
	<cfargument name="method" type="string" required="true">
	<cfargument name="collection" type="query" required="true">
	<cfscript>
		var loc = {};

		// we return true by default
		// will be overridden only if the callback method returns false on one of the iterations
		loc.rv = true;

		// loop over all query rows and execute the callback method for each
		loc.iEnd = arguments.collection.recordCount;
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// get the values in the current query row so that we can pass them in as arguments to the callback method
			loc.invokeArgs = {};
			loc.jEnd = ListLen(arguments.collection.columnList);
			for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
			{
				loc.item = ListGetAt(arguments.collection.columnList, loc.j);
				try
				{
					// coldfusion has a problem with empty strings in queries for bit types
					loc.invokeArgs[loc.item] = arguments.collection[loc.item][loc.i];
				}
				catch (Any e)
				{
					loc.invokeArgs[loc.item] = "";
				}
			}

			// execute the callback method
			loc.result = $invoke(method=arguments.method, invokeArgs=loc.invokeArgs);

			if (StructKeyExists(loc, "result"))
			{
				if (IsStruct(loc.result))
				{
					// the arguments struct was returned so we need to add the changed values to the query row
					for (loc.key in loc.result)
					{
						// add a new column to the query if a value was passed back for a column that did not exist originally
						if (!ListFindNoCase(arguments.collection.columnList, loc.key))
						{
							QueryAddColumn(arguments.collection, loc.key, ArrayNew(1));
						}
						arguments.collection[loc.key][loc.i] = loc.result[loc.key];
					}
				}
				else if (IsBoolean(loc.result) && !loc.result)
				{
					// break the loop and return false if the callback returned false
					loc.rv = false;
					break;
				}
			}
		}

		// update the request with a hash of the query if it changed so that we can find it with pagination
		loc.querykey = $hashedKey(arguments.collection);
		if (!StructKeyExists(request.wheels, loc.querykey))
		{
			request.wheels[loc.querykey] = variables.wheels.class.modelName;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>