# toXHTML()

## Description
Returns an XHTML-compliant string.

## Function Syntax
	toXHTML( text )


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
			<td>String to make XHTML-compliant.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Outputs `productId=5&amp;categoryId=12&amp;returningCustomer=1` --->
		<cfoutput>
			#toXHTML("productId=5&categoryId=12&returningCustomer=1")#
		</cfoutput>
