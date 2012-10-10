# stripTags()

## Description
Removes all HTML tags from a string.

## Function Syntax
	stripTags( html )


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
			<td>html</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The HTML to remove tag markup from.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#stripTags("<strong>Wheels</strong> is a framework for <a href="http://www.adobe.com/products/coldfusion/">ColdFusion</a>.")#
		-> Wheels is a framework for ColdFusion.
