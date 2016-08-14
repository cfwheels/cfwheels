<cfscript>
	/*
	* PUBLIC MODEL INITIALIZATION METHOD
	*/

	public void function afterCreate(string methods="") {
		$registerCallback(type="afterCreate", argumentCollection=arguments);
	}

	public void function afterDelete(string methods="") {
		$registerCallback(type="afterDelete", argumentCollection=arguments);
	}

	public void function afterFind(string methods="") {
		$registerCallback(type="afterFind", argumentCollection=arguments);
	}

	public void function afterInitialization(string methods="") {
		$registerCallback(type="afterInitialization", argumentCollection=arguments);
	}

	public void function afterNew(string methods="") {
		$registerCallback(type="afterNew", argumentCollection=arguments);
	}

	public void function afterSave(string methods="") {
		$registerCallback(type="afterSave", argumentCollection=arguments);
	}

	public void function afterUpdate(string methods="") {
		$registerCallback(type="afterUpdate", argumentCollection=arguments);
	}

	public void function afterValidation(string methods="") {
		$registerCallback(type="afterValidation", argumentCollection=arguments);
	}

	public void function afterValidationOnCreate(string methods="") {
		$registerCallback(type="afterValidationOnCreate", argumentCollection=arguments);
	}

	public void function afterValidationOnUpdate(string methods="") {
		$registerCallback(type="afterValidationOnUpdate", argumentCollection=arguments);
	}

	public void function beforeCreate(string methods="") {
		$registerCallback(type="beforeCreate", argumentCollection=arguments);
	}

	public void function beforeDelete(string methods="") {
		$registerCallback(type="beforeDelete", argumentCollection=arguments);
	}

	public void function beforeSave(string methods="") {
		$registerCallback(type="beforeSave", argumentCollection=arguments);
	}

	public void function beforeUpdate(string methods="") {
		$registerCallback(type="beforeUpdate", argumentCollection=arguments);
	}

	public void function beforeValidation(string methods="") {
		$registerCallback(type="beforeValidation", argumentCollection=arguments);
	}

	public void function beforeValidationOnCreate(string methods="") {
		$registerCallback(type="beforeValidationOnCreate", argumentCollection=arguments);
	}

	public void function beforeValidationOnUpdate(string methods="") {
		$registerCallback(type="beforeValidationOnUpdate", argumentCollection=arguments);
	}

	/*
	* PRIVATE METHODS
	*/
	public void function $registerCallback(required string type, required string methods) {  
		// create this type in the array if it doesn't already exist
		if (!StructKeyExists(variables.wheels.class.callbacks,arguments.type))
		{
			variables.wheels.class.callbacks[arguments.type] = ArrayNew(1);
		}

		local.existingCallbacks = ArrayToList(variables.wheels.class.callbacks[arguments.type]);
		if (StructKeyExists(arguments, "method"))
		{
			arguments.methods = arguments.method;
		}
		arguments.methods = $listClean(arguments.methods);
		local.iEnd = ListLen(arguments.methods);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			if (!ListFindNoCase(local.existingCallbacks, ListGetAt(arguments.methods, local.i)))
			{
				ArrayAppend(variables.wheels.class.callbacks[arguments.type], ListGetAt(arguments.methods, local.i));
			}
		} 
	}

	public void function $clearCallbacks(string type="") { 
		arguments.type = $listClean(list="#arguments.type#", returnAs="array");

		// no type(s) was passed in. get all the callback types registered
		if (ArrayIsEmpty(arguments.type))
		{
			arguments.type = ListToArray(StructKeyList(variables.wheels.class.callbacks));
		}

		// loop through each callback type and clear it
		local.iEnd = ArrayLen(arguments.type);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			variables.wheels.class.callbacks[arguments.type[local.i]] = [];
		} 
	}

	public any function $callbacks(string type="") { 
		if (Len(arguments.type))
		{
			if (StructKeyExists(variables.wheels.class.callbacks, arguments.type))
			{
				local.rv = variables.wheels.class.callbacks[arguments.type];
			}
			else
			{
				local.rv = ArrayNew(1);
			}
		}
		else
		{
			local.rv = variables.wheels.class.callbacks;
		} 
		return local.rv;
	}

	public boolean function $callback(
		required string type,
		required boolean execute,
		any collection=""
	) { 
		if (arguments.execute)
		{
			// get all callbacks for the type and loop through them all until the end or one of them returns false
			local.callbacks = $callbacks(arguments.type);
			local.iEnd = ArrayLen(local.callbacks);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.method = local.callbacks[local.i];
				if (arguments.type == "afterFind")
				{
					// since this is an afterFind callback we need to handle it differently
					if (IsQuery(arguments.collection))
					{
						local.rv = $queryCallback(method=local.method, collection=arguments.collection);
					}
					else
					{
						local.invokeArgs = properties();
						local.rv = $invoke(method=local.method, invokeArgs=local.invokeArgs);
						if (StructKeyExists(local, "rv") && IsStruct(local.rv))
						{
							setProperties(local.rv);
							StructDelete(local, "rv");
						}
					}
				}
				else
				{
					// this is a regular callback so just call the method
					local.rv = $invoke(method=local.method);
				}

				// break the loop if the callback returned false
				if (StructKeyExists(local, "rv") && IsBoolean(local.rv) && !local.rv)
				{
					break;
				}
			}
		}

		// return true by default (happens when no callbacks are set or none of the callbacks returned a result)
		if (!StructKeyExists(local, "rv"))
		{
			local.rv = true;
		} 
		return local.rv;
	}

	public boolean function $queryCallback(required string method, required query collection) {
		// we return true by default
		// will be overridden only if the callback method returns false on one of the iterations
		local.rv = true;

		// loop over all query rows and execute the callback method for each
		local.iEnd = arguments.collection.recordCount;
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			// get the values in the current query row so that we can pass them in as arguments to the callback method
			local.invokeArgs = {};
			local.jEnd = ListLen(arguments.collection.columnList);
			for (local.j=1; local.j <= local.jEnd; local.j++)
			{
				local.item = ListGetAt(arguments.collection.columnList, local.j);
				try
				{
					// coldfusion has a problem with empty strings in queries for bit types
					local.invokeArgs[local.item] = arguments.collection[local.item][local.i];
				}
				catch (Any e)
				{
					local.invokeArgs[local.item] = "";
				}
			}

			// execute the callback method
			local.result = $invoke(method=arguments.method, invokeArgs=local.invokeArgs);

			if (StructKeyExists(local, "result"))
			{
				if (IsStruct(local.result))
				{
					// the arguments struct was returned so we need to add the changed values to the query row
					for (local.key in local.result)
					{
						// add a new column to the query if a value was passed back for a column that did not exist originally
						if (!ListFindNoCase(arguments.collection.columnList, local.key))
						{
							QueryAddColumn(arguments.collection, local.key, ArrayNew(1));
						}
						arguments.collection[local.key][local.i] = local.result[local.key];
					}
				}
				else if (IsBoolean(local.result) && !local.result)
				{
					// break the loop and return false if the callback returned false
					local.rv = false;
					break;
				}
			}
		}

		// update the request with a hash of the query if it changed so that we can find it with pagination
		local.querykey = $hashedKey(arguments.collection);
		if (!StructKeyExists(request.wheels, local.querykey))
		{
			request.wheels[local.querykey] = variables.wheels.class.modelName;
		}	
		return local.rv;
	}
</cfscript>