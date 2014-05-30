# flashKeyExists()

## Description
Checks if a specific key exists in the Flash.

## Function Syntax
	flashKeyExists( key )


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
			<td>key</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The key to check if it exists.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfif flashKeyExists("error")>
			<cfoutput>
				<p>#flash("error")#</p>
			</cfoutput>
		</cfif>
