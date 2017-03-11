<cfscript>
/**
* Deletes all records that match the where argument. By default, objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in instantiate=true. Returns the number of records that were deleted.
*
* [section: Model Class]
* [category: Delete Functions]
*
* @where This argument maps to the WHERE clause of the query. The following operators are supported: =, !=, <>, <, <=, >, >=, LIKE, NOT LIKE, IN, NOT IN, IS NULL, IS NOT NULL, AND, and OR. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.
* @include Associations that should be included in the query using INNER or LEFT OUTER joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. department,addresses,emails). You can build more complex include strings by using parentheses when the association is set on an included model, like album(artist(genre)), for example. These complex include strings only work when returnAs is set to query though.
* @reload Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @parameterize Set to true to use cfqueryparam on all columns, or pass in a list of property names to use cfqueryparam on those only.
* @instantiate Whether or not to instantiate the object(s) first. When objects are not instantiated, any callbacks and validations set on them will be skipped.
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
* @includeSoftDeletes You can set this argument to true to include soft-deleted records in the results.
* @softDelete Set to false to permanently delete a record, even if it has a soft delete column.
*
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
* Finds the record with the supplied key and deletes it. Returns true on successful deletion of the row, false otherwise.
*
* [section: Model Class]
* [category: Delete Functions]
*
* @key Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list, or a numeric value.
* @reload Set to true to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)
* @transaction Set this to commit to update the database when the save has completed, rollback to run all the database queries but not commit them, or none to skip transaction handling altogether.
* @callbacks Set to false to disable callbacks for this operation.
* @includeSoftDeletes  You can set this argument to true to include soft-deleted records in the results.
* @softDelete Set to false to permanently delete a record, even if it has a soft delete column.
*
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
