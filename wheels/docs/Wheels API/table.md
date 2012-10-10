# table()

## Description
Use this method to tell Wheels what database table to connect to for this model. You only need to use this method when your table naming does not follow the standard Wheels convention of a singular object name mapping to a plural table name.

## Function Syntax
	table( name )


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
			<td>name</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the table to map this model to.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the `tbl_USERS` table in the database for the `user` model instead of the default (which would be `users`) --->
			<cfset table("tbl_USERS")>
		</cffunction>
