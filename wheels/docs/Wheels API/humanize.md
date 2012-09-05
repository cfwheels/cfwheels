# humanize()

## Description
Returns readable text by capitalizing and converting camel casing to multiple words.

## Function Syntax
	humanize( text, [ except ] )


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
			<td>text</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Text to humanize.</td>
		</tr>
		
		<tr>
			<td>except</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>a list of strings (space separated) to replace within the output.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Humanize a string, will result in "Wheels Is A Framework" --->
		#humanize("wheelsIsAFramework")#

		<!--- Humanize a string, force wheels to replace "Cfml" with "CFML" --->
		#humanize("wheelsIsACFMLFramework", "CFML")#
