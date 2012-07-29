# deobfuscateParam()

## Description
Deobfuscates a value.

## Function Syntax
	deobfuscateParam( param )


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
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Value to deobfuscate.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get the original value from an obfuscated one --->
		<cfset originalValue = deobfuscateParam("b7ab9a50")>
