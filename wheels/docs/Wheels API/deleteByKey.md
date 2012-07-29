# deleteByKey()

## Description
Finds the record with the supplied key and deletes it. Returns `true` on successful deletion of the row, `false` otherwise.

## Function Syntax
	deleteByKey( key, [ reload, transaction, callbacks, includeSoftDeletes, softDelete ] )


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
			<td>key</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list, or a numeric value.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)</td>
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
	
		<!--- Delete the user with the primary key value of `1` --->
		<cfset result = model("user").deleteByKey(1)>
