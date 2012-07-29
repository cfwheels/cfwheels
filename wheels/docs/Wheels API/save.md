# save()

## Description
Saves the object if it passes validation and callbacks. Returns `true` if the object was saved successfully to the database, `false` if not.

## Function Syntax
	save( [ parameterize, reload, validate, transaction, callbacks ] )


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
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to reload the object from the database once an insert/update has completed.</td>
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
		
	</tbody>
</table>


## Examples
	
		<!--- Save the user object to the database (will automatically do an `INSERT` or `UPDATE` statement depending on if the record is new or already exists --->
		<cfset user.save()>

		<!--- Save the user object directly in an if statement without using `cfqueryparam` and take appropriate action based on the result --->
		<cfif user.save(parameterize=false)>
			<cfset flashInsert(notice="The user was saved!")>
			<cfset redirectTo(action="edit")>
		<cfelse>
			<cfset flashInsert(alert="Error, please correct!")>
			<cfset renderView(action="edit")>
		</cfif>
