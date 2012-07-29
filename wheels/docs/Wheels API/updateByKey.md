# updateByKey()

## Description
Finds the object with the supplied key and saves it (if validation permits it) with the supplied properties and/or named arguments. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument. Returns `true` if the object was found and updated successfully, `false` otherwise.

## Function Syntax
	updateByKey( key, [ properties, reload, validate, transaction, callbacks, includeSoftDeletes ] )


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
			<td>properties</td>
			<td>struct</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>The properties you want to set on the object (can also be passed in as named arguments).</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)</td>
		</tr>
		
		<tr>
			<td>validate</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to skip validations for this operation.</td>
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
		
	</tbody>
</table>


## Examples
	
		<!--- Updates the object with `33` as the primary key value with values passed in through the URL/form --->
		<cfset result = model("post").updateByKey(33, params.post)>

		<!--- Updates the object with `33` as the primary key using named arguments --->
		<cfset result = model("post").updateByKey(key=33, title="New version of Wheels just released", published=1)>
