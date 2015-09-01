<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="deleteAll" returntype="numeric" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="instantiate" type="boolean" required="false">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="softDelete" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="deleteAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		if (arguments.instantiate)
		{
			loc.rv = 0;
			loc.objects = findAll(select=propertyNames(), where=arguments.where, include=arguments.include, reload=arguments.reload, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes, returnIncluded=false, returnAs="objects");
			loc.iEnd = ArrayLen(loc.objects);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				if (loc.objects[loc.i].delete(parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks, softDelete=arguments.softDelete))
				{
					loc.rv++;
				}
			}
		}
		else
		{
			arguments.sql = [];
			arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			loc.rv = invokeWithTransaction(method="$deleteAll", argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="deleteByKey" returntype="boolean" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="softDelete" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="deleteByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		loc.where = $keyWhereString(values=arguments.key);
		loc.rv = deleteOne(where=loc.where, reload=arguments.reload, transaction=arguments.transaction, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, softDelete=arguments.softDelete);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="deleteOne" returntype="boolean" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="order" type="string" required="false" default="">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="softDelete" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="deleteOne", args=arguments);
		loc.object = findOne(where=arguments.where, order=arguments.order, reload=arguments.reload, includeSoftDeletes=arguments.includeSoftDeletes);
		if (IsObject(loc.object))
		{
			loc.rv = loc.object.delete(transaction=arguments.transaction, callbacks=arguments.callbacks, softDelete=arguments.softDelete);
		}
		else
		{
			loc.rv = false;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="delete" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="softDelete" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$args(name="delete", args=arguments);
		arguments.sql = [];
		arguments.sql = $addDeleteClause(sql=arguments.sql, softDelete=arguments.softDelete);
		arguments.sql = $addKeyWhereClause(sql=arguments.sql, includeSoftDeletes=arguments.includeSoftDeletes);
		loc.rv = invokeWithTransaction(method="$delete", argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$deleteAll" returntype="numeric" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.deleted = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize);
		loc.rv = loc.deleted.result.recordCount;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$delete" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if ($callback("beforeDelete", arguments.callbacks))
		{
			// delete dependents before the main record in case of foreign key constraints
			$deleteDependents();

			loc.deleted = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize);
			if (loc.deleted.result.recordCount == 1 && $callback("afterDelete", arguments.callbacks))
			{
				loc.rv = true;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>