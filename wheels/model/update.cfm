<cfscript>
	/*
	* PUBLIC MODEL CLASS METHODS
	*/

	public numeric function updateAll(
		string where="",
		string include="",
		struct properties="#StructNew()#",
		boolean reload,
		any parameterize,
		boolean instantiate,
		boolean validate="true",
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false"
	) {
		$args(name="updateAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		arguments.where = $cleanInList(arguments.where);
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="where,include,properties,reload,parameterize,instantiate,validate,transaction,callbacks,includeSoftDeletes", setOnModel=false);

		// find and instantiate each object and call its update function
		if (arguments.instantiate)
		{
			local.rv = 0;
			local.objects = findAll(where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
			local.iEnd = ArrayLen(local.objects);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				if (local.objects[local.i].update(properties=arguments.properties, parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks))
				{
					local.rv++;
				}
			}
		}
		else
		{
			arguments.sql = [];
			ArrayAppend(arguments.sql, "UPDATE #tableName()# SET");
			local.pos = 0;
			for (local.key in arguments.properties)
			{
				local.pos++;
				ArrayAppend(arguments.sql, "#variables.wheels.class.properties[local.key].column# = ");
				local.param = {value=arguments.properties[local.key], type=variables.wheels.class.properties[local.key].type, dataType=variables.wheels.class.properties[local.key].dataType, scale=variables.wheels.class.properties[local.key].scale, null=!Len(arguments.properties[local.key])};
				ArrayAppend(arguments.sql, local.param);
				if (StructCount(arguments.properties) > local.pos)
				{
					ArrayAppend(arguments.sql, ",");
				}
			}
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			local.rv = invokeWithTransaction(method="$updateAll", argumentCollection=arguments);
		}
		return local.rv;
	}
	public boolean function updateByKey(
		required any key,
		struct properties="#StructNew()#",
		boolean reload,
		boolean validate="true",
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false"
	) {
		$args(name="updateByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		local.rv = updateOne(argumentCollection=arguments);
		return local.rv;
	}

	public boolean function updateOne(
		string where="",
		string order="",
		struct properties="#StructNew()#",
		boolean reload,
		boolean validate="true",
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false"
	) {
		$args(name="updateOne", args=arguments);
		local.object = findOne(where=arguments.where, order=arguments.order, reload=arguments.reload, includeSoftDeletes=arguments.includeSoftDeletes);
		StructDelete(arguments, "where");
		StructDelete(arguments, "order");
		if (IsObject(local.object))
		{
			local.rv = local.object.update(argumentCollection=arguments);
		}
		else
		{
			local.rv = false;
		}
		return local.rv;
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/

	public boolean function update(
		struct properties="#StructNew()#",
		any parameterize,
		boolean reload,
		boolean validate="true",
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true"
	){		
		$args(name="update", args=arguments);
		$setProperties(argumentCollection=arguments, filterList="properties,parameterize,reload,validate,transaction,callbacks");
		local.rv = save(parameterize=arguments.parameterize, reload=arguments.reload, validate=arguments.validate, transaction=arguments.transaction, callbacks=arguments.callbacks);
		return local.rv;
	}

	public boolean function updateProperty(
		string property,
		any value,
		any parameterize,
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true"
	) {
 		$args(name="updateProperty", args=arguments);
		arguments.reload = false;
		arguments.validate = false;
		if (StructKeyExists(arguments, "property") && StructKeyExists(arguments, "value")) {
			arguments.properties = {};
			arguments.properties[arguments.property] = arguments.value;
			StructDelete(arguments, "property");
			StructDelete(arguments, "value");
		}
		local.rv = update(argumentCollection=arguments);
		return local.rv;
	}

	/*
	* PRIVATE METHODS
	*/

	public numeric function $updateAll() {
		local.rv = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize).result.recordCount;
		return local.rv;
	}

	public boolean function $update(required any parameterize, required boolean reload) {		
		if (hasChanged())
		{
			// perform update since changes have been made
			if (variables.wheels.class.timeStampingOnUpdate)
			{
				$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
			}
			local.sql = [];
			ArrayAppend(local.sql, "UPDATE #tableName()# SET ");
			for (local.key in variables.wheels.class.properties)
			{
				// include all changed non-key values in the update
				if (StructKeyExists(this, local.key) && !ListFindNoCase(primaryKeys(), local.key) && hasChanged(local.key))
				{
					ArrayAppend(local.sql, "#variables.wheels.class.properties[local.key].column# = ");
					local.param = $buildQueryParamValues(local.key);
					ArrayAppend(local.sql, local.param);
					ArrayAppend(local.sql, ",");
				}
			}

			// only submit the update if we generated an sql set statement
			if (ArrayLen(local.sql) > 1)
			{
				ArrayDeleteAt(local.sql, ArrayLen(local.sql));
				local.sql = $addKeyWhereClause(sql=local.sql);
				local.upd = variables.wheels.class.adapter.$query(sql=local.sql, parameterize=arguments.parameterize);
				if (arguments.reload)
				{
					this.reload();
				}
			}
		}
		return true;
	}
</cfscript> 
 
