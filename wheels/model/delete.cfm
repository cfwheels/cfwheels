<cfscript>

/**
 * Model class method.
 * Deletes all records that match the "where" argument.
 * Docs: http://docs.cfwheels.org/docs/deleteall
 */
public numeric function deleteAll(
	string where = "",
	string include = "",
	boolean reload,
	any parameterize,
	boolean instantiate,
	string transaction = application.wheels.transactionMode,
	boolean callbacks = true,
	boolean includeSoftDeletes = false,
	boolean softDelete = true
) {
	$args(name="deleteAll", args=arguments);
	arguments.include = $listClean(arguments.include);
	arguments.where = $cleanInList(arguments.where);
	if (arguments.instantiate) {
		local.rv = 0;
		local.objects = findAll(
			include=arguments.include,
			includeSoftDeletes=arguments.includeSoftDeletes,
			parameterize=arguments.parameterize,
			reload=arguments.reload,
			returnAs="objects",
			returnIncluded=false,
			where=arguments.where
		);
		local.iEnd = ArrayLen(local.objects);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.deleted = local.objects[local.i].delete(
				callbacks=arguments.callbacks,
				parameterize=arguments.parameterize,
				softDelete=arguments.softDelete,
				transaction=arguments.transaction
			);
			if (local.deleted) {
				local.rv++;
			}
		}
	} else {
		arguments.sql = [];
		arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
		arguments.sql = $addWhereClause(
			sql=arguments.sql,
			where=arguments.where,
			include=arguments.include,
			includeSoftDeletes=arguments.includeSoftDeletes
		);
		arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
		local.rv = invokeWithTransaction(method="$deleteAll", argumentCollection=arguments);
	}
	return local.rv;
}

/**
 * Model class method.
 * Finds the record with the supplied "key" and deletes it.
 * Docs: http://docs.cfwheels.org/docs/deletebykey
 */
public boolean function deleteByKey(
	required any key,
	boolean reload,
	string transaction = application.wheels.transactionMode,
	boolean callbacks = true,
	boolean includeSoftDeletes = false,
	boolean softDelete = true
) {
	$args(name="deleteByKey", args=arguments);
	$keyLengthCheck(arguments.key);
	local.where = $keyWhereString(values=arguments.key);
	return deleteOne(
		callbacks=arguments.callbacks,
		includeSoftDeletes=arguments.includeSoftDeletes,
		reload=arguments.reload,
		softDelete=arguments.softDelete,
		transaction=arguments.transaction,
		where=local.where
	);
}

/**
 * Model class method.
 * Gets an object based on conditions and deletes it.
 * Docs: http://docs.cfwheels.org/docs/deleteone
 */
public boolean function deleteOne(
	string where = "",
	string order = "",
	boolean reload,
	string transaction = application.wheels.transactionMode,
	boolean callbacks = true,
	boolean includeSoftDeletes = false,
	boolean softDelete = true
) {
	$args(name="deleteOne", args=arguments);
	local.object = findOne(
		includeSoftDeletes=arguments.includeSoftDeletes,
		order=arguments.order,
		reload=arguments.reload,
		where=arguments.where
	);
	if (IsObject(local.object)) {
		local.rv = local.object.delete(
			callbacks=arguments.callbacks,
			softDelete=arguments.softDelete,
			transaction=arguments.transaction
		);
	} else {
		local.rv = false;
	}
	return local.rv;
}

/**
 * Model object method.
 * Deletes the object, which means the row is deleted from the database.
 * Docs: http://docs.cfwheels.org/docs/delete
 */
public boolean function delete(
	any parameterize,
	string transaction = application.wheels.transactionMode,
	boolean callbacks = true,
	boolean includeSoftDeletes = false,
	boolean softDelete = true
) {
	$args(name="delete", args=arguments);
	arguments.sql = [];
	arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
	arguments.sql = $addKeyWhereClause(sql=arguments.sql, includeSoftDeletes=arguments.includeSoftDeletes);
	return invokeWithTransaction(method="$delete", argumentCollection=arguments);
}

/**
 * Internal method.
 * Deletes all records and return how many was deleted.
 * The only reason this is in its own method is so we can wrap it in an "invokeWithTransaction" call.
 */
public numeric function $deleteAll() {
	local.deleted = variables.wheels.class.adapter.$querySetup(sql=arguments.sql, parameterize=arguments.parameterize);
	return local.deleted.result.recordCount;
}

/**
 * Internal method.
 * Run delete callbacks, delete dependent child records and delete the record itself.
 * Return true if delete was successful (one record was deleted) and neither of the callbacks returned false.
 * The only reason this is in its own method is so we can wrap it in an "invokeWithTransaction" call.
 */
public boolean function $delete() {
	local.rv = false;
	if ($callback("beforeDelete", arguments.callbacks)) {

		// Delete dependent record(s).
		// Done before the main record is deleted to make sure eventual foreign key constraints does not prevent deletion.
		$deleteDependents();

		local.deleted = variables.wheels.class.adapter.$querySetup(sql=arguments.sql, parameterize=arguments.parameterize);
		if (local.deleted.result.recordCount == 1 && $callback("afterDelete", arguments.callbacks)) {
			local.rv = true;
		}
	}
	return local.rv;
}

</cfscript>
