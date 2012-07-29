# controller()

## Description
Creates and returns a controller object with your own custom `name` and `params`. Used primarily for testing purposes.

## Function Syntax
	controller( name, [ params ] )


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
			<td>true</td>
			<td></td>
			<td>Name of the controller to create.</td>
		</tr>
		
		<tr>
			<td>params</td>
			<td>struct</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>The params struct (combination of `form` and `URL` variables).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfset testController = controller("users", params)>
