# delete()

## Description
Deletes the object, which means the row is deleted from the database (unless prevented by a `beforeDelete` callback). Returns `true` on successful deletion of the row, `false` otherwise.

## Function Syntax
	delete( [ parameterize, transaction, callbacks, includeSoftDeletes, softDelete ] )


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
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
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
	
		<!--- Get a post object and then delete it from the database --->
		<cfset post = model("post").findByKey(33)>
		<cfset post.delete()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `deleteComment` method below will call `comment.delete()` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comment = model("comment").findByKey(params.commentId)>
		<cfset post.deleteComment(comment)>
