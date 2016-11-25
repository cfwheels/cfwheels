<cfscript>
	/*
	* PUBLIC MODEL CLASS METHODS
	*/

	public numeric function deleteAll(
		string where="",
		string include="",
		boolean reload,
		any parameterize,
		boolean instantiate,
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false",
		boolean softDelete="true"
	) {
		$args(name="deleteAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		arguments.where = $cleanInList(arguments.where);
		if (arguments.instantiate)
		{
			local.rv = 0;
			local.objects = findAll(where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
			local.iEnd = ArrayLen(local.objects);
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				if (local.objects[local.i].delete(parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks, softDelete=arguments.softDelete))
				{
					local.rv++;
				}
			}
		}
		else
		{
			arguments.sql = [];
			arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			local.rv = invokeWithTransaction(method="$deleteAll", argumentCollection=arguments);
		}
		return local.rv;
	}

	public boolean function deleteByKey(
		required any key,
		boolean reload,
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false",
		boolean softDelete="true"
	) {
		$args(name="deleteByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		local.where = $keyWhereString(values=arguments.key);
		local.rv = deleteOne(where=local.where, reload=arguments.reload, transaction=arguments.transaction, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, softDelete=arguments.softDelete);
		return local.rv;
	}

	public boolean function deleteOne(
		string where="",
		string order="",
		boolean reload,
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false",
		boolean softDelete="true"
	) {
		$args(name="deleteOne", args=arguments);
		local.object = findOne(where=arguments.where, order=arguments.order, reload=arguments.reload, includeSoftDeletes=arguments.includeSoftDeletes);
		if (IsObject(local.object))
		{
			local.rv = local.object.delete(transaction=arguments.transaction, callbacks=arguments.callbacks, softDelete=arguments.softDelete);
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
	public boolean function delete(
		any parameterize,
		string transaction="#application.wheels.transactionMode#",
		boolean callbacks="true",
		boolean includeSoftDeletes="false",
		boolean softDelete="true"
	) {
		$args(name="delete", args=arguments);
		arguments.sql = [];
		arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
		arguments.sql = $addKeyWhereClause(sql=arguments.sql, includeSoftDeletes=arguments.includeSoftDeletes);
		local.rv = invokeWithTransaction(method="$delete", argumentCollection=arguments);
		return local.rv;
	}

	/*
	* PRIVATE METHODS
	*/
	public numeric function $deleteAll() {
		local.deleted = variables.wheels.class.adapter.$querySetup(sql=arguments.sql, parameterize=arguments.parameterize);
		local.rv = local.deleted.result.recordCount;
		return local.rv;
	}

	public boolean function $delete() {
		local.rv = false;
		if ($callback("beforeDelete", arguments.callbacks))
		{
			// delete dependents before the main record in case of foreign key constraints
			$deleteDependents();

			local.deleted = variables.wheels.class.adapter.$querySetup(sql=arguments.sql, parameterize=arguments.parameterize);
			if (local.deleted.result.recordCount == 1 && $callback("afterDelete", arguments.callbacks))
			{
				local.rv = true;
			}
		}
		return local.rv;
	}
</cfscript>
