# hasErrors()

## Description
Returns `true` if the object has any errors. You can also limit to only check a specific property or name for errors.

## Function Syntax
	hasErrors( [ property, name ] )


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
			<td>property</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the property to check if there are any errors set on.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Error name to check if there are any errors set with.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Check if the post object has any errors set on it --->
		<cfif post.hasErrors()>
			<!--- Send user to a form to correct the errors... --->
		</cfif>
