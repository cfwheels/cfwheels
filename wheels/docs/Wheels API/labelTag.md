# labelTag()

## Description
Builds and returns a string containing a label. Note: Pass any additional arguments like `class` and `rel`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	labelTag( for, [ value ] )


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
			<td>for</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name to populate in tag's `name` attribute.</td>
		</tr>
		
		<tr>
			<td>value</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Value to populate in tag's `value` attribute.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Basic usage usually involves a `label`, `name`, and `value` --->
		<cfoutput>
		    #labelTag(for="search", value="")#
		</cfoutput>
