# valid()

## Description
Runs the validation on the object and returns `true` if it passes it. Wheels will run the validation process automatically whenever an object is saved to the database, but sometimes it's useful to be able to run this method to see if the object is valid without saving it to the database.

## Function Syntax
	valid( [ callbacks ] )


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
			<td>callbacks</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to disable callbacks for this operation.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Check if a user is valid before proceeding with execution --->
		<cfset user = model("user").new(params.user)>
		<cfif user.valid()>
			<!--- Do something here --->
		</cfif>
