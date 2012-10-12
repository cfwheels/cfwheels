# l()

## Description
Returns the localised value for the given locale

## Function Syntax
	l( key, [ locale ] )


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
			<td></td>
		</tr>
		
		<tr>
			<td>locale</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Return all the names of the months for US English --->
		<cfset monthNames = l("date.month_names", "en-US")>
