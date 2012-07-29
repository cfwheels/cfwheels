# wordTruncate()

## Description
Truncates text to the specified length of words and replaces the remaining characters with the specified truncate string (which defaults to "...").

## Function Syntax
	wordTruncate( text, [ length, truncateString ] )


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
			<td>The text to truncate.</td>
		</tr>
		
		<tr>
			<td>length</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Number of words to truncate the text to.</td>
		</tr>
		
		<tr>
			<td>truncateString</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to replace the last characters with.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#wordTruncate(text="Wheels is a framework for ColdFusion", length=4)#
		-> Wheels is a framework...

		#truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")#
		-> Wheels is a framework for (more)
