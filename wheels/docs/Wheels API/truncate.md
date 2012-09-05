# truncate()

## Description
Truncates text to the specified length and replaces the last characters with the specified truncate string (which defaults to "...").

## Function Syntax
	truncate( text, [ length, truncateString ] )


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
			<td>Length to truncate the text to.</td>
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
	
		#truncate(text="Wheels is a framework for ColdFusion", length=20)#
		-> Wheels is a frame...

		#truncate(text="Wheels is a framework for ColdFusion", truncateString=" (more)")#
		-> Wheels is a framework f (more)
