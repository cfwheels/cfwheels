<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="deleteAll" returntype="numeric" access="public" output="false" hint="Deletes all records that match the `where` argument. By default, objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in `instantiate=true`. Returns the number of records that were deleted."
	examples=
	'
		<!--- Delete all inactive users without instantiating them (will skip validation and callbacks) --->
		<cfset recordsDeleted = model("user").deleteAll(where="inactive=1", instantiate=false)>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `deleteAllComments` method below will call `model("comment").deleteAll(where="postId=##post.id##")` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset howManyDeleted = post.deleteAllComments()>
	'
	categories="model-class,delete" chapters="deleting-records,associations" functions="delete,deleteByKey,deleteOne,hasMany">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="instantiate" type="boolean" required="false" hint="See documentation for @updateAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfargument name="softDelete" type="boolean" required="false" default="true" hint="See documentation for @delete.">
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

<cffunction name="deleteByKey" returntype="boolean" access="public" output="false" hint="Finds the record with the supplied key and deletes it. Returns `true` on successful deletion of the row, `false` otherwise."
	examples=
	'
		<!--- Delete the user with the primary key value of `1` --->
		<cfset result = model("user").deleteByKey(1)>
	'
	categories="model-class,delete" chapters="deleting-records" functions="delete,deleteAll,deleteOne">
	<cfargument name="key" type="any" required="true" hint="See documentation for @findByKey.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfargument name="softDelete" type="boolean" required="false" default="true" hint="See documentation for @delete.">
	<cfscript>
		var loc = {};
		$args(name="deleteByKey", args=arguments);
		$keyLengthCheck(arguments.key);
		loc.where = $keyWhereString(values=arguments.key);
		loc.rv = deleteOne(where=loc.where, reload=arguments.reload, transaction=arguments.transaction, callbacks=arguments.callbacks, includeSoftDeletes=arguments.includeSoftDeletes, softDelete=arguments.softDelete);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="deleteOne" returntype="boolean" access="public" output="false" hint="Gets an object based on conditions and deletes it."
	examples=
	'
		<!--- Delete the user that signed up last --->
		<cfset result = model("user").deleteOne(order="signupDate DESC")>

		<!--- If you have a `hasOne` association setup from `user` to `profile` you can do a scoped call (the `deleteProfile` method below will call `model("profile").deleteOne(where="userId=##aUser.id##")` internally) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset aUser.deleteProfile()>
	'
	categories="model-class,delete" chapters="deleting-records,associations" functions="delete,deleteAll,deleteOne,hasOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfargument name="softDelete" type="boolean" required="false" default="true" hint="See documentation for @delete.">
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

<cffunction name="delete" returntype="boolean" access="public" output="false" hint="Deletes the object, which means the row is deleted from the database (unless prevented by a `beforeDelete` callback). Returns `true` on successful deletion of the row, `false` otherwise."
	examples=
	'
		<!--- Get a post object and then delete it from the database --->
		<cfset post = model("post").findByKey(33)>
		<cfset post.delete()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `deleteComment` method below will call `comment.delete()` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comment = model("comment").findByKey(params.commentId)>
		<cfset post.deleteComment(comment)>
	'
	categories="model-object,crud" chapters="deleting-records,associations" functions="deleteAll,deleteByKey,deleteOne,hasMany">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
	<cfargument name="softDelete" type="boolean" required="false" default="true" hint="Set to `false` to permanently delete a record, even if it has a soft delete column.">
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

<!--- PRIVATE MODEL CLASS METHODS --->

<cffunction name="$deleteAll" returntype="numeric" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.deleted = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize);
		loc.rv = loc.deleted.result.recordCount;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

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