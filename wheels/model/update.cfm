<cfscript>

/**
* Updates all properties for the records that match the where argument. Property names and values can be passed in either using named arguments or as a struct to the properties argument. By default, objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in instantiate=true. This method returns the number of records that were updated.
*
* [section: Model Class]
* [category: Update Functions]
*
* @where This argument maps to the WHERE clause of the query. The following operators are supported: =, !=, <>, <, <=, >, >=, LIKE, NOT LIKE, IN, NOT IN, IS NULL, IS NOT NULL, AND, and OR. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.
* @include Associations that should be included in the query using INNER or LEFT OUTER joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. department,addresses,emails). You can build more complex include strings by using parentheses when the association is set on an included model, like album(artist(genre)), for example. These complex include strings only work when returnAs is set to query though.
* @properties The properties you want to set on the object (can also be passed in as named arguments).
* @reload false Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @parameterize Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @instantiate Whether or not to instantiate the object(s) first. When objects are not instantiated, any callbacks and validations set on them will be skipped.
* @validate Set to false to skip validations for this operation.
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
* @includeSoftDeletes You can set this argument to true to include soft-deleted records in the results.
*/
public numeric function updateAll(
	string where="",
	string include="",
	struct properties={},
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
	if (arguments.instantiate) {
		local.rv = 0;
		local.objects = findAll(where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
		local.iEnd = ArrayLen(local.objects);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			if (local.objects[local.i].update(properties=arguments.properties, parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks)) {
				local.rv++;
			}
		}
	} else {
		arguments.sql = [];
		ArrayAppend(arguments.sql, "UPDATE #tableName()# SET");
		local.pos = 0;
		for (local.key in arguments.properties) {
			local.pos++;
			ArrayAppend(arguments.sql, "#variables.wheels.class.properties[local.key].column# = ");
			local.param = {value=arguments.properties[local.key], type=variables.wheels.class.properties[local.key].type, dataType=variables.wheels.class.properties[local.key].dataType, scale=variables.wheels.class.properties[local.key].scale, null=!Len(arguments.properties[local.key])};
			ArrayAppend(arguments.sql, local.param);
			if (StructCount(arguments.properties) > local.pos) {
				ArrayAppend(arguments.sql, ",");
			}
		}
		arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
		arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
		local.rv = invokeWithTransaction(method="$updateAll", argumentCollection=arguments);
	}
	return local.rv;
}

/**
* Finds the object with the supplied key and saves it (if validation permits it) with the supplied properties and/or named arguments. Property names and values can be passed in either using named arguments or as a struct to the properties argument. Returns true if the object was found and updated successfully, false otherwise.
*
* [section: Model Class]
* [category: Update Functions]
*
* @key Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list, or a numeric value.
* @properties The properties you want to set on the object (can also be passed in as named arguments).
* @reload Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @validate Set to false to skip validations for this operation.
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
* @includeSoftDeletes You can set this argument to true to include soft-deleted records in the results.
*/
public boolean function updateByKey(
	required any key,
	struct properties={},
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
	return updateOne(argumentCollection=arguments);
}


/**
* Gets an object based on the arguments used and updates it with the supplied properties. Returns true if an object was found and updated successfully, false otherwise.
*
* [section: Model Class]
* [category: Update Functions]
*
* @where This argument maps to the WHERE clause of the query. The following operators are supported: =, !=, <>, <, <=, >, >=, LIKE, NOT LIKE, IN, NOT IN, IS NULL, IS NOT NULL, AND, and `OR. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.
* @order Maps to the ORDER BY clause of the query. You do not need to specify the table name(s); Wheels will do that for you.
* @properties The properties you want to set on the object (can also be passed in as named arguments).
* @reload Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @validate Set to false to skip validations for this operation.
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
* @includeSoftDeletesYou can set this argument to true to include soft-deleted records in the results.
*/
public boolean function updateOne(
	string where="",
	string order="",
	struct properties={},
	boolean reload,
	boolean validate="true",
	string transaction="#application.wheels.transactionMode#",
	boolean callbacks="true",
	boolean includeSoftDeletes="false"
) {
	$args(name="updateOne", args=arguments);
	local.object = findOne(
		includeSoftDeletes=arguments.includeSoftDeletes,
		order=arguments.order,
		reload=arguments.reload,
		where=arguments.where
	);
	StructDelete(arguments, "where");
	StructDelete(arguments, "order");
	if (IsObject(local.object)) {
		return local.object.update(argumentCollection=arguments);
	} else {
		return false;
	}
}


/**
* Updates the object with the supplied properties and saves it to the database. Returns true if the object was saved successfully to the database and false otherwise.
*
* [section: Model Object]
* [category: CRUD Functions]
*
* @properties The properties you want to set on the object (can also be passed in as named arguments).
* @parameterize Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @reload Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @validate Set to false to skip validations for this operation.
* @transcation Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
*/
public boolean function update(
	struct properties={},
	any parameterize,
	boolean reload,
	boolean validate="true",
	string transaction="#application.wheels.transactionMode#",
	boolean callbacks="true"
){
	$args(name="update", args=arguments);
	$setProperties(
		argumentCollection=arguments,
		filterList="properties,parameterize,reload,validate,transaction,callbacks"
	);
	return save(
		callbacks=arguments.callbacks,
		parameterize=arguments.parameterize,
		reload=arguments.reload,
		transaction=arguments.transaction,
		validate=arguments.validate
	);
}
/**
* Updates a single property and saves the record without going through the normal validation procedure. This is especially useful for boolean flags on existing records.
*
* [section: Model Object]
* [category: CRUD Functions]
*
* @property Name of the property to update the value for globally.
* @value Value to set on the given property globally.
* @parameterize Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
*/
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
	return update(argumentCollection=arguments);
}

/**
* Internal Function
**/
public numeric function $updateAll() {
	local.query = variables.wheels.class.adapter.$querySetup(parameterize=arguments.parameterize, sql=arguments.sql);
	return local.query.result.recordCount;
}

/**
* Internal Function
**/
public boolean function $update(required any parameterize, required boolean reload) {
	if (hasChanged()) {
		// perform update since changes have been made
		if (variables.wheels.class.timeStampingOnUpdate) {
			$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
		}
		local.sql = [];
		ArrayAppend(local.sql, "UPDATE #tableName()# SET ");
		for (local.key in variables.wheels.class.properties) {
			// include all changed non-key values in the update
			if (StructKeyExists(this, local.key) && !ListFindNoCase(primaryKeys(), local.key) && hasChanged(local.key)) {
				ArrayAppend(local.sql, "#variables.wheels.class.properties[local.key].column# = ");
				local.param = $buildQueryParamValues(local.key);
				ArrayAppend(local.sql, local.param);
				ArrayAppend(local.sql, ",");
			}
		}

		// only submit the update if we generated an sql set statement
		if (ArrayLen(local.sql) > 1) {
			ArrayDeleteAt(local.sql, ArrayLen(local.sql));
			local.sql = $addKeyWhereClause(sql=local.sql);
			local.upd = variables.wheels.class.adapter.$querySetup(sql=local.sql, parameterize=arguments.parameterize);
			if (arguments.reload) {
				this.reload();
			}
		}
	}
	return true;
}

</cfscript>
