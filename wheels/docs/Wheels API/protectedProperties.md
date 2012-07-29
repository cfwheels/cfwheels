# protectedProperties()

## Description
Use this method to specify which properties cannot be set through mass assignment.

## Function Syntax
	protectedProperties( [ properties ] )


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
			<td>Property name (or list of property names) that are not allowed to be altered through mass assignment.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, `firstName` and `lastName` cannot be changed through mass assignment operations like `updateAll()` --->
		<cffunction name="init">
			<cfset protectedProperties("firstName,lastName")>
		</cffunction>
