# obfuscateParam()

## Description
Obfuscates a value. Typically used for hiding primary key values when passed along in the URL.

## Function Syntax
	obfuscateParam( param )


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
			<td>param</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>Value to obfuscate.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Obfuscate the primary key value `99` --->
		<cfset newValue = obfuscateParam(99)>
