# accessibleProperties()

## Description
Use this method to specify which properties can be set through mass assignment.

## Function Syntax
	accessibleProperties( [ properties ] )


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
			<td>properties</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Property name (or list of property names) that are allowed to be altered through mass assignment.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, only `isActive` can be set through mass assignment operations like `updateAll()` --->
		<cffunction name="init">
			<cfset accessibleProperties("isActive")>
		</cffunction>
