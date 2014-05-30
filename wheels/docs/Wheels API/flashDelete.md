# flashDelete()

## Description
Deletes a specific key from the Flash.

## Function Syntax
	flashDelete( key )


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
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The key to delete.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfset flashDelete(key="errorMessage")>
