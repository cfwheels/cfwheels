<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="afterFind" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object has been initialized (which is usually done with the @findByKey or @findOne method)."
	examples=
	'
		<!--- Instruct Wheels to call the `setTime` method after getting objects or records with one of the finder methods --->
		<cffunction name="init">
			<cfset afterFind("setTime")>
		</cffunction>

		<cffunction name="setTime">
			<cfset arguments.fetchedAt = Now()>
			<cfreturn arguments>
		</cffunction>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterFind", argumentCollection=arguments)>
</cffunction>

<!--- PUBLIC MODEL INITIALIZATION METHODS --->

<cffunction name="beforeValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidationOnCreate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeValidationOnUpdate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidationOnCreate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterValidationOnCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterValidationOnUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is validated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterValidationOnUpdate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterValidationOnUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is saved."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeSave("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before a new object is created."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeCreate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an existing object is updated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeUpdate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterCreate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after a new object is created."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterCreate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterCreate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterUpdate" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an existing object is updated."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterUpdate("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterUpdate", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterSave" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is saved."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterSave("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterSave", argumentCollection=arguments)>
</cffunction>

<cffunction name="beforeDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called before an object is deleted."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset beforeDelete("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterDelete,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="beforeDelete", argumentCollection=arguments)>
</cffunction>

<cffunction name="afterDelete" returntype="void" access="public" output="false" hint="Registers method(s) that should be called after an object is deleted."
	examples=
	'
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterDelete("fixObj")>
	'
	categories="model-initialization,callbacks" chapters="object-callbacks" functions="afterCreate,afterFind,afterInitialization,afterNew,afterSave,afterUpdate,afterValidation,afterValidationOnCreate,afterValidationOnUpdate,beforeCreate,beforeDelete,beforeSave,beforeUpdate,beforeValidation,beforeValidationOnCreate,beforeValidationOnUpdate">
	<cfargument name="methods" type="string" required="false" default="" hint="@afterNew.">
	<cfset $registerCallback(type="afterDelete", argumentCollection=arguments)>
</cffunction>
<!--- PRIVATE MODEL OBJECT METHODS --->

<cffunction name="$queryCallback" returntype="boolean" access="public" output="false" hint="Loops over the passed in query, calls the callback method for each row and changes the query based on the arguments struct that is passed back.">
	<cfargument name="method" type="string" required="true" hint="The method to call.">
	<cfargument name="collection" type="query" required="true" hint="@$callback.">
	<cfscript>
		var loc = {};

		// we return true by default
		// will be overridden only if the callback method returns false on one of the iterations
		loc.returnValue = true;

		// loop over all query rows and execute the callback method for each
		loc.jEnd = arguments.collection.recordCount;
		for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
		{
			// get the values in the current query row so that we can pass them in as arguments to the callback method
			loc.invokeArgs = {};
			loc.kEnd = ListLen(arguments.collection.columnList);
			for (loc.k=1; loc.k <= loc.kEnd; loc.k++)
			{
				loc.kItem = ListGetAt(arguments.collection.columnList, loc.k);
				try // coldfusion has a problem with empty strings in queries for bit types
				{
					loc.invokeArgs[loc.kItem] = arguments.collection[loc.kItem][loc.j];
				}
				catch (Any e)
				{
					loc.invokeArgs[loc.kItem] = "";
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
							QueryAddColumn(arguments.collection, loc.key, ArrayNew(1));
						arguments.collection[loc.key][loc.j] = loc.result[loc.key];
					}
				}
				else if (IsBoolean(loc.result) && !loc.result)
				{
					// break the loop and return false if the callback returned false
					loc.returnValue = false;
					break;
				}
			}
		}

		// update the request with a hash of the query if it changed so that we can find it with pagination
		loc.querykey = $hashedKey(arguments.collection);
		if (!StructKeyExists(request.wheels, loc.querykey))
			request.wheels[loc.querykey] = variables.wheels.class.modelName;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>