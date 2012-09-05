# setTableNamePrefix()

## Description
Sets a prefix to prepend to the table name when this model runs SQL queries.

## Function Syntax
	setTableNamePrefix( prefix )


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
			<td>prefix</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>A prefix to prepend to the table name.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, add a prefix to the default table name of `tbl` --->
		<cffunction name="init">
			<cfset setTableNamePrefix("tbl")>
		</cffunction>
