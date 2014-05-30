# provides()

## Description
Defines formats that the controller will respond with upon request. The format can be requested through a URL variable called `format`, by appending the format name to the end of a URL as an extension (when URL rewriting is enabled), or in the request header.

## Function Syntax
	provides( [ formats ] )


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
			<td>formats</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Formats to instruct the controller to provide. Valid values are `html` (the default), `xml`, `wddx`, `json`, `csv`, `pdf`, and `xls`.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
