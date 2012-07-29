# deleteAll()

## Description
Deletes all records that match the `where` argument. By default, objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in `instantiate=true`. Returns the number of records that were deleted.

## Function Syntax
	deleteAll( [ where, include, reload, parameterize, instantiate, transaction, callbacks, includeSoftDeletes, softDelete ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>where</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `AND`, and `OR`. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>include</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>instantiate</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to instantiate the object(s) first. When objects are not instantiated, any callbacks and validations set on them will be skipped.</td>
		</tr>
		
		<tr>
			<td>transaction</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.</td>
		</tr>
		
		<tr>
			<td>callbacks</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to disable callbacks for this operation.</td>
		</tr>
		
		<tr>
			<td>includeSoftDeletes</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>You can set this argument to `true` to include soft-deleted records in the results.</td>
		</tr>
		
		<tr>
			<td>softDelete</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to permanently delete a record, even if it has a soft delete column.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Delete all inactive users without instantiating them (will skip validation and callbacks) --->
		<cfset recordsDeleted = model("user").deleteAll(where="inactive=1", instantiate=false)>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `deleteAllComments` method below will call `model("comment").deleteAll(where="postId=#post.id#")` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset howManyDeleted = post.deleteAllComments()>
