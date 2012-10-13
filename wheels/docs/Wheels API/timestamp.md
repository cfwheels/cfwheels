# timestamp()

## Description
Returns a UTC or local timestamp

## Function Syntax
	timestamp( [ utc ] )


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
			<td>utc</td>
			<td>boolean</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Return current locale time --->
		<cfset currenttime = timestamp()>

		<!--- Return current UTC time --->
		<cfset currenttime = timestamp(utc=true)>
