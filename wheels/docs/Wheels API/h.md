# h()

## Description
Escapes unsafe HTML. Alias for your CFML engine's `XMLFormat()` function.

## Function Syntax
	h( content )


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
			<td>content</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#h("<b>This "is" a test string & it should format properly</b>")#
		-> &lt;b&gt;This &quot;is&quot; a test string &amp; it should format properly&lt;/b&gt;
