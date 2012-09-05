# dataSource()

## Description
Use this method to override the data source connection information for this model.

## Function Syntax
	dataSource( datasource, [ username, password ] )


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
			<td>datasource</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The data source name to connect to.</td>
		</tr>
		
		<tr>
			<td>username</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The username for the data source.</td>
		</tr>
		
		<tr>
			<td>password</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The password for the data source.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the data source named `users_source` instead of the default one whenever this model makes SQL calls  --->
  			<cfset dataSource("users_source")>
		</cffunction>
