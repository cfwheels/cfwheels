# stripLinks()

## Description
Removes all links from an HTML string, leaving just the link text.

## Function Syntax
	stripLinks( html )


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
			<td>The HTML to remove links from.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#stripLinks("<strong>Wheels</strong> is a framework for <a href="http://www.adobe.com/products/coldfusion/">ColdFusion</a>.")#
		-> <strong>Wheels</strong> is a framework for ColdFusion.
