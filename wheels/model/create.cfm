<cfscript>
	/*
	* PUBLIC MODEL CLASS METHODS
	*/

	public any function create(
		struct properties={},
		any parameterize,
		boolean reload,
		boolean validate=true,
		string transaction=application.wheels.transactionMode,
		boolean callbacks=true
	) {
		$args(name="create", args=arguments);
		local.parameterize = arguments.parameterize;
		StructDelete(arguments, "parameterize");
		local.validate = arguments.validate;
		StructDelete(arguments, "validate");
		local.rv = new(argumentCollection=arguments);
		local.rv.save(parameterize=local.parameterize, reload=arguments.reload, validate=local.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
		return local.rv;
	}

	public any function new(struct properties={}, boolean callbacks=true) {
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="properties,reload,transaction,callbacks", setOnModel=false);
		local.rv = $createInstance(properties=arguments.properties, persisted=false, callbacks=arguments.callbacks);
		local.rv.$setDefaultValues();
		return local.rv;
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/
	public boolean function save(
		any parameterize,
		boolean reload,
		boolean validate=true,
		string transaction=application.wheels.transactionMode,
		boolean callbacks=true
	) {
		$args(name="save", args=arguments);
		clearErrors();
		local.rv = invokeWithTransaction(method="$save", argumentCollection=arguments);
		return local.rv;
	}

	/*
	* PRIVATE METHODS
	*/

	public any function $createInstance(
		required struct properties,
		required boolean persisted,
		numeric row=1,
		boolean base=true,
		boolean callbacks=true
	) {
		local.fileName = $objectFileName(name=variables.wheels.class.modelName, objectPath=variables.wheels.class.path, type="model");
		local.rv = $createObjectFromRoot(path=variables.wheels.class.path, fileName=local.fileName, method="$initModelObject", name=variables.wheels.class.modelName, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row, base=arguments.base, useFilterLists=(!arguments.persisted));

		// if the object should be persisted, call afterFind else call afterNew
		if ((arguments.persisted && local.rv.$callback("afterFind", arguments.callbacks)) || (!arguments.persisted && local.rv.$callback("afterNew", arguments.callbacks)))
		{
			local.rv.$callback("afterInitialization", arguments.callbacks);
		}
		return local.rv;
	}

	public boolean function $save(
		required any parameterize,
		required boolean reload,
		required boolean validate,
		required boolean callbacks
	) {
		local.rv = false;
		// make sure all of our associations are set properly before saving
		$setAssociations();

		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave,onCreate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeCreate", arguments.callbacks))
				{
					local.rollback = false;
					if (!Len(key()))
					{
						local.rollback = true;
					}
					$create(parameterize=arguments.parameterize, reload=arguments.reload);
					if ($saveAssociations(argumentCollection=arguments) && $callback("afterCreate", arguments.callbacks) && $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						local.rv = true;
					}
					else if (local.rollback)
					{
						$resetToNew();
					}
				}
				else
				{
					$validateAssociations(callbacks=arguments.callbacks);
				}
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave,onUpdate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeUpdate", arguments.callbacks))
				{
					$update(parameterize=arguments.parameterize, reload=arguments.reload);
					if ($saveAssociations(argumentCollection=arguments) && $callback("afterUpdate", arguments.callbacks) && $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						local.rv = true;
					}
				}
				else
				{
					$validateAssociations(callbacks=arguments.callbacks);
				}
			}
		}
		else
		{
			$validateAssociations(callbacks=arguments.callbacks);
		}
		return local.rv;
	}

	public boolean function $create(required any parameterize, required boolean reload) {
		if (variables.wheels.class.timeStampingOnCreate)
		{
			$timestampProperty(property=variables.wheels.class.timeStampOnCreateProperty);
		}
		if (application.wheels.setUpdatedAtOnCreate && variables.wheels.class.timeStampingOnUpdate)
		{
			$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
		}

		// start by adding column names and values for the properties that exist on the object to two arrays
		local.sql = [];
		local.sql2 = [];
		for (local.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(this, local.key))
			{
				ArrayAppend(local.sql, variables.wheels.class.properties[local.key].column);
				ArrayAppend(local.sql, ",");
				ArrayAppend(local.sql2, $buildQueryParamValues(local.key));
				ArrayAppend(local.sql2, ",");
			}
		}

		if (ArrayLen(local.sql))
		{
			// create wrapping sql code and merge the second array that holds the values with the first one
			ArrayPrepend(local.sql, "INSERT INTO #tableName()# (");
			ArrayPrepend(local.sql2, " VALUES (");
			ArrayDeleteAt(local.sql, ArrayLen(local.sql));
			ArrayDeleteAt(local.sql2, ArrayLen(local.sql2));
			ArrayAppend(local.sql, ")");
			ArrayAppend(local.sql2, ")");
			local.iEnd = ArrayLen(local.sql);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				ArrayAppend(local.sql, local.sql2[local.i]);
			}

			// map the primary keys down to the sql columns
			local.pks = ListToArray(primaryKeys());
			local.iEnd = ArrayLen(local.pks);
			for(local.i=1; local.i <= local.iEnd; local.i++)
			{
				local.pks[local.i] = variables.wheels.class.properties[local.pks[local.i]].column;
			}
			local.pks = ArrayToList(local.pks);
		}
		else
		{
			// no properties were set on the object so we insert a record with only default values to the database
			local.pks = primaryKey(0);
			ArrayAppend(local.sql, "INSERT INTO #tableName()#" & variables.wheels.class.adapter.$defaultValues($primaryKey=local.pks));
		}

		// run the insert sql statement and set the primary key value on the object (if one was returned from the database)
		local.ins = variables.wheels.class.adapter.$query(sql=local.sql, parameterize=arguments.parameterize, $primaryKey=local.pks);
		local.generatedKey = variables.wheels.class.adapter.$generatedKey();

		if (StructKeyExists(local.ins.result, local.generatedKey)){
			this[primaryKeys(1)] = local.ins.result[local.generatedKey];
		}

		if (arguments.reload){
			this.reload();
		}
		return true;
	}
</cfscript>