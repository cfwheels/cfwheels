# clearErrors()

## Description
Clears out all errors set on the object or only the ones set for a specific property or name.

## Function Syntax
	clearErrors( [ property, name ] )


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
			<td>Specify a property name here if you want to clear all errors set on that property.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Specify an error name here if you want to clear all errors set with that error name.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Clear all errors on the object as a whole --->
		<cfset this.clearErrors()>
		
		<!--- Clear all errors on `firstName` --->
		<cfset this.clearErrors("firstName")>
