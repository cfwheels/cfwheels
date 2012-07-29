# errorsOnBase()

## Description
Returns an array of all errors associated with the object as a whole (not related to any specific property).

## Function Syntax
	errorsOnBase( [ name ] )


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
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Specify an error name here to only return errors for that error name.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get all general type errors for the user object --->
		<cfset errors = user.errorsOnBase()>
