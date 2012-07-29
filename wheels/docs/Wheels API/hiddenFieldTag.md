# hiddenFieldTag()

## Description
Builds and returns a string containing a hidden field form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	hiddenFieldTag( name, [ value ] )


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
	
		<!--- Basic usage usually involves a `name` and `value` --->
		<cfoutput>
		    #hiddenFieldTag(name="userId", value=user.id)#
		</cfoutput>
