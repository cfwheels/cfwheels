# setPrimaryKey()

## Description
Allows you to pass in the name(s) of the property(s) that should be used as the primary key(s). Pass as a list if defining a composite primary key. Also aliased as `setPrimaryKeys()`.

## Function Syntax
	setPrimaryKey( property )


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
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Property (or list of properties) to set as the primary key.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, define the primary key as a column called `userID` --->
		<cffunction name="init">
			<cfset setPrimaryKey("userID")>
		</cffunction>
