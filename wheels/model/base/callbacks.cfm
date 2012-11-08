<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="afterNew" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object has been initialized (which is usually done with the @new method)."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterNew("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="Method name or list of method names that should be called when this callback event occurs in an object's life cycle (can also be called with the `method` argument).">
	<cfset $registerCallback(type="afterNew", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterInitialization" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object has been initialized."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterInitialization("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterInitialization", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidation" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidation("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeValidation", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidation" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidation("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterValidation", argumentCollection=arguments)>
</cffunction>

<!--- PRIVATE MODEL INITIALIZATION METHODS --->

<cffunction name="$registerCallback" returntype="void" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="methods" type="string" required="true">
	<cfscript>
		var loc = {};
		// create this type in the array if it doesn't already exist
		if (not StructKeyExists(variables.wheels.class.callbacks,arguments.type))
			variables.wheels.class.callbacks[arguments.type] = ArrayNew(1);
		loc.existingCallbacks = ArrayToList(variables.wheels.class.callbacks[arguments.type]);
		if (StructKeyExists(arguments, "method"))
			arguments.methods = arguments.method;
		arguments.methods = $listClean(arguments.methods);
		loc.iEnd = ListLen(arguments.methods);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			if (!ListFindNoCase(loc.existingCallbacks, ListGetAt(arguments.methods, loc.i)))
				ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, loc.i));
	</cfscript>
</cffunction>

<cffunction name="$clearCallbacks" returntype="void" access="public" output="false" hint="Removes all callbacks registered for this model. Pass in the `type` argument to only remove callbacks for that specific type.">
	<cfargument name="type" type="string" required="false" default="" hint="Type of callback (`beforeSave` etc).">
	<cfscript>
		var loc = {};
		// clean up the list of types passed in
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

<cffunction name="$callbacks" returntype="any" access="public" output="false" hint="Returns all registered callbacks for this model (as a struct). Pass in the `type` argument to only return callbacks for that specific type (as an array).">
	<cfargument name="type" type="string" required="false" default="" hint="@$clearCallbacks.">
	<cfscript>
		if (Len(arguments.type))
		{
			if (StructKeyExists(variables.wheels.class.callbacks,arguments.type))
				return variables.wheels.class.callbacks[arguments.type];
			return ArrayNew(1);
		}
		return variables.wheels.class.callbacks;
	</cfscript>
</cffunction>


<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$callback" returntype="boolean" access="public" output="false" hint="Executes all callback methods for a specific type. Will stop execution on the first callback that returns `false`.">
	<cfargument name="type" type="string" required="true" hint="@$clearCallbacks.">
	<cfargument name="execute" type="boolean" required="true" hint="A query is passed in here for `afterFind` callbacks.">
	<cfargument name="collection" type="any" required="false" default="" hint="A query is passed in here for `afterFind` callbacks.">
	<cfscript>
		var loc = {};

		if (!arguments.execute)
			return true;

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
					loc.returnValue = $queryCallback(method=loc.method, collection=arguments.collection);
				}
				else
				{
					loc.invokeArgs = properties();
					loc.returnValue = $invoke(method=loc.method, invokeArgs=loc.invokeArgs);
					if (StructKeyExists(loc, "returnValue") && IsStruct(loc.returnValue))
					{
						setProperties(loc.returnValue);
						StructDelete(loc, "returnValue");
					}
				}
			}
			else
			{
				// this is a regular callback so just call the method
				loc.returnValue = $invoke(method=loc.method);
			}

			// break the loop if the callback returned false
			if (StructKeyExists(loc, "returnValue") && IsBoolean(loc.returnValue) && !loc.returnValue)
				break;
		}

		// return true by default (happens when no callbacks are set or none of the callbacks returned a result)
		if (!StructKeyExists(loc, "returnValue"))
			loc.returnValue = true;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$initalizeCallBacks" returntype="void" access="public" output="false">
	<cfargument name="callbacks" type="string" required="true">
	<cfscript>
	var loc = {};
	arguments.callbacks = $listClean(arguments.callbacks);
	loc.iEnd = ListLen(arguments.callbacks);
	for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
	{
		variables.wheels.class.callbacks[ListGetAt(arguments.callbacks, loc.i)] = ArrayNew(1);
	}
	</cfscript>
</cffunction>