# errorCount()

## Description
Returns the number of errors this object has associated with it. Specify `property` or `name` if you wish to count only specific errors.

## Function Syntax
	errorCount( [ property, name ] )


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
			<td>Specify a property name here if you want to count only errors set on a specific property.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Specify an error name here if you want to count only errors set with a specific error name.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Check how many errors are set on the object --->
		<cfif author.errorCount() GTE 10>
			<!--- Do something to deal with this very erroneous author here... --->
		</cfif>
		
		<!--- Check how many errors are associated with the `email` property --->
		<cfif author.errorCount("email") gt 0>
			<!--- Do something to deal with this erroneous author here... --->
		</cfif>
